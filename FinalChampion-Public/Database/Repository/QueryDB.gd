extends Node

# Import the OpenDB script
const OpenDB = preload("res://Database/Repository/OpenDB.gd")


var db # the Database object
#var open = OpenDB.new() # An instance of the object that opens the dataase

var query_string : String # The query to be performed
var param_bindings : Array # An array that is given the values
# that will be sanitized by the parameterized query

# Called when the node enters the scene tree for the first time.
func _init(inputdb):
	# Receive the database location
	db = inputdb


func selectCharacter(id):
	# Check that id is of valid type
	checkCharacterExists(id)
	
	# Set the query and parameters
	query_string = "
	select *
	from Characters
	where id = ?
	"

	param_bindings = [id]
	
	# Perform the query
	db.query_with_bindings(query_string, param_bindings)
	
	# If no result is found, exit
	if len(db.query_result) == 0:
		return
	
	# return the result
	return db.query_result[0]

func selectCharacterByName(name):
	if typeof(name) != TYPE_STRING:
		assert(false, "Error: Parameter 'name' must be a string") 
	
	# Set the query and parameters
	query_string = "
	select *
	from Characters
	where name = ?
	"

	param_bindings = [name]
	
	# Perform the query
	db.query_with_bindings(query_string, param_bindings)
	
	# If no result is found, exit
	if len(db.query_result) == 0:
		return
	
	# return the result
	return db.query_result[0]

func selectAllCharacters():
	# Grab every character in the database
	# Maybe perform a left join with Martial Arts on id
	
	# Set the query and parameters
	query_string = "
	select *
	from Characters
	"
	
	# Perform the query
	db.query(query_string)
	
	# return the result
	return db.query_result

func insertCharacter(name, stamina = 5, energy = 5, strength = 5, agility = 5, reflexes = 5, conditioning = 5, state = 5, attack_speed = 1):
	# Check that id is of valid type
	if typeof(name) != TYPE_STRING:
		return # exit
	

	# Set the query and parameters
	query_string = '
	INSERT INTO Characters(name, Stamina, Energy, Strength, Agility,  Reflexes, conditioning, state, "attack speed")
	values(?, ?, ?, ?, ?, ?, ?, ?, ?)
	'
	param_bindings = [name, stamina, energy, strength, agility, reflexes, conditioning, state, attack_speed]
	
	# perform the parameterized query
	var resultBoolean = db.query_with_bindings(query_string, param_bindings)
	return resultBoolean

func deleteCharacterById(id):
	# Check that id is of valid type
	if typeof(id) != TYPE_INT:
		return # exit
	
	# Set the query and parameters
	query_string = '
	DELETE FROM Characters WHERE id = ?
	'
	param_bindings = [id]
	
	# perform the parameterized query
	db.query_with_bindings(query_string, param_bindings)

func updateCharacterById(id, columnName, newValue):
	# Check that id is of valid type
	if typeof(id) != TYPE_INT:
		return # exit
	# Check that the id is not being changed
	if columnName == "id":
		return
	
	# Set the query and parameters
	query_string = "
	UPDATE Characters
	SET ? = ?
	where id = ?
	"
	param_bindings = [columnName, newValue, id]
	
	# perform the parameterized query
	db.query_with_bindings(query_string, param_bindings)

# Perform predefined Query operations on the Database
func selectMartialArtsByID(id):
	# Check if id is of a valid type
	if typeof(id) != TYPE_INT:
		return
	
	# Check if id is within a valid range for a character id
	# TO DO: talk about character IDs w/ Tyler & Kevin
	
	# Stores all matching rows in db.query_result
	db.query("
	select *
	from MartialArts
	where charID = {charId}
	".format({"charId":id}))
	
	return db.query_result

func insertMartialArts(char_id, wrestling = 0, muay_thai = 0, judo = 0, bjj = 0, 
						boxing = 0, kick_boxing = 0):
	# A func to attempt an insert into the Martial Proficiency table
	# The desired char must exist
	if !checkCharacterExists(char_id):
		return false
	
	# Now perform the actual query
	query_string = '
	INSERT INTO "Martial Arts"("char id", wrestling, "muay thai", judo, bjj, boxing, "kick boxing")
	values(?, ?, ?, ?, ?, ?, ?)
	'
	
	param_bindings = [char_id["id"], wrestling, muay_thai, judo, bjj, boxing, kick_boxing]
	
	# Perform the query
	var resultBoolean = db.query_with_bindings(query_string, param_bindings)
	return resultBoolean

func checkType(param, type):
	if typeof(param) != type:
		return false
	return true

func checkCharacterExists(id):
	# A function to check if a character exists
	if !checkType(id["id"], TYPE_INT): # the id must be an int
		assert(false, "Error: wrong id data type given") # close game with error
	
	# Perform a query and determine if a result is returned 
	query_string = "
	select *
	from Characters
	where id = ?
	"
	param_bindings = [id["id"]]
	db.query_with_bindings(query_string, param_bindings)
	
	# Check if the results turned up empty or not
	if len(db.query_result) == 0:
		assert(false, "Character not found in database") # Throw error
		return false
	else:
		return true
	pass

func getId(name):
	# get whatever the id is for a character based on its name
	# perform a check to ensure parameters are valid
	if checkType(name, TYPE_STRING):
		# name is a string, so look for it in the database
		# Set the query and parameters
		query_string = "
		select id
		from Characters
		where name = ?
		"
		
		param_bindings = [name]
		
		# Perform the query
		db.query_with_bindings(query_string, param_bindings)
		
		# If no result is found, exit
		if len(db.query_result) == 0:
			assert(false, "character not found")
		
		# return the result
		return db.query_result[0]
	else: 
		assert(false, "name is not a string")
