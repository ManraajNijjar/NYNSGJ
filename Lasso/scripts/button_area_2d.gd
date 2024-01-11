extends Area2D

@export var activationObjects = [];
var activating = [];

var active = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	active = activating.size() > 0;
	pass


func _on_body_entered(body:Node2D):
	if activationObjects.has(body):
		activating.append(body);
	pass # Replace with function body.


func _on_body_exited(body:Node2D):
	if activating.has(body):
		activating.remove_at(activating.find(body));
	pass # Replace with function body.
