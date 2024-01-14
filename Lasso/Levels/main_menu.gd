extends Control

@onready var startButton = $TextureButton;
@onready var menuMusic =  $AkBank_Init/AkBank_Default_Soundbank/Menu_Music

func _ready():
	Wwise.load_bank("Init");
	Wwise.load_bank("Default_Soundbank");
	menuMusic.post_event();
	pass

func _on_texture_button_pressed():
	menuMusic.stop_event();
	get_tree().change_scene_to_file("res://Levels/level1.tscn")
	pass # Replace with function body.
