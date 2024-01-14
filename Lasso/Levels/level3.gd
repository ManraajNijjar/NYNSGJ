extends Node2D

@onready var button = $ButtonArea2D
@onready var rotateObject = $GroundLong

@onready var soundBankRockMoving = $Rock_Moving

var rotationDestination = 0.0;
var rotationOriginal = -90.0;
var buttonPrevious = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if button.buttonActive == true :
		if buttonPrevious == false:
			soundBankRockMoving.post_event();
			buttonPrevious = true;
		rotateObject.rotation += deg_to_rad(1);
		if rotateObject.rotation > deg_to_rad(0):
			soundBankRockMoving.stop_event();
			rotateObject.rotation = deg_to_rad(0);
	else: 
		if buttonPrevious == true:
			soundBankRockMoving.stop_event();
			buttonPrevious = false;
		rotateObject.rotation -= deg_to_rad(30);
		if rotateObject.rotation < deg_to_rad(-90):
			rotateObject.rotation = deg_to_rad(-90);
	pass
