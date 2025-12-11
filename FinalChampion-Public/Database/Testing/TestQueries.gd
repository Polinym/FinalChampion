extends Node

# Import the OpenDB script
const OpenDB = preload("res://Database/Repository/OpenDB.gd")
var open
var db

# Called when the node enters the scene tree for the first time.
func _init():
	open = OpenDB.new()
	db = open.getDB()
	runTests()
	pass # Replace with function body.

func runTests():
	var temp
	temp = testDatabaseOpening()
	print("testing if database opened successfully: ")
	pass

func testDatabaseOpening():
	if open.getOpen(): # If successfully opened the db
		# Test if you can close the db
		var closed = db.close_db()
		if closed:
			return true
	return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# functions that are called to test that queries will work
# Test SelectCharacter
