extends RigidBody2D

@export var isLassoed = false;
@export var pullStrength = 10000;
var cowboy;
# Called when the node enters the scene tree for the first time.
func _ready():
	cowboy = get_node("/root/Node2D/Cowboy2D");
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isLassoed:
		pass
		#lassoed(delta);
	pass

func lassoed(delta):
	if cowboy.get_global_position().distance_to(get_global_position()) > 75:
		if(abs(linear_velocity.x) < 300):
			apply_force((cowboy.get_global_position() - get_global_position()).normalized() * 1000, Vector2(0, 0));
	else:
		linear_velocity = Vector2(0, 0);

func set_lassoed(lassoed: bool):
	isLassoed = lassoed;
	if isLassoed:
		linear_velocity = Vector2(linear_velocity.x/10, linear_velocity.y/10);
	pass