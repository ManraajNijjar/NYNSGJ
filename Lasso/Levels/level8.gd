extends Node2D

var dynamite = preload("res://assets/dynamite.tscn");

var timeBetweenDynamites = 0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timeBetweenDynamites <= 0:
		var newDynamite = dynamite.instantiate();
		add_child(newDynamite);
		newDynamite.position = Vector2(0, -350);
		timeBetweenDynamites = 5;
	
	timeBetweenDynamites -= delta;
	pass

