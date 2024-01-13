extends RigidBody2D

@onready var sprite2D = $CollisionShape2D/Sprite2D
@onready var timer = $Area2D/Timer;
@onready var explosionArea = $Area2D;

@onready var soundBankDynamiteActivated = $Dynamite_Activated
@onready var soundBankDynamiteExplosion = $Dynamite_Explosion

func setFire():
	soundBankDynamiteActivated.post_event();
	sprite2D.frame = 1;
	timer.start();


func _on_timer_timeout():
	soundBankDynamiteExplosion.post_event();
	var bodies = explosionArea.get_overlapping_bodies();
	for body in bodies:
		if body.is_in_group("canBreak"):
			body.queue_free();
	queue_free()
	pass # Replace with function body.

func set_lassoed(isLasso):
	pass;
