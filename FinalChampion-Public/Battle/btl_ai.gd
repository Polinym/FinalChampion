extends Node
var pGrappling
var pStriking
var oGrappling
var oStriking
var moves_tbl
var grappleMoves_tbl
var grappledMoves_tbl


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _ini(moves, grappleMoves, grappledMoves):
	moves_tbl = moves
	grappleMoves_tbl = grappleMoves
	grappledMoves_tbl = grappledMoves

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func decide_move(player, opponent):
	#Choose highest martial art to decide actions, unless martial art difference passes a certain threshold.
	#TODO: Make methods to help with this
	pGrappling = player.best_Grappling()
	pStriking = player.best_Striking()
	oGrappling = player.best_Grappling()
	oStriking = player.best_Striking()
	if (pGrappling[1] > pStriking[1]):
		if ((pStriking[1] - oStriking[1]) > 3):
			return striking_strat(player, opponent)
		else:
			return grappling_strat(player, opponent)
	else:
		if ((pGrappling[1] - oGrappling[1]) > 3):
			return grappling_strat(player, opponent)
		else:
			return striking_strat(player, opponent)
	pass

func striking_strat(player, opponent):
	if (obj_ram.scr_rng(1, 100) < 80):
		return choose_strike(player, opponent)
	else:
		return choose_grab(player, opponent)

func grappling_strat(player, opponent):
	if (obj_ram.scr_rng(1, 100) < 80):
		return choose_grab(player, opponent)
	else:
		return choose_strike(player, opponent)
	
func choose_strike(player, opponent):
	if (player.state == "state_free"):
		if (pStriking[0] == "Boxing"):
			return moves_tbl["atk_Punch"]
		else:
			if (obj_ram.scr_rng(1, 100) < 50):
				return moves_tbl["atk_Punch"]
			else:
				return moves_tbl["atk_Kick"]
	elif (player.state == "state_grab" or player.state == "state_grapple"):
		if (pStriking[0] == "Boxing"):
			return moves_tbl["atk_Punch"]
		else:
			if (obj_ram.scr_rng(1, 100) < 50):
				return moves_tbl["atk_Punch"]
			else:
				return moves_tbl["atk_Kick"]
	else:
		if (obj_ram.scr_rng(1, 100) < 75):
			return grappledMoves_tbl["atk_Escape"]
		else:
			if (obj_ram.scr_rng(1, 100) < 50):
				return moves_tbl["atk_Punch"]
			else:
				return moves_tbl["atk_Kick"]

func choose_grab(player, opponent):
	if (player.state == "state_free"):
		if (obj_ram.scr_rng(1, 100) < 50):
			return moves_tbl["atk_Grab"]
		else:
			return moves_tbl["atk_Takedown"]
	elif (player.state == "state_grab" or player.state == "state_grapple"):
		#Replace Later
		match obj_ram.scr_rng(1, 4):
			1:
				return moves_tbl["atk_Punch"]
			2:
				return grappleMoves_tbl["atk_JointLock"]
			3:
				return grappleMoves_tbl["atk_Choke"]
			4:
				return moves_tbl["atk_Kick"]
	else:
		if (obj_ram.scr_rng(1, 100) < 75):
			return grappledMoves_tbl["atk_Escape"]
		else:
			if (obj_ram.scr_rng(1, 100) < 50):
				return moves_tbl["atk_Punch"]
			else:
				return moves_tbl["atk_Kick"]
