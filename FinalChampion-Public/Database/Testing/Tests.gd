extends Node

# Import unit tests
const TestOpenDB = preload("res://Database/Testing/TestOpenDB.gd")
const TestControllerDB = preload("res://Database/Testing/TestControllerDB.gd")
const TestQueryDB = preload("res://Database/Testing/TestQueryDB.gd")

# Variables to instantiate the tests
var TOpen
var TController
var TQuery

# Called when the node enters the scene tree for the first time.
func _ready():
	# Instantiate the tests
	TOpen = TestOpenDB.new()
	TQuery = TestQueryDB.new()
	TController = TestControllerDB.new()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
