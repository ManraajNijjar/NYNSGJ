extends Node2D

@onready var buttonCrate = $ButtonArea2D
@onready var buttonPanel = $ButtonArea2D2

@onready var groundMove = $GroundShort
@onready var groundMove2 = $GroundShort2
@onready var groundMove3 = $Environment/Ground2

var crate = preload("res://assets/crate_2d.tscn");
var timeBetweenCrates = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if buttonCrate.buttonActive == true && timeBetweenCrates <= 0:
		var newCrate = crate.instantiate();
		newCrate.useSunset = true;
		add_child(newCrate);
		newCrate.position = Vector2(-250, -400);
		timeBetweenCrates= 3;
	
	if buttonPanel.buttonActive == true:
		groundMove3.rotation += deg_to_rad(1);
		if groundMove3.rotation > deg_to_rad(90):
			groundMove3.rotation = deg_to_rad(90);
		pass
	
	timeBetweenCrates -= delta;
	pass
