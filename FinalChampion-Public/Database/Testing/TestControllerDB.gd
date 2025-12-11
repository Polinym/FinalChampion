extends Node

var db # database object
var db_name = "res://Database/Datastore/Tests" # path to db
const ControllerDB = preload("res://Database/Repository/ControllerDB.gd")
var controller

func _init():
	# Set up a db to be tested
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	
	# Build table and fill with sample data
	build()
	
	# Create a ControllerDB object and test on it
	controller = ControllerDB.new()
	
	# Perform tests
	if getCharacterByNameValid():
		print("getCharacterByNameValid passed")
	else:
		print("getCharacterByNameValid failed test")

func build():
	db.query('
			CREATE TABLE IF NOT EXISTS "Characters" (
			"id"	INTEGER NOT NULL UNIQUE,
			"name"	TEXT NOT NULL,
			"port"	TEXT,
			"Stamina"	INTEGER NOT NULL DEFAULT 5,
			"Energy"	INTEGER NOT NULL DEFAULT 5,
			"Strength"	INTEGER NOT NULL DEFAULT 5,
			"Agility"	INTEGER NOT NULL DEFAULT 5,
			"Reflexes"	INTEGER NOT NULL DEFAULT 5,
			"conditioning"	INTEGER NOT NULL DEFAULT 5,
			"state"	INTEGER NOT NULL DEFAULT 5,
			"attack speed"	REAL NOT NULL DEFAULT 1,
			PRIMARY KEY("id" AUTOINCREMENT)
			);')
	db.query('CREATE TABLE IF NOT EXISTS "Martial Arts" (
			"char id"	INTEGER NOT NULL UNIQUE,
			"wrestling"	INTEGER NOT NULL DEFAULT 0,
			"muay thai"	INTEGER NOT NULL DEFAULT 0,
			"judo"	INTEGER NOT NULL DEFAULT 0,
			"bjj"	INTEGER NOT NULL DEFAULT 0,
			"boxing"	INTEGER NOT NULL DEFAULT 0,
			"kick boxing"	INTEGER NOT NULL DEFAULT 0,
			PRIMARY KEY("char id"),
			FOREIGN KEY("char id") REFERENCES "Characters"("id") on delete cascade
			);')
	db.query('
			CREATE TABLE IF NOT EXISTS "Martial Technique" (
			"Move ID"	INTEGER NOT NULL UNIQUE,
			"Level"	INTEGER NOT NULL DEFAULT 0,
			"Wrestling Req"	INTEGER NOT NULL DEFAULT 0,
			"BJJ Req"	INTEGER NOT NULL DEFAULT 0,
			"Judo Req"	INTEGER NOT NULL DEFAULT 0,
			"Boxing Req"	INTEGER NOT NULL DEFAULT 0,
			"Kick Boxing Req"	INTEGER NOT NULL DEFAULT 0,
			"Muay Thai Req"	INTEGER NOT NULL DEFAULT 0
			);')
	db.query(
		'INSERT INTO "Characters" ("id", "name")
		VALUES (3652314, "Guy1")'
	)
	db.query(
		'INSERT INTO "Characters" ("id", "name", "Stamina", "Energy", "Strength", "Agility",  "Reflexes", "conditioning", "state", "attack speed")
		VALUES (5268569, "Guy2", 10, 10, 10, 10, 10, 10, 10, 10)'
	)
	db.query(
		'INSERT INTO "Characters" ("id", "name", "Stamina", "Energy", "Strength", "Agility",  "Reflexes", "conditioning", "state", "attack speed")
		VALUES (1050603, "Guy3", 0, 0, 0, 0, 0, 0, 0, 0)'
	)

func destroyTable():
	db.query('DROP TABLE IF EXISTS "Characters";')
	db.query('DROP TABLE IF EXISTS "Martial Arts";')
	db.query('DROP TABLE IF EXISTS "Martial Technique";')

func getCharacterByNameValid():
	# attempt the function to get a character by name
	var foo = controller.getCharacterByName("Guy2")
	# check that a result is returned and matches expectations
	if typeof(foo) == TYPE_NIL:
		return false
	# If any do not match, the select had failed
	if foo['name'] != "Guy2":
		return false
	if foo['id'] != 5268569:
		return false
	if foo['Stamina'] != 10:
		return false
	if foo['Strength'] != 10:
		return false
	if foo['Agility'] != 10:
		return false
	if foo['Reflexes'] != 10:
		return false
	if foo['Energy'] != 10:
		return false
	if foo['conditioning'] != 10:
		return false
	if foo['state'] != 10:
		return false
	if foo['attack speed'] != 10:
		return false
	
	# If all checks are passed
	# Return true
	return true
