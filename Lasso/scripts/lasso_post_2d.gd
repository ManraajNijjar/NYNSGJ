extends Area2D

@export var useSunset = false;
@export var useAlternate = false;

@onready var sunset: Sprite2D = $CollisionShape2D/Sprite2DSunset
@onready var afternoon: Sprite2D = $CollisionShape2D/Sprite2DAfternoon
@onready var afternoon2: Sprite2D = $CollisionShape2D/Sprite2DAfternoon2

# Called when the node enters the scene tree for the first time.
func _ready():
	if useSunset:
		afternoon.visible = false;
		afternoon2.visible = false;
		sunset.visible = true;
		if useAlternate:
			sunset.frame = 1;
		else:
			sunset.frame = 0;
	else:
		sunset.visible = false;
		if useAlternate:
			afternoon.visible = true;
			afternoon2.visible = false;
		else:
			afternoon.visible = false;
			afternoon2.visible = true;

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
