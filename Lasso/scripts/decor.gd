extends Node2D

@export var useSunset = false;
@onready var afternoon = $Sprite2DAfternoon
@onready var sunset = $Sprite2DSunset

# Called when the node enters the scene tree for the first time.
func _ready():
	afternoon.visible = !useSunset
	sunset.visible = useSunset
