extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var holdArea = $Area2D/HoldArea
@export var cowboy : CharacterBody2D;

var bodiesInArea = [];

var canCarry = false;
var isCarrying = false;
var horseMoveDirection = 1;
var kickCooldown = 0.0;

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		horseMoveDirection = direction;
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("down"):
		print(canCarry);

	if Input.is_action_just_pressed("down") && canCarry && !isCarrying:
		cowboy.held = true;
		isCarrying = true;
	elif Input.is_action_just_pressed("down") && isCarrying:
		cowboy.held = false;
		isCarrying = false;
	
	if Input.is_action_just_pressed("kick") && kickCooldown <= 0.0:
		for body in bodiesInArea:
			if body.has_method("apply_impulse"):
				body.apply_impulse(Vector2(horseMoveDirection * 500, -500));
		kickCooldown = 0.5;
	if kickCooldown > 0.0:
		kickCooldown -= 1 * delta;
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
