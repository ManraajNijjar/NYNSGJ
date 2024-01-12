extends Node2D


@export var useSunset : bool = false;
@onready var afternoon : Sprite2D = $BackgroundAfternoon
@onready var sunset : Sprite2D = $BackgroundSunset

# Called when the node enters the scene tree for the first time.
func _ready():
	afternoon.visible = !useSunset
	sunset.visible = useSunset
	pass # Replace with function body.
