extends Node2D

@onready var button = $ButtonArea2D
@onready var rotateObject = $GroundLong

var rotationDestination = 0.0;
var rotationOriginal = -90.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if button.buttonActive == true :
		rotateObject.rotation += deg_to_rad(1);
		if rotateObject.rotation > deg_to_rad(0):
			rotateObject.rotation = deg_to_rad(0);
	else: 
		rotateObject.rotation -= deg_to_rad(30);
		if rotateObject.rotation < deg_to_rad(-90):
			rotateObject.rotation = deg_to_rad(-90);
	pass
