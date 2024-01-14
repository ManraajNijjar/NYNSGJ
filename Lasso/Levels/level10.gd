extends Node2D

@onready var victoryPlatform = $VictorySign
@onready var fire1 = $fire
@onready var fire2 = $fire2
@onready var fire3 = $fire3

var dynamite = preload("res://assets/dynamite.tscn");
var crate = preload("res://assets/crate_2d.tscn");

var launchAlternate = false;
var timeBetweenLaunch = 0;
var timeBetweenLaunchMax = 4;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if victoryPlatform.position.y <= 0:
		victoryPlatform.position.y = victoryPlatform.position.y + (10 * delta);
	
	if timeBetweenLaunch <= 0:
		if launchAlternate:
			spawnCrate(fire1.position)
			spawnDynamite(fire2.position)
			spawnCrate(fire3.position)
		else:
			spawnDynamite(fire1.position)
			spawnCrate(fire2.position)
			spawnDynamite(fire3.position)
		timeBetweenLaunch = timeBetweenLaunchMax;
		if(timeBetweenLaunch > 2):
			timeBetweenLaunchMax -= 0.1;
		launchAlternate = !launchAlternate
	timeBetweenLaunch -= delta;
	pass

func spawnDynamite(spawnSpot: Vector2):
	var newDynamite = dynamite.instantiate();
	add_child(newDynamite);
	newDynamite.position = spawnSpot;

func spawnCrate(spawnSpot: Vector2):
	var newCrate = crate.instantiate();
	add_child(newCrate);
	newCrate.position = spawnSpot;
