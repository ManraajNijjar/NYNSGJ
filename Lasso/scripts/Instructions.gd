extends Control

@onready var sprite2d : Sprite2D = $Sprite2D;

func _on_texture_button_mouse_exited():
	sprite2d.visible = false;
	pass # Replace with function body.

func _on_texture_button_mouse_entered():
	sprite2d.visible = true;
	pass # Replace with function body.
