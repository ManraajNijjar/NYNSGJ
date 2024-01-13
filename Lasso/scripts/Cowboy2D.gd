extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var held = false;
@export var horse: CharacterBody2D = null;
var wasHeld = false;

var leftMouseHeld = false;
var leftMouseReleased = false;
var hasLassoedObject = false;
var lassoedObject = null;
var throwCharge = 0;
@export var lassoProjectile: PackedScene = null;
var currentLasso = null;
var lassoTimeOut = 0;

var horseLassoed = false;

var Rope = preload("res://assets/rope_2d.tscn");
var ropeToObject = null;
var timeToHorse = 1;


@onready var animationPlayer = $AnimationPlayer
@onready var sprite2D = $Sprite2D;
@onready var progressBar = $ProgressBar;
@onready var soundBankLassoThrow = $AkBank_Init/AkBank_Default_Soundbank/Lasso_Throw
@onready var soundBankLassoWhirl = $AkBank_Init/AkBank_Default_Soundbank/Lasso_Whirl
@onready var soundBankLassoCatch = $AkBank_Init/AkBank_Default_Soundbank/Lasso_Catch
@onready var soundBankBabyHeld = $AkBank_Init/AkBank_Default_Soundbank/Baby_Sits
@onready var soundBankBabyTalk = $AkBank_Init/AkBank_Default_Soundbank/Baby_Talk
@onready var soundBankBabyThrow = $AkBank_Init/AkBank_Default_Soundbank/Baby_Throw
@onready var soundBankBabyFly = $AkBank_Init/AkBank_Default_Soundbank/Baby_Fly

var babyFlyPlayed = false;


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed && !hasLassoedObject:
				leftMouseHeld = true;
			elif event.pressed && hasLassoedObject:
				if(lassoedObject!= null):
					lassoedObject.set_lassoed(false);
				lassoedObject = null;
				hasLassoedObject = false;
				ropeToObject.queue_free();
				lassoTimeOut = 0.5;
			else:
				leftMouseHeld = false;
				leftMouseReleased = true;
				hasLassoedObject = false;
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				if ropeToObject != null:
					#ropeToObject.remove_piece();
					pass

func _process(delta):
	if throwCharge == 0:
		soundBankLassoWhirl.stop_event();
	if leftMouseHeld && !hasLassoedObject && currentLasso == null:
		if throwCharge == 0:
			soundBankLassoWhirl.post_event();
		progressBar.visible = true;
		setAnimation("lasso_charge")
		throwCharge += 5 * delta;
		progressBar.value = throwCharge;
		if throwCharge > 10:
			throwCharge = 10;
		pass
	elif leftMouseReleased && !hasLassoedObject && currentLasso == null:
		progressBar.visible = false;
		setAnimation("lasso_out")
		if lassoTimeOut <= 0:
			throwLasso();
			soundBankLassoWhirl.stop_event();
		leftMouseReleased = false;
		pass
	else:
		if(ropeToObject != null || currentLasso != null):
			setAnimation("lasso_out")
		else:
			setAnimation("idle");
	lassoTimeOut -= delta;

func _physics_process(delta):
	if held:
		if !wasHeld:
			soundBankBabyHeld.post_event();
			soundBankBabyTalk.post_event();
		velocity.x = horse.velocity.x
		velocity.y = horse.velocity.y
		if(position.distance_to(horse.position) > 100):
			position = horse.position
		wasHeld = true;
	elif horseLassoed:
		var horsePosition = horse.position;
		var horseDistance = horsePosition.distance_to(position);
		if horseDistance > 40:
			velocity.x = (horsePosition.x - position.x) * (2 * timeToHorse);
			velocity.y = (horsePosition.y - position.y) * (2 * timeToHorse);
			timeToHorse += delta; 
		else:
			soundBankBabyFly.stop_event()
			horseLassoed = false;
			velocity.x = 0;
			velocity.y = 0;
			timeToHorse = 1;
	else:
		#Calculate remaining physics from being held by the horse
		if wasHeld:
			if velocity.x < 0:
				velocity.x = velocity.x + (200 * delta);
			elif velocity.x > 0:
				velocity.x = velocity.x - (200 * delta);
			if(abs(velocity.x) < 20):
				velocity.x = 0
				wasHeld = false;
				
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
	if abs(velocity.x) > 0:
		sprite2D.flip_h = velocity.x > 0;
	move_and_slide()


func throwLasso():
	soundBankLassoThrow.post_event();
	soundBankBabyThrow.post_event();
	var temp = lassoProjectile.instantiate()
	temp.targetPosition = get_global_mouse_position()
	var originPosition = global_position;
	if temp.targetPosition.x < originPosition.x:
		originPosition.x = originPosition.x - 10;
	else:
		originPosition.x = originPosition.x + 10;
	if temp.targetPosition.y < originPosition.y:
		originPosition.y = originPosition.y - 100;
	else:
		originPosition.y = originPosition.y + 10;
	temp.originPosition = originPosition;
	temp.force = throwCharge;
	temp.heldByHorse = held;
	temp.cowboy = self;
	add_child(temp);
	throwCharge = 0;
	currentLasso = temp;
	pass

func set_Lassoed(body: Node2D):
	if body.name == "Horse2D":
		soundBankBabyFly.post_event()
		soundBankLassoCatch.post_event()
		horseLassoed = true;
	else:
		soundBankLassoCatch.post_event();
		lassoedObject = body;
		hasLassoedObject = true;
		var rope = Rope.instantiate()
		add_child(rope);
		rope.spawn_rope_to_object(position, body);
		ropeToObject = rope;
		print(body.name);
		body.set_lassoed(true);
	pass

func set_Lassoed_Area(area: Area2D):
	var rope = Rope.instantiate()
	add_child(rope);
	rope.spawn_rope(position, area.global_position);

func setAnimation(animName: String):
	animationPlayer.play(animName);
