extends Area2D

@export var useSunset: bool = false;
@export var isLevelOne: bool = true;
@export var victory: bool = false;
@export var nextScene : PackedScene;

@onready var sunset: Sprite2D = $CollisionShape2D/Sprite2DSunset
@onready var afternoon: Sprite2D = $CollisionShape2D/Sprite2DAfternoon
@onready var timer : Timer = $Timer
@onready var timerWhip : Timer = $WhipTimer

@onready var soundBankSignOn = $Sign_On
@onready var soundBankSignOff = $Sign_Off
@onready var soundBankWhipTransition = $Whip_Transition
@onready var soundBankLevelFinish = $Level_Finish
@onready var soundBankLevelFinish2 = $Level_Finish2
@onready var soundBankLevelMusic = $Level_Music
@onready var levelMusic = $AudioStreamPlayer2D

var hasCowboy = false;
var hasHorse = false;
var timeStarted = false;
var musicPlaying = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	afternoon.visible = !useSunset
	sunset.visible = useSunset
	if isLevelOne :
		#soundBankLevelMusic.post_event();
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		#soundBankLevelMusic.stop_event();
		pass

	if victory:
		if !timeStarted:
			#soundBankLevelMusic.stop_event();
			levelMusic.stop()
			soundBankLevelFinish.post_event();
			#soundBankLevelFinish2.post_event();
			timer.start();
			timerWhip.start();
			timeStarted = true;
		sunset.frame = 3;
		afternoon.frame = 3;
	elif hasCowboy && hasHorse:
		soundBankSignOn.post_event();
		victory = true;
		sunset.frame = 3;
		afternoon.frame = 3;
	elif hasCowboy:
		if(sunset.frame != 1 && sunset.frame != 2):
			soundBankSignOn.post_event();
		sunset.frame = 2;
		afternoon.frame = 2;
	elif hasHorse:
		if(sunset.frame != 1 && sunset.frame != 2):
			soundBankSignOn.post_event();
		sunset.frame = 1;
		afternoon.frame = 1;
	else:
		if(sunset.frame != 0):
			soundBankSignOff.post_event()
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


func _on_timer_timeout():
	soundBankLevelMusic.stop_event();
	soundBankLevelFinish.stop_event();
	get_tree().change_scene_to_packed(nextScene);
	pass # Replace with function body.


func _on_whip_timer_timeout():
	soundBankWhipTransition.post_event();
	pass # Replace with function body.

func stopMusic():
	soundBankLevelMusic.stop_event();
	pass

func _on_level_music_end_of_event(data:Dictionary):
	#musicPlaying = false;
	pass # Replace with function body.
