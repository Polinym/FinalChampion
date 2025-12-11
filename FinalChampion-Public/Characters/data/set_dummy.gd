extends Node2D
var plr_name = "Dummy";
var Arts = "International Man of Mystery";
var Stamina = 0;
var Energy = 0;
var Strength = 0;
var Agility = 0;
var Reflexes = 0;
var moves = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func destroy():
	queue_free();
