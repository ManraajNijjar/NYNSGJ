extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var holdArea = $Area2D/HoldArea
@onready var animationPlayer = $AnimationPlayer
@onready var soundBankHorseWalk = $AkBank_Init/AkBank_Default_Soundbank/Horse_Walk
@onready var soundBankHorseKick = $AkBank_Init/AkBank_Default_Soundbank/Horse_Kick
@onready var soundBankHorseNeigh = $AkBank_Init/AkBank_Default_Soundbank/Horse_Neigh
@onready var soundBankHorseJump = $AkBank_Init/AkBank_Default_Soundbank/Horse_Jump
@onready var sprite2D = $Sprite2D
@export var cowboy : Node2D;
@export var kickCooldownMax : float = 0.2;

var bodiesInArea = [];

var canCarry = false;
var isCarrying = false;
var horseMoveDirection = 1;
var kickCooldown = 0.0;
var hasWalked = false;

func _ready():
	Wwise.load_bank("Init");
	Wwise.load_bank("Default_Soundbank");

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene();
	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		soundBankHorseJump.post_event();
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	
	if direction:
		if kickCooldown <= 0:
			sprite2D.flip_h = (direction != 1)
		setAnimation("walk");
		if !hasWalked:
			hasWalked = true;
			soundBankHorseWalk.post_event();
		horseMoveDirection = direction;
		velocity.x = direction * SPEED
	else:
		setAnimation("idle");
		hasWalked = false;
		soundBankHorseWalk.stop_event();
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("down") && canCarry && !isCarrying:
		cowboy.held = true;
		isCarrying = true;
	elif Input.is_action_just_pressed("down") && isCarrying:
		cowboy.held = false;
		isCarrying = false;
	
	if Input.is_action_just_pressed("kick") && kickCooldown <= 0.0:
		sprite2D.flip_h = !sprite2D.flip_h
		setAnimation("kick");
		soundBankHorseNeigh.post_event();
		soundBankHorseKick.post_event();
		for body in bodiesInArea:
			if body.has_method("apply_impulse"):
				body.apply_impulse(Vector2(horseMoveDirection * 500, -500));
		kickCooldown = kickCooldownMax;
	if kickCooldown > 0.0:
		kickCooldown -= delta;
	move_and_slide()



func _on_area_2d_body_entered(body:Node2D):
	if body.name == "Cowboy2D":
		canCarry = true;
	else:
		bodiesInArea.append(body);
	pass # Replace with function body.



func _on_area_2d_body_exited(body:Node2D):
	if body.name == "Cowboy2D":
		canCarry = false;
	else:
		bodiesInArea.remove_at(bodiesInArea.find(body));
	pass # Replace with function body.

func setAnimation(animName: String):
	if animationPlayer.current_animation != "kick":
		animationPlayer.play(animName);
