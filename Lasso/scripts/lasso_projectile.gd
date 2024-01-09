extends RigidBody2D

@export var targetPosition : Vector2 = Vector2(0,0);
@export var originPosition : Vector2 = Vector2(0,0);
@export var force = 1.0;

@export var cowboy : Node2D;

@export var heldByHorse = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse((targetPosition - originPosition).normalized() * force * 1000, Vector2(0,0));
	if heldByHorse:
		collision_mask = 1;
	pass # Replace with function body.

func _on_area_2d_area_entered(area:Area2D):
	pass # Replace with function body.

func _on_area_2d_body_entered(body:Node2D):
	if body.is_in_group("lassoable"):
		if body.name == "Horse2D" and heldByHorse:
			return;
		cowboy.set_Lassoed(body);
		queue_free();
	pass # Replace with function body.


func _on_timer_timeout():
	queue_free();
	pass # Replace with function body.
