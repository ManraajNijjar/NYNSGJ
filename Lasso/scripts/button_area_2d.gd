extends Area2D

@export var useSunset : bool = false;
@onready var afternoon : Sprite2D = $Sprite2DAfternoon
@onready var sunset : Sprite2D = $Sprite2DSunset

var activating := [];

var buttonActive = false;

func _ready():
	afternoon.visible = !useSunset
	sunset.visible = useSunset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	buttonActive = activating.size() > 0;
	if buttonActive:
		afternoon.frame = 1;
		sunset.frame = 1;
	else:
		afternoon.frame = 0;
		sunset.frame = 0;
	pass


func _on_body_entered(body:Node2D):
	activating.append(body);
	pass # Replace with function body.


func _on_body_exited(body:Node2D):
	if activating.has(body):
		activating.remove_at(activating.find(body));
	pass # Replace with function body.
