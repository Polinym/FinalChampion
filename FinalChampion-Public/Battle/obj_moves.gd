extends Node2D


var moves = {};
var grappleMoves = {};
var grappledMoves = {};
var atk_Sample = {};
var atk_Punch = {};
var atk_Kick = {};
var atk_Grab = {};
var atk_Takedown = {};
var atk_JointLock = {};
var atk_Choke = {};
var atk_Escape = {};
var user;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass;
	
func ini():
	atk_Sample = {};
	#Display name
	atk_Sample["name"] = "PSI Sample";
	
	#Line to show when using the move.
	#Control codes like {user} get filled in automatically.
	atk_Sample["use_line"] = "{user} tries PSI Sample!";
	
	#The animation to play when using the move.
	atk_Sample["use_ani"] = "punch";
	
	#Energy cost.
	atk_Sample["cost"] = 1;
	
	#Code to call for success chance
	#Use move_call (see below) to use these.
	atk_Sample["success"] = "sample_success";
	
	#The "do stuff to the enemy" code.
	atk_Sample["code"] = "sample_code";
	
	#Assign to move list.
	moves["atk_Sample"] = atk_Sample;
	
	
	atk_Punch = {};
	atk_Punch["name"] = "Punch";
	atk_Punch["use_line"] = "{user} throws a punch!";
	atk_Punch["use_ani"] = "punch";
	atk_Punch["cost"] = 2;
	atk_Punch["success"] = "success_punch";
	atk_Punch["code"] = "code_punch";
	#atk_Punch["skill"] = 0;
	moves["atk_Punch"] = atk_Punch;
	grappleMoves["atk_Punch"] = atk_Punch;
	grappledMoves["atk_Punch"] = atk_Punch;
	
	atk_Kick = {};
	atk_Kick["name"] = "Kick";
	atk_Kick["use_line"] = "{user} throws a kick!";
	atk_Kick["use_ani"] = "kick";
	atk_Kick["cost"] = 4;
	atk_Kick["success"] = "success_kick";
	atk_Kick["code"] = "code_kick";
	moves["atk_Kick"] = atk_Kick;
	grappleMoves["atk_Kick"] = atk_Kick;
	grappledMoves["atk_Kick"] = atk_Kick;
	
	atk_Grab = {};
	atk_Grab["name"] = "Grab";
	atk_Grab["use_line"] = "{user} goes for a grab!";
	atk_Grab["use_ani"] = "grab";
	atk_Grab["cost"] = 5;
	atk_Grab["success"] = "success_grab";
	atk_Grab["code"] = "code_grab";
	#atk_Grab["skill"] = 0;
	moves["atk_Grab"] = atk_Grab;
	
	atk_Takedown = {};
	atk_Takedown["name"] = "Takedown";
	atk_Takedown["use_line"] = "{user} tried a takedown!";
	atk_Takedown["use_ani"] = "grapple";
	atk_Takedown["cost"] = 7;
	atk_Takedown["success"] = "success_takedown";
	atk_Takedown["code"] = "code_takedown";
	#atk_Takedown["skill"] = 0;
	moves["atk_Takedown"] = atk_Takedown;
	
	atk_JointLock = {};
	atk_JointLock["name"] = "Joint Lock";
	atk_JointLock["use_line"] = "{user} tries a joint lock!";
	atk_JointLock["use_ani"] = "grapple";
	atk_JointLock["cost"] = 3;
	atk_JointLock["success"] = "success_jointlock";
	atk_JointLock["code"] = "code_jointlock";
	#atk_JointLock["skill"] = 0;
	grappleMoves["atk_JointLock"] = atk_JointLock;
	
	atk_Choke = {};
	atk_Choke["name"] = "Choke";
	atk_Choke["use_line"] = "{user} tries a chokehold!";
	atk_Choke["use_ani"] = "grapple";
	atk_Choke["cost"] = 3;
	atk_Choke["success"] = "success_choke";
	atk_Choke["code"] = "code_choke";
	#atk_Choke["skill"] = 0;
	grappleMoves["atk_Choke"] = atk_Choke;
	
	atk_Escape = {};
	atk_Escape["name"] = "Escape";
	atk_Escape["use_line"] = "{user} tries to escape the grapple!";
	atk_Escape["use_ani"] = "grapple";
	atk_Escape["cost"] = 3;
	atk_Escape["success"] = "success_escape";
	atk_Escape["code"] = "code_escape";
	grappleMoves["atk_Escape"] = atk_Escape;
	grappledMoves["atk_Escape"] = atk_Escape;
	
	'''
	var atk_Copyme = {};
	atk_Copyme["name"] = "";
	atk_Copyme["cost"] = 1;
	atk_Copyme["success"] = "sample_success";
	atk_Copyme["code"] = "sample_code";
	moves["atk_Copyme"] = atk_Copyme;
	'''


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func call_move(arg_move, arg_u, arg_t):
	return call(arg_move, arg_u, arg_t);

func sample_success(arg_user, arg_target):
	return obj_ram.scr_rng(1, 2);
	
func sample_code(arg_user, arg_target):
	var atk_power = arg_user.strength;
	var spd = arg_user.scr_stat_get("attack_speed");
	var spd2 = arg_target.scr_stat_get("attack_speed");
	if (spd > (spd2 + 5)):
		atk_power = atk_power * 2;
		
	arg_target.scr_heal(-atk_power);

#Success calculation for punch (or other) attacks
func success_tohit(at, df):
	var hitProb = ceili((at.attackScore()/(at.attackScore() + df.toHit())) * 100);
	var hitPer = obj_ram.scr_rng(1, 100);
	return (hitPer <= hitProb);
	
func hit_mod(arg_scale, arg_hit):
	arg_hit = floor(arg_hit * arg_scale);
	if (arg_hit > 100):
		arg_hit = 99;
	return arg_hit;
	
func success_punch(at, df):
	var hitProb = ceili((at.punchToHit()/(at.punchToHit() + df.punchToHit())) * 100);
	if (df.state == "state_grabbed"):
		hitProb = hitProb + 5;
	elif (df.state == "state_grappled"):
		hitProb = hitProb + 10;
	var hitPer = obj_ram.scr_rng(1, 100);
	#hitProb = hit_mod(1.5, hitProb);
	return (hitPer <= hitProb);
	
	
func success_kick(at, df):
	var hitProb = ceili((at.kickToHit()/(at.kickToHit() + df.kickToHit())) * 100);
	if (df.state == "state_grabbed"):
		hitProb = hitProb + 5;
	elif (df.state == "state_grappled"):
		hitProb = hitProb + 10;
	var hitPer = obj_ram.scr_rng(1, 100);
	#hitProb = hit_mod(1.3, hitProb);
	return (hitPer <= hitProb);

func success_takedown(at, df):
	var hitProb = ceili((at.takedownToHit()/(at.takedownToHit() + df.takedownToHit())) * 100);
	if (df.state == "state_grappled"):
		hitProb = hitProb + 10
	var hitPer = obj_ram.scr_rng(1, 100);
	return (hitPer <= hitProb);
	
func success_grab(at, df):
	var hitProb = ceili((at.grappleToHit()/(at.grappleToHit() + df.grappleToHit())) * 100);
	var hitPer = obj_ram.scr_rng(1, 100);
	return (hitPer <= hitProb);
	
func success_choke(at, df):
	var hitProb = ceili((at.chokeToHit()/(at.chokeToHit() + df.chokeToHit())) * 100);
	if (df.state != "state_grappled"):
		hitProb = hitProb - 10
	var hitPer = obj_ram.scr_rng(1, 100);
	return (hitPer <= hitProb);
	
func success_jointlock(at, df):
	var hitProb = ceili((at.jointlockToHit()/(at.jointlockToHit() + df.jointlockToHit())) * 100);
	if (df.state != "state_grappled"):
		hitProb = hitProb - 10
	var hitPer = obj_ram.scr_rng(1, 100);
	return (hitPer <= hitProb);
	
func success_escape(at, df):
	if (at.state == "state_grab" or at.state == "state_grapple"):
		return true;
	else:
		var hitProb = ceili((at.grappleToHit()/(at.grappleToHit() + df.grappleToHit())) * 100);
		var hitPer = obj_ram.scr_rng(1, 100);
		return (hitPer <= hitProb);
	
func success_always(arg_user, arg_targ):
	return true;
	
func lock_damage(arg_dmg):
	if (arg_dmg < 0):
		arg_dmg = 0;
	else:
		arg_dmg = round(arg_dmg);
	return arg_dmg;
	
func dmg_msg(arg_targ, arg_dmg):
	if (arg_dmg > 0):
		return str(arg_dmg) + " damage dealt!";
	else:
		return arg_targ.plr_name + " is unfased!";

#Code for punch attacks
func code_punch(arg_user, arg_targ):
	var dmg = ceil(arg_user.get_PunchingAttackPower() - arg_targ.get_StrikeDefensePower());
	var result = arg_targ.heal_stamina(-dmg);
	dmg = lock_damage(dmg);
	var msg = "";
	if (dmg <= 0):
		msg = "Strike connected, but was ineffective!" 
	else:
		msg = str(dmg) + " damage dealt!";
		
	#Return the results
	#damage_amt, is_alive, msg, plr_ani, targ_ani
	return [dmg, result, msg, null, "gethit"];
	
func code_kick(arg_user, arg_targ):
	var dmg = ceil(arg_user.get_KickingAttackPower() - arg_targ.get_StrikeDefensePower());
	var result = arg_targ.heal_stamina(-dmg);
	dmg = lock_damage(dmg);
	var msg = "";
	if (dmg < 1):
		msg = "Strike connected, but was ineffective!";
	else:
		msg = str(dmg) + " damage dealt!";
		
	#Return the results
	#damage_amt, is_alive, msg, plr_ani, targ_ani
	return [dmg, result, msg, null, "gethit"];
	
func code_choke(arg_user, arg_targ):

	var dmg = arg_user.get_GrapplingAttackPower("Choke") - arg_targ.get_GrappleDefensePower();
	var result = arg_user.heal_stamina(-dmg);
	dmg = lock_damage(dmg);
	var msg = "";
	if (dmg < 1):
		dmg = 0
		msg = "Got the hold, but it was ineffective!" 
	else:
		msg = str(dmg) + " damage dealt!";
		
	#Return the results
	#damage_amt, is_alive, msg, plr_ani, targ_ani
	return [dmg, result, msg, null, "gethit"];
	
func code_jointlock(arg_user, arg_targ):

	var dmg = ceili(arg_user.get_GrapplingAttackPower("Joint Lock") - arg_targ.get_GrappleDefensePower());
	var result = arg_user.heal_stamina(-dmg);
	dmg = lock_damage(dmg);
	var msg = "";
	if (dmg < 1):
		dmg = 0
		msg = "Got the lock, but it was ineffective!" 
	else:
		msg = str(dmg) + " damage dealt!";
		
	#Return the results
	#damage_amt, is_alive, msg, plr_ani, targ_ani
	return [dmg, result, msg, null, "gethit"];
	
func code_grab(arg_user, arg_targ):
	obj_ram.play_sound("grab");
	arg_user.state = "state_grab";
	arg_targ.state = "state_grabbed";
	var msg = arg_targ.plr_name + " was grabbed!";
	
	return [0, true, msg, "state_grab", "state_grabbed"];
	
func code_escape(arg_user, arg_targ):
	arg_user.state = "state_free";
	arg_targ.state = "state_free";
	var msg = arg_user.plr_name + " managed to escape the grapple!";
	
	return [0, true, msg, "state_free", "state_free"];
	
func code_takedown(arg_user, arg_targ):
	arg_user.state = "state_grapple";
	arg_targ.state = "state_grappled";
	var msg = arg_targ.plr_name + " got taken down!";
	
	return [0, true, msg, "state_grapple", "state_grappled"];

	
	
	
	
	
	
