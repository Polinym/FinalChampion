extends Node


var db # database object
var db_name = "res://Database/Datastore/Database" # path to db
var open # Successful opening of database

# Called when a new object is initialized.
func _init():
	# Instantiates db as a SQLite Object
	db = SQLite.new()
	
	# Builds a database, if none is found
	# Opens the preexisting database, if found
	db.path = db_name
	
	# Set the queries to print detailed messages
	db.verbosity_level = 0
	
	# Open the database
	open = db.open_db()
	
	# Creates the tables in the db if they don't exist already
	buildTables()
	
	# Use the sqlite count query to find the amount of rows in the db
	# If no items are stored, populate the db with the bootstrap
	if checkIfTableIsEmpty():
		bootstrap()
	

func getOpen():
	return open

func getDB():
	return db

func checkIfTableIsEmpty():
	# Prepare a query to check if the table is empty
	var query = "SELECT COUNT(*) AS row_count FROM Characters"
	
	# Perform the query
	db.query(query)
	
	# If the result is equal to zero, return true
	
	if db.query_result[0]["row_count"] == 0:
		return true
	else:
		return false

func bootstrap():
	# Populate Characters
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
	
	# Populate Martial Arts
	db.query(
		'INSERT INTO "Martial Arts" ("char id", "wrestling", "muay thai", "judo", "bjj", "boxing", "kick boxing")
		VALUES (3652314, 4, 4, 2, 1, 0, 0)'
	)
	db.query(
		'INSERT INTO "Martial Arts" ("char id", "wrestling", "muay thai", "judo", "bjj", "boxing", "kick boxing")
		VALUES (5268569, 1, 0, 3, 2, 3, 2)'
	)
	db.query(
		'INSERT INTO "Martial Arts" ("char id")
		VALUES (1050603)'
	)

func buildTables():
	# id differentiates characters
	# name displayed name of a character
	# port the address of the character's portrait
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
			);
			')
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
			);
	')

