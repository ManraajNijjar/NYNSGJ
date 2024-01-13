extends Control

@onready var startButton = $TextureButton;

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://Levels/level1.tscn")
	pass # Replace with function body.
