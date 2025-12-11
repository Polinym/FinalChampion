"""
The controller.gd is a controller which the obj_ram will call functions from.
As a controller, the script should employ indirection, keeping obj_ram
from being coupled to queryDB and maintaining the high cohesion of the 
Database responsibilities and Scene Management responsibilities.
"""

extends Node

# Import the OpenDB and QueryDB scripts
const OpenDB = preload("res://Database/Repository/OpenDB.gd")
const QueryDB = preload("res://Database/Repository/QueryDB.gd")

# a dict which matches the names to their given id for use by QueryDB
var characters:Dictionary # <name, id>
var open = OpenDB.new() # an OpenDB object
var db = open.getDB() # values to pass to a new Query Object
var query = QueryDB.new(db) # a QueryDB object

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _init():
	pass

func updateCharacter(name, newValueDict):
	# Given the name of a character and a dictionary of <field to update, value>
	# Update a character in the database
	"""
	newValueDict, a dictionary where the key is the name of the field to be changed and the new value is the desired value for that character
	"""
	for key in newValueDict.keys():
		query.updateCharacterById(characters[name], key, newValueDict[key])

func getCharacterByName(name):
	# a method to allow the game to request a specific character by their name
	var character = query.selectCharacterByName(name)
	return character

func getCharacterByID(id):
	# a method to allow the game to request a specific character by their id
	var character = query.selectCharacter(id)
	return character

func getAllCharacters():
	# A method to return every character in the database
	var characters = query.selectAllCharacters()
	return characters

func addCharacter(name, stamina = 5, energy = 5, strength = 5, agility = 5, reflexes = 5, conditioning = 5, state = 5, attack_speed = 1):
	# A method where a character is added to the database
	# If specified, Martial Proficiency is also added.
	
	# Check that data types are correct
	for type in [stamina, strength, agility, reflexes, energy, conditioning, state, attack_speed]:
		if !query.checkType(type, TYPE_INT):
			print("incorrect data type for parameter " + str(type))
			return # Exit
	if typeof(name) != TYPE_STRING:
		print("name must be a string")
		return # Exit
	
	# Perform the queries
	var inserted = query.insertCharacter(name, stamina, energy, strength, agility, reflexes, conditioning, state, attack_speed)
	# Update the character list
	characters[name] = query.getId(name)

func addMartialArt(name, wrestling, muay_thai, judo, bjj, boxing, kick_boxing):
	# Add a character's Martial Art or update it
	#query.insertMartialArts(characters[name], wrestling, muay_thai, judo, bjj, boxing, kick_boxing)
	# if not
	return # Exit



