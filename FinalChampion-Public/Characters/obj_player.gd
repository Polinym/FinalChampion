extends Node2D
var plr_name = "Owen";

var Stamina = 50; var MaxStamina = Stamina;
var Energy = 50; var MaxEnergy = Energy;
var index = 0;

var Strength = 5;
var Agility = 5;
var Reflexes = 5;

var Arts = {};

var prc = 1;
var sp = 150; var max_sp = sp;
var state = "state_free";
var actionCost = 50;

var moves = [];
var grappleMoves = [];
var grappledMoves = [];

var obj_moves;
var obj_skills;
var skills_tbl;
var boxingSkills;
var wrestlingSkills;
var bjjSkills;
var muaiThaiSkills;
var judoSkills;
var kickBoxingSkills
var moves_tbl;
var grappleMoves_tbl;
#For when you arb grabbed
var grappledMoves_tbl;
var Wrestling = 0;
var Kickboxing = 0;
var Boxing = 0;
var MuaiThai = 0;
var Judo = 0;
var BJJ = 0;

var isTired = false;
var isExhausted = false;
var isAI = false;
var fatiguePenalty = 1;

var items = ["phone"];


# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func ini(arg_moves_tbl, arg_skills_tbl, AI):
	# Set if player is AI
	isAI = AI
	Arts["Wrestling"] = 0;
	Arts["Judo"] = 0;
	Arts["BJJ"] = 0;
	Arts["Boxing"] = 0;
	Arts["Muay Thai"] = 0;
	Arts["Kick Boxing"] = 0;
	#Get the moves tbl from obj_moves
	obj_moves = arg_moves_tbl
	obj_skills = arg_skills_tbl
	skills_tbl = obj_skills.skills
	kickBoxingSkills = skills_tbl["Kickboxing Skill"]
	wrestlingSkills = skills_tbl["Wrestling Skill"]
	bjjSkills = skills_tbl["BJJ Skill"]
	judoSkills = skills_tbl["Judo Skill"]
	boxingSkills = skills_tbl["Boxing Skill"]
	muaiThaiSkills = skills_tbl["Muai Thai Skill"]
	moves_tbl = obj_moves.moves;
	grappleMoves_tbl = obj_moves.grappleMoves;
	grappledMoves_tbl = obj_moves.grappledMoves;
	add_move("atk_Punch");
	add_move("atk_Kick");
	add_move("atk_Grab");
	add_move("atk_Takedown");
	add_grapMove("atk_Punch")
	add_grapMove("atk_Kick");
	add_grapMove("atk_JointLock")
	add_grapMove("atk_Choke")
	add_grapMove("atk_Escape")
	add_grappledMove("atk_Punch")
	add_grappledMove("atk_Kick")
	add_grappledMove("atk_Escape")
	
#When you want to get a stat, factoring in buffs and armor and such, use this.
func get_stat(arg_stat):
	match arg_stat:
		"str":
			return Strength;
		"Speed":
			return (0.1 * Reflexes) + (0.1 * Agility);
		"rfx":
			return Reflexes;
		"prc":
			return prc;
		"eng":
			return Energy;
		"sta":
			return Stamina;
		"Conditioning":
			return ceili((Strength + Stamina + Agility)/3);
		"Init":
			return obj_ram.scr_rng(1, 10) + Reflexes;
		"AP":
			return sp;
		"Turn Time":
			return round(5/((0.1 * Reflexes) + (0.1 * Agility)));
		"State":
			return state 
	
func heal_stamina(arg_amt):
	Stamina += arg_amt;
	if (Stamina > MaxStamina):
		Stamina = MaxStamina;
	elif (Stamina < 1):
		Stamina = 0;
		return false;
	return true;
	
func heal_energy(arg_amt):
	Energy += arg_amt;
	if (Energy > MaxEnergy):
		Energy = MaxEnergy;
	elif (Energy < 1):
		Energy = 0;
		return false;
	return true;
	
	
	
func nextTurn():
	sp = max_sp;
	Energy += get_stat("Conditioning");
	if (Energy > MaxEnergy):
		Energy = MaxEnergy
	
#Placeholders for actions for now
func Action(cost):
	sp = sp - actionCost;
	Energy = Energy - cost
	actionCost = 50;
	
#To be replaced with a toHit for each type of attack
func toHit():
	return (get_stat("Speed") * (Reflexes + Agility + (get_stat("Conditioning")/2 + Strength/2)))
	
func punchToHit():
	var skill;
	if (Boxing * boxingSkills["Punch"] > Kickboxing * kickBoxingSkills["Punch"] && Boxing * boxingSkills["Punch"] > MuaiThai * muaiThaiSkills["Punch"]):
		skill = Boxing * boxingSkills["Punch"]
	elif (MuaiThai * muaiThaiSkills["Punch"] > Boxing * boxingSkills["Punch"] && MuaiThai * muaiThaiSkills["Punch"] > Kickboxing * kickBoxingSkills["Punch"]):
		skill = MuaiThai * muaiThaiSkills["Punch"]
	else:
		skill = Kickboxing * kickBoxingSkills["Punch"]
	return fatiguePenalty * (get_stat("Speed") * (Reflexes + Agility + (get_stat("Conditioning")/2 + Strength/2) + (skill)))
	
func kickToHit():
	var skill;
	if (Kickboxing * kickBoxingSkills["Kick"] > MuaiThai * muaiThaiSkills["Kick"]):
		skill = Kickboxing * kickBoxingSkills["Kick"]
	else:
		skill = MuaiThai * muaiThaiSkills["Kick"]
	return fatiguePenalty * (get_stat("Speed") * (Reflexes + Agility + (get_stat("Conditioning")/2 + Strength/2) + (skill)))
	
func grappleToHit():
	var skill;
	if (Wrestling * wrestlingSkills["Grapple"] > Judo * judoSkills["Grapple"] && Wrestling * wrestlingSkills["Grapple"] > BJJ * bjjSkills["Grapple"]):
		skill = Wrestling * wrestlingSkills["Grapple"]
	elif (Judo * judoSkills["Grapple"] > Wrestling * wrestlingSkills["Grapple"] && Judo * judoSkills["Grapple"] > BJJ * bjjSkills["Grapple"]):
		skill = Judo * judoSkills["Grapple"]
	else:
		skill = BJJ * bjjSkills["Grapple"]
	return fatiguePenalty * (get_stat("Speed") * (Reflexes + Agility + (get_stat("Conditioning")/2 + Strength/2) + (skill)))
	
func takedownToHit():
	var skill;
	if (Wrestling * wrestlingSkills["Takedown"] > Judo * judoSkills["Takedown"] && Wrestling * wrestlingSkills["Takedown"] > BJJ * bjjSkills["Takedown"]):
		skill = Wrestling * wrestlingSkills["Takedown"]
	elif (Judo * judoSkills["Takedown"] > Wrestling * wrestlingSkills["Takedown"] && Judo * judoSkills["Takedown"] > BJJ * bjjSkills["Takedown"]):
		skill = Judo * judoSkills["Takedown"]
	else:
		skill = BJJ * bjjSkills["Takedown"]
	return fatiguePenalty * (get_stat("Speed") * (Reflexes + Agility + (get_stat("Conditioning")/2 + Strength/2) + (skill)))
	
func chokeToHit():
	var skill;
	if (Wrestling * wrestlingSkills["Choke"] > Judo * judoSkills["Choke"] && Wrestling * wrestlingSkills["Choke"] > BJJ * bjjSkills["Choke"]):
		skill = Wrestling * wrestlingSkills["Choke"]
	elif (Judo * judoSkills["Choke"] > Wrestling * wrestlingSkills["Choke"] && Judo * judoSkills["Choke"] > BJJ * bjjSkills["Choke"]):
		skill = Judo * judoSkills["Choke"]
	else:
		skill = BJJ * bjjSkills["Choke"]
	return fatiguePenalty * (get_stat("Speed") * (Reflexes + Agility + (get_stat("Conditioning")/2 + Strength/2) + (skill)))
	
func jointlockToHit():
	var skill;
	if (Wrestling * wrestlingSkills["Joint Lock"] > Judo * judoSkills["Joint Lock"] && Wrestling * wrestlingSkills["Joint Lock"] > BJJ * bjjSkills["Joint Lock"]):
		skill = Wrestling * wrestlingSkills["Joint Lock"]
	elif (Judo * judoSkills["Joint Lock"] > Wrestling * wrestlingSkills["Joint Lock"] && Judo * judoSkills["Joint Lock"] > BJJ * bjjSkills["Joint Lock"]):
		skill = Judo * judoSkills["Joint Lock"]
	else:
		skill = BJJ * bjjSkills["Joint Lock"]
	return fatiguePenalty * (get_stat("Speed") * (Reflexes + Agility + (get_stat("Conditioning")/2 + Strength/2) + (skill)))

func attackScore():
	return (get_stat("Speed") * (Reflexes + Agility + (get_stat("Conditioning")/2 + Strength/2)));
	
func get_AttackPower():
	return ceil( Strength + (0.3 * get_stat("Conditioning")) );
	
func get_GrapplingAttackPower(string):
	var skill;
	if (Wrestling * wrestlingSkills[string] > Judo * judoSkills[string] && Wrestling * wrestlingSkills[string] > BJJ * bjjSkills[string]):
		skill = Wrestling * wrestlingSkills[string]
	elif (Judo * judoSkills[string] > Wrestling * wrestlingSkills[string] && Judo * judoSkills[string] > BJJ * bjjSkills[string]):
		skill = Judo * judoSkills[string]
	else:
		skill = BJJ * bjjSkills[string]
	return fatiguePenalty * ceil( Strength + (0.3 * get_stat("Conditioning")) + (0.2 * skill) );
	
func get_PunchingAttackPower():
	var skill;
	if (Boxing * boxingSkills["Punch"] > Kickboxing * kickBoxingSkills["Punch"] && Boxing * boxingSkills["Punch"] > MuaiThai * muaiThaiSkills["Punch"]):
		skill = Boxing * boxingSkills["Punch"]
	elif (MuaiThai * muaiThaiSkills["Punch"] > Boxing * boxingSkills["Punch"] && MuaiThai * muaiThaiSkills["Punch"] > Kickboxing * kickBoxingSkills["Punch"]):
		skill = MuaiThai * muaiThaiSkills["Punch"]
	else:
		skill = Kickboxing * kickBoxingSkills["Punch"]
	return fatiguePenalty * ceil( Strength + (0.3 * get_stat("Conditioning")) + (0.2 * skill));
	
func get_KickingAttackPower():
	var skill = 1;
	if (Kickboxing * kickBoxingSkills["Kick"] > MuaiThai * muaiThaiSkills["Kick"]):
		skill = Kickboxing * kickBoxingSkills["Kick"]
	else:
		skill = MuaiThai * muaiThaiSkills["Kick"]
	return fatiguePenalty * ceil( Strength + (0.3 * get_stat("Conditioning")) + (0.2 * skill));
	
func get_DefensePower():
	return fatiguePenalty * ceil((Strength * 0.2) + (0.3 * get_stat("Conditioning")) + (0.05 * Reflexes));
	
func get_GrappleDefensePower():
	var skill;
	if (Wrestling * wrestlingSkills["Grapple Midigation"] > Judo * judoSkills["Grapple Midigation"] && Wrestling * wrestlingSkills["Grapple Midigation"] > BJJ * bjjSkills["Grapple Midigation"]):
		skill = Wrestling * wrestlingSkills["Grapple Midigation"]
	elif (Judo * judoSkills["Grapple Midigation"] > Wrestling * wrestlingSkills["Grapple Midigation"] && Judo * judoSkills["Grapple Midigation"] > BJJ * bjjSkills["Grapple Midigation"]):
		skill = Judo * judoSkills["Grapple Midigation"]
	else:
		skill = BJJ * bjjSkills["Grapple Midigation"]
	return fatiguePenalty * ceil((Strength * 0.2) + (0.3 * get_stat("Conditioning")) + (0.05 * Reflexes) + (0.2 * skill));
	
func get_StrikeDefensePower():
	var skill;
	if (Boxing * boxingSkills["Strike Midigation"] > Kickboxing * kickBoxingSkills["Strike Midigation"] && Boxing * boxingSkills["Strike Midigation"] > MuaiThai * muaiThaiSkills["Strike Midigation"]):
		skill = Boxing * boxingSkills["Strike Midigation"]
	elif (MuaiThai * muaiThaiSkills["Strike Midigation"] > Boxing * boxingSkills["Strike Midigation"] && MuaiThai * muaiThaiSkills["Strike Midigation"] > Kickboxing * kickBoxingSkills["Strike Midigation"]):
		skill = MuaiThai * muaiThaiSkills["Strike Midigation"]
	else:
		skill = Kickboxing * kickBoxingSkills["Strike Midigation"]
	return fatiguePenalty * ceil((Strength * 0.2) + (0.3 * get_stat("Conditioning")) + (0.05 * Reflexes) + (0.2 * skill));
	
func best_Striking():
	var artName
	var artNum
	if (Boxing > Kickboxing && Boxing > MuaiThai):
		artName = "Boxing"
		artNum = Boxing
	elif (MuaiThai > Boxing && MuaiThai > Kickboxing):
		artName = "Muai Thai"
		artNum = MuaiThai
	else:
		artName = "Kickboxing"
		artNum = Kickboxing
	return [artName, artNum]
	
func best_Grappling():
	var artName
	var artNum
	if (Wrestling > Judo && Wrestling > BJJ):
		artName = "Wrestling"
		artNum = Wrestling
	elif (Judo > Wrestling && Judo > BJJ):
		artName = "Judo"
		artNum = Judo
	else:
		artName = "BJJ"
		artNum = BJJ
	return [artName, artNum]
	
func damage():
	return Strength + (get_stat("Conditioning")/2);
	
func add_move(arg_movename):
	moves.append(moves_tbl[arg_movename]);
	
func add_grapMove(arg_movename):
	grappleMoves.append(grappleMoves_tbl[arg_movename]);
	
func add_grappledMove(arg_movename):
	grappledMoves.append(grappledMoves_tbl[arg_movename]);
	
func get_cmds():
	var lst = [];
	if (state == "state_grab" or state == "state_grapple"):
		for move in grappleMoves:
			print(move);
			lst.append(move["name"] + "   " + str(move["cost"]) + "EP");
	elif (state == "state_grabbed" or state == "state_grappled"):
		for move in grappledMoves:
			print(move);
			lst.append(move["name"] + "   " + str(move["cost"]) + "EP");
	else:
		for move in moves:
			print(move);
			lst.append(move["name"] + "   " + str(move["cost"]) + "EP");
	return lst;
	

	
func finalAP(finalTT):
	sp = ceili(sp * ((5/((0.1 * Reflexes) + (0.1 * Agility)))/finalTT))
	max_sp = ceili(max_sp * ((5/((0.1 * Reflexes) + (0.1 * Agility)))/finalTT))
	
func turnTime():
	return ceili(5/(0.1 * Reflexes) + (0.1 * Agility))
	
func checkFatigue():
	if (Energy >= (MaxEnergy/4)):
		isTired = false
		isExhausted = true
		fatiguePenalty = 0.8
	elif (Energy >= (MaxEnergy/2)):
		isExhausted = false
		isTired = true
		fatiguePenalty = 0.9
	else:
		isExhausted = false
		isTired = false
		fatiguePenalty = 1
		


	
