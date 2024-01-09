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

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed && !hasLassoedObject:
				leftMouseHeld = true;
			elif event.pressed && hasLassoedObject:
				lassoedObject.set_lassoed(false);
				lassoedObject = null;
				hasLassoedObject = false;
				lassoTimeOut = 0.5;
			else:
				leftMouseHeld = false;
				leftMouseReleased = true;
				hasLassoedObject = false;

func _process(delta):
	if leftMouseHeld && !hasLassoedObject && currentLasso == null:
		throwCharge += 2 * delta;
		if throwCharge > 10:
			throwCharge = 10;
		pass
	elif leftMouseReleased && !hasLassoedObject && currentLasso == null:
		if lassoTimeOut <= 0:
			throwLasso();
		leftMouseReleased = false;
		pass
	lassoTimeOut -= delta;

func _physics_process(delta):
	if held:
		velocity.x = horse.velocity.x
		velocity.y = horse.velocity.y
		wasHeld = true;
	elif horseLassoed:
		print(horse);
		var horsePosition = horse.position;
		var horseDistance = horsePosition.distance_to(position);
		if horseDistance > 40:
			velocity.x = (horsePosition.x - position.x) * 2;
			velocity.y = (horsePosition.y - position.y) * 2;
		else:
			horseLassoed = false;
			velocity.x = 0;
			velocity.y = 0;
	else:
		#Calculate remaining physics from being held by the horse
		if wasHeld:
			print(velocity.x);
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

	move_and_slide()


func throwLasso():
	var temp = lassoProjectile.instantiate()
	temp.targetPosition = get_global_mouse_position()
	temp.originPosition = global_position;
	temp.force = throwCharge;
	temp.heldByHorse = held;
	temp.cowboy = self;
	add_child(temp);
	throwCharge = 0;
	currentLasso = temp;
	pass

func set_Lassoed(body: Node2D):
	print(body);
	if body.name == "Horse2D":
		horseLassoed = true;
	else:
		lassoedObject = body;
		hasLassoedObject = true;
		body.set_lassoed(true);
	pass