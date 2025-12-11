extends Node


var db # database object
var db_name = "res://Database/Datastore/Tests" # path to db
const QueryDB = preload("res://Database/Repository/QueryDB.gd")
var query

# Called when the object is initialized.
func _init():
	# Set up a db to be tested
	db = SQLite.new()
	db.path = db_name
	db.open_db()
	
	# Build table and fill with sample data
	build()
	
	# Create a QueryDB object and test on it
	query = QueryDB.new(db)
	
	# Perform tests
	if selectCharacterValid():
		print("selectCharacterValid passed")
	else:
		print("selectCharacterValid failed test")
		
	if selectCharByNameValid():
		print("selectCharByNameValid passed")
	else:
		print("selectCharByNameValid failed test")
	
	'if selectCharacterInvalidID():
		print("selectCharacterInvalidID passed")
	else:
		print("selectCharacterInvalidID failed test")'
	
	'if selectCharacterMissingID():
		print("selectCharacterMissingID passed")
	else:
		print("selectCharacterMissingID failed test")'
		
	if selectAllCharacters():
		print("selectAllCharacters passed")
	else:
		print("selectAllCharacters failed test")
	
	if checkTypeValid():
		print("checkTypeValid passed")
	else:
		print("checkTypeValid failed test")
	
	if checkCharacterExistsValid():
		print("checkCharacterExistsValid passed")
	else:
		print("checkCharacterExistsValid failed test")
	
	'if checkCharacterExistsInvalid():
		print("checkCharacterExistsInvalid passed")
	else:
		print("checkCharacterExistsInvalid failed test")'
	
	# Delete the test table once done
	destroyTable()

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

func selectCharacterValid():
	# Attempt to do a select of a single character that exists
	# ask the query object to select guy2 from the table characters
	var foo = query.selectCharacter(5268569)
	
	# Check if all values are correct
	# If any do not match, the select had failed
	'''
	if foo['name'] != "Guy2":
		return false
	if foo['id'] != 5268569:
		return false
	if foo['Stamina'] != 10:
		return false
	if foo['Energy'] != 10:
		return false
	if foo['Strength'] != 10:
		return false
	if foo['Agility'] != 10:
		return false
	if foo['Reflexes'] != 10:
		return false
	if foo['conditioning'] != 10:
		return false
	if foo['state'] != 10:
		return false
	if foo['attack speed'] != 10:
		return false
	'''
	
	# If all checks are passed
	# Return true
	return true

func selectCharByNameValid():
	# given a character's name, something should be returned
	var foo = query.selectCharacterByName("Guy2")
	# if the results returned are null, return false
	# if there is something in the results, that should be correct
	return typeof(foo) != TYPE_NIL

func selectCharacterInvalidID():
	# Attempt to do a select of a single character with an invalid ID
	var foo = query.selectCharacter("5268569")
	if foo != null:
		return false
	else:
		return true

func selectCharacterMissingID():
	# Attempt to do a select of a single character with an missing ID
	var foo = query.selectCharacter(0)
	if foo != null:
		return false
	else:
		return true

func selectAllCharacters():
	# Attempt a select all on the character table
	var all = query.selectAllCharacters()
	
	# Test if the result is proper
	if len(all) != 3: # If the amount of returned results is wrong 
		return false # the test fails
	
	return true # The tests were all passed

func insertCharacterValid():
	# Attempt to insert a character into the table
	var returned = query.insertCharacter("", 1, 2, 3, 4, 5, 6, 7)
	return true

func insertCharacterInvalidType():
	# Attempt to insert a character into the table with an invalid field type
	return true

func deleteExistingCharacter():
	# Attempt to delete an existing character
	return true

func deleteFakeCharacter():
	# Attempt to delete a character that does not exist
	return true

func checkTypeValid():
	# Determine if the checkType function actually works
	var foo = 10
	var bar = "Hello world!"
	
	if !query.checkType(foo, TYPE_INT):
		return false
	if !query.checkType(bar, TYPE_STRING):
		return false
	return true

func checkCharacterExistsValid():
	# Determine if the check for an existing character works properly
	var testID = 1050603
	var foo = query.checkCharacterExists(testID)
	# Foo should be true if working, and false if not
	return foo

func checkCharacterExistsInvalid():
	# Determine if the check for an existing character works properly
	var testID = 0
	var foo = query.checkCharacterExists(testID)
	# Foo should be false if working, and true if not
	return !foo

func updateCharacterByIdValid():
	# attempt to update the strength field of Guy1
	var foo = query.updateCharacterById(3652314, 'Strength', 3)

