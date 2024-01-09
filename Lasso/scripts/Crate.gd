extends RigidBody3D

@export var lassod = false;
@export var cowboy : CharacterBody3D;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance = cowboy.get_global_position().distance_to(get_global_position());
	if lassod && distance > 1.5:
		#apply_force(Vector2(-1, -1), cowboy.get_global_position())
		apply_force((cowboy.get_global_position() - get_global_position()).normalized() * 10, Vector3(0, 0, 0));
		#set_constant_force((cowboy.get_global_position() - get_global_position()).normalized() * 10);
	if lassod && distance <= 1.5:
		linear_velocity = Vector3(0, 0, 0);
	pass
