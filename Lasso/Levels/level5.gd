extends Node2D

@onready var button = $ButtonArea2D

var dynamite = preload("res://assets/dynamite.tscn");

var timeBetweenDynamites = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if button.buttonActive == true && timeBetweenDynamites <= 0:
		var newDynamite = dynamite.instantiate();
		add_child(newDynamite);
		newDynamite.position = Vector2(-80, -200);
		timeBetweenDynamites = 3;
	
	timeBetweenDynamites -= delta;

	pass
