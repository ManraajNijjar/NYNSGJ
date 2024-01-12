extends Area2D

@export var useSunset: bool = false;
@export var victory: bool = false;

@onready var sunset: Sprite2D = $CollisionShape2D/Sprite2DSunset
@onready var afternoon: Sprite2D = $CollisionShape2D/Sprite2DAfternoon

var hasCowboy = false;
var hasHorse = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	afternoon.visible = !useSunset
	sunset.visible = useSunset
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if victory:
		sunset.frame = 3;
		afternoon.frame = 3;
	elif hasCowboy && hasHorse:
		victory = true;
		sunset.frame = 3;
		afternoon.frame = 3;
	elif hasCowboy:
		sunset.frame = 2;
		afternoon.frame = 2;
	elif hasHorse:
		sunset.frame = 1;
		afternoon.frame = 1;
	else:
		sunset.frame = 0;
		afternoon.frame = 0;
	pass



func _on_body_exited(body:Node2D):
	if body.name == "Horse2D":
		hasHorse = false;
	if body.name == "Cowboy2D":
		hasCowboy = false;
	pass # Replace with function body.

func _on_body_entered(body:Node2D):
	if body.name == "Horse2D":
		hasHorse = true;
	if body.name == "Cowboy2D":
		hasCowboy = true;
	pass # Replace with function body.
