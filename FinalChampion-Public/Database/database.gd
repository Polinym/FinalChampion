extends Node

const ControllerDB = preload("res://Database/Repository/ControllerDB.gd")

# the node to access the database
var controller

# Called when the node enters the scene tree for the first time.
func _ready():
	# This scene is to simulate accessing the database.
	# Actual access is performed by loading an instance of controllerDB.
	controller = ControllerDB.new()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
