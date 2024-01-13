extends Area2D

@export var hunger = 0;
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var sprite2DIdle : Sprite2D = $CollisionShape2D/Sprite2DIdle
@onready var sprite2DWalk : Sprite2D = $CollisionShape2D/Sprite2DWalk

@onready var soundBankHogSleep = $AkBank_Init/AkBank_Default_Soundbank/Hog_Sleeping
@onready var soundBankHogWalk = $AkBank_Init/AkBank_Default_Soundbank/Hog_Walk
@onready var soundBankHogEat = $AkBank_Init/AkBank_Default_Soundbank/Hog_Eat

var leaving = false;
var finishWakeUp = false;
var sleepSoundPlaying = false;
var walkSoundPlaying = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_body_entered(body:Node2D):
	if body.is_in_group("edible"):
		soundBankHogEat.post_event();
		animationPlayer.play("eat");
		body.queue_free()
		hunger -=1;
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if leaving:
		if !walkSoundPlaying:
			walkSoundPlaying = true;
			soundBankHogWalk.post_event();
		position.x += 1;
	elif hunger <= 0 && finishWakeUp:
		sprite2DIdle.visible = false;
		sprite2DWalk.visible = true;
		leaving = true;
	elif !sleepSoundPlaying:
		sleepSoundPlaying = true;
		soundBankHogSleep.post_event();

func _on_animation_player_animation_finished(anim_name:StringName):
	print(anim_name);
	if anim_name == "eat" && hunger > 0:
		animationPlayer.play("idle");
	elif anim_name == "eat" && hunger <= 0:
		animationPlayer.play("wakeup");
	elif anim_name == "wakeup":
		finishWakeUp = true;
		animationPlayer.play("walk");
	elif anim_name == "walk":
		queue_free();
	pass # Replace with function body.


func _on_hog_eat_end_of_event(data:Dictionary):
	sleepSoundPlaying = false;