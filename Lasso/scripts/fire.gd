extends Area2D

@export var isMoving = false;
var originX = 0;
var maxRange = 200;
var moveLeft = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	originX = position.x;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isMoving:
		if moveLeft:
			position.x -= 10 * delta
			if position.x < originX - maxRange:
				moveLeft = false;
		else:
			position.x += 10 * delta
			if position.x > originX + maxRange:
				moveLeft = true;
			
	pass


func _on_body_entered(body:Node2D):
	if body.is_in_group("flammable"):
		body.setFire();
	pass # Replace with function body.
