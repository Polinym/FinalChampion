extends Node2D

var bck;
var stats;
var state;
var running;
var reading;
var menuing;

var player;
var player_name;
var player2;
var player2_name;
var scr_msg;
var actor_plr;
var actor_plr2;
var actor_init;
var actor2_init;
var randGen = RandomNumberGenerator.new()
var turnTime = 5;
var round = 1;
var percent = 0;
var roll = 0;

var actors;
var user_actor;
var targ_actor;

var btl_ai;

var fighters;
var turn;
var not_turn;
var user;
var targ;
var target;
var move;
var result;
var reactionUser;
var reactionTarget;

var reacting = false;

var clock;
var time;

var set_label;
var set_bar;
var lbls_name = [];
var lbls_hp = [];
var lbls_sp = [];
var lbls_ap = [];
var bars = [];

var set_nmb;
var set_cd = load("res://Battle/countdown/set_btl_cd.tscn");
var cd = null;

var freeplay;

var spr_seth = load("res://spr/btl/actor/ani_seth_btl.tres");
var spr_seth_blink = load("res://spr/btl/actor/ani_seth_btl_blink.tres");

# Called when the node enters the scene tree for the first time.
func _ready():
	freeplay = obj_ram.freeplay;
	obj_ram.clear_ambients();
	obj_ram.play_ambient("crowd");
	
	bck = get_node("obj_bck");
	stats = get_node("obj_bar_stats/obj_stats_plr");
	clock = get_node("obj_clock");
	time = 60;
	state = 0x0;
	running = true;
	reading = false;
	menuing = false;
	player = obj_ram.player; 
	player2 = obj_ram.player2;
	
	if (freeplay):
		player2.plr_name = "Caped Man";
		player2.MaxStamina = 70;
		player2.MaxEnergy = 60;
		player2.Strength = 10;
		player2.Agility = 5;
		player2.Reflexes = 5;
		player2.index = 2;
	
	
	#if (player.turnTime() > player2.turnTime()):
		#turnTime = player2.turnTime()
	#else:
		#turnTime = player.turnTime()
	btl_ai = obj_ram.btl_ai;
	fighters = [player, player2];
	
	for fighter in fighters:
		fighter.Stamina = fighter.MaxStamina;
		fighter.Energy = fighter.MaxEnergy;
		fighter.state = "state_free";
	
	set_label = load("res://UI&Menues/set_label.tscn");
	set_bar = load("res://UI&Menues/bar/set_bar.tscn");
	set_nmb = load("res://Battle/set_nmb.tscn");
	
	var tmp_x = 4; var tmp_y = 8;
	for i in range(2):
		var tmp_lbl = instance_create(set_label);
		tmp_lbl.change_font("monshou");
		tmp_lbl.ini(tmp_x, tmp_y, draw_name(i));
		lbls_name.append(tmp_lbl);
		tmp_y += 20;
		
		var tmp_lbl2 = instance_create(set_label);
		tmp_lbl2.change_font("nmb");
		tmp_lbl2.ini(tmp_x+64, tmp_y, draw_stamina(i));
		lbls_hp.append(tmp_lbl2);
		
		var tmp_bar = instance_create(set_bar);
		tmp_bar.ini(tmp_x+2, tmp_y+7, fighters[i], "stamina", 1);
		bars.append(tmp_bar);
		tmp_y += 11;
		
		var tmp_lbl3 = instance_create(set_label);
		tmp_lbl3.change_font("nmb");
		tmp_lbl3.ini(tmp_x+64, tmp_y, draw_energy(i));
		lbls_sp.append(tmp_lbl3);
		
		tmp_bar = instance_create(set_bar);
		tmp_bar.ini(tmp_x+2, tmp_y+7, fighters[i], "energy", 1);
		bars.append(tmp_bar);
		
		tmp_y += 11;
		
		var tmp_lbl4 = instance_create(set_label);
		tmp_lbl4.change_font("nmb");
		tmp_lbl4.ini(tmp_x+80, tmp_y, draw_ap(i));
		lbls_ap.append(tmp_lbl4);
		
		tmp_bar = instance_create(set_bar);
		tmp_bar.ini(tmp_x+2, tmp_y+8, fighters[i], "ap", 0.3);
		bars.append(tmp_bar);
		
		tmp_y = 8;
		tmp_x += 128;
	
	turn = 99;
	not_turn = 99;
	
	#actor_plr = get_node("obj_actor_plr");
	#actor_plr2 = get_node("obj_actor_plr2");
	
	actor_plr = get_node("obj_actor_new");
	actor_plr2 = get_node("obj_actor_new2");
	
	if (freeplay):
		actor_plr2.sprite_frames = spr_seth;
		actor_plr2.get_node("obj_blink").sprite_frames = spr_seth_blink;
	
	
	actor_plr.other_actor = actor_plr2;
	actor_plr.index = 0;
	actor_plr2.other_actor = actor_plr;
	actor_plr2.index = 1;
	
	#actor_plr.change_ani("state_free");
	#actor_plr2.change_ani("state_free");
	
	actors = [actor_plr, actor_plr2];
	user_actor = actor_plr;
	targ_actor = actor_plr2;
	
	state = -2;
	
func instance_create(arg_res):
	var tmp_inst = arg_res.instantiate();
	add_child(tmp_inst);
	return tmp_inst;
	
func draw_name(arg_i):
	return fighters[arg_i].plr_name;
	
func draw_stamina(arg_i):
	return str(fighters[arg_i].Stamina) + "/" + str(fighters[arg_i].MaxStamina);
	
func draw_energy(arg_i):
	return str(fighters[arg_i].Energy) + "/" + str(fighters[arg_i].MaxEnergy);
	
func draw_ap(arg_i):
	return str(fighters[arg_i].sp);
	
func update_hud():
	for i in range(2):
		lbls_hp[i].draw(draw_stamina(i));
		lbls_sp[i].draw(draw_energy(i));
		lbls_ap[i].draw(draw_ap(i));

func get_faster():
	var spd1 = player.get_stat("rfx") + randGen.randi_range(1, 10);
	var spd2 = player2.get_stat("rfx") + randGen.randi_range(1, 10);
	if (spd1 > spd2):
		return 0;
	else:
		return 1;
		
func i_invert(arg_i):
	if (arg_i == 0):
		return 1;
	else:
		return 0;
		
func update_clock():
	clock.text = "Time: " + str(time) + " Round: " + str(round);
	
func refresh():
	for actor in actors:
		actor.refresh();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#If reading and text done, continue battle flow
	if (reading):
		if (obj_ram.text_done):
			obj_ram.text_done = false;
			running = true;
			reading = false;
	#If waiting for menu and menu done, continue battle flow
	elif (menuing):
		if (obj_ram.menu_done):
			obj_ram.menu_done = false;
			running = true;
			menuing = false;
			
	if (running):
		match state:
			-2:
				cd = set_cd.instantiate();
				add_child(cd);
				for actor in actors:
					actor.change_ani("state_free");
					actor.can_repos = false;
			-1:
				if not (cd.done):
					state += -1;
				else:
					obj_ram.play_sound("dingdingding");
					if (obj_ram.freeplay):
						obj_ram.play_bgm("bgm_RottingBiscuits");
					else:
						obj_ram.play_bgm("bgm_ForbiddenLand");
					cd.queue_free();
					for actor in actors:
						actor.can_repos = true;
					
			0:
				update_clock();
				batTurnTime(player, player2)
				obj_ram.scr_msg("An /vopponent/w draws near!");
				#"running = false" stops battle flow,
				#"reading = true" makes it so the battle flow
				#waits for the text box to be closed
				#(when obj_ram.text_done == true)
				#before moving onto the next step.
				#Anything else that the battle flow needs to wait for
				#should have its own variable and corresponding
				#obj_ram global variable to track it.
				#Like, say, "animating" or "moving"
				reading = true; running = false;
			1:
				refresh();
				#Get some vars for user, targ, and the actors.
				#turn / not_turn are indexes for the array of fighters.
				#Change this if time
				if (turn == 0):
					turn = 1
				elif (turn == 1):
					turn = 0
				else:
					turn = get_faster();
				not_turn = i_invert(turn);
				
				user = fighters[turn];
				targ = fighters[not_turn];
				user_actor = actors[turn];
				targ_actor = actors[not_turn];
				
				reacting = false;
				
				obj_ram.scr_msg(user.plr_name + "'s turn!");
				#user_actor.update_pos();
				reading = true; running = false;
				if (user.sp <= 0):
					running = true
					state = 4
			2:
				if (user.isAI):
					user_actor.refresh();
				else:
					obj_ram.btl_user = user;
					obj_ram.btl_targ = targ;
					user_actor.refresh();
					if (freeplay):
						obj_ram.input_player = turn;
					obj_ram.scr_btl_cmds_open(user.get_cmds());
					menuing = true;
					running = false;
			3:
				#change location of time change, moved to state 6
				#time -= turnTime;
				#update_clock();
				if (user.isAI):
					move = btl_ai.decide_move(user, target)
				else:
					if (user.state == "state_grab" or user.state == "state_grapple"):
						move = user.grappleMoves[obj_ram.menu_index];
					elif (user.state == "state_grabbed" or user.state == "state_grappled"):
						move = user.grappledMoves[obj_ram.menu_index];
					else:
						move = user.moves[obj_ram.menu_index];
				var msg = move["use_line"];
				msg = msg.replace("{user}", user.plr_name);
				obj_ram.scr_msg(msg);
				user_actor.change_ani(move["use_ani"]);
				user_actor.z_index = 1;
				targ_actor.z_index = 0;
				stats.findVars()
				reading = true;
				running = false;
				user.Action(move["cost"]);
				update_hud();
			4:
				var hit = obj_ram.call_btl_code(move["success"], user, targ);
				result = null;
				if (hit):
					result = obj_ram.call_btl_code(move["code"], user, targ);
					var dmg = result[0];
					var alive = result[1];
					var msg = result[2];
					var user_ani = result[3];
					var targ_ani = result[4];
					
					if (user_ani):
						user_actor.change_ani(user_ani);
					
					if (targ_ani):
						targ_actor.change_ani(targ_ani);
					if (dmg > 0):
						var tmp_nmb = set_nmb.instantiate();
						targ_actor.add_child(tmp_nmb);
						tmp_nmb.ini(targ_actor, dmg);
						
					if (msg != ""):
						obj_ram.scr_msg(msg);
					stats.findVars();
					
					if (not alive or targ.get_stat("sta") <= 0):
						state = 98
				else:
					targ_actor.change_ani("dodge");
					obj_ram.scr_msg("A miss!");
					# current bug means player won't ever get past this
				update_hud();
				user.checkFatigue()
				var react = reaction(targ)
				#print(react)
				if (react and targ.sp > 0):
					state = 9;
				reading = true;
				running = false;
				#Remember, state is inc'ed by 1, so to jump to another index,
				#be sure to use (target index - 1).
			5:
				if (user.sp > 0):
					state = 1
				elif (user.sp > 0 and user.sp < user.actionCost):
					user.actionCost = user.actionCost - user.sp;
					user.sp = 0;
					user.nextTurn();
				else:
					user.nextTurn();
				update_hud();
				#reading = true;
				#running = false;
			6:
				#targ.Agility += 100;
				refresh();
				time -= turnTime;
				update_clock();
				if (time == 0): 
					obj_ram.scr_msg("End of round!")
					reading = true; running = false;
					user.heal_energy(user.MaxEnergy)
					targ.heal_energy(targ.MaxEnergy)
					round += 1 
					time = 60;
					update_hud();
					update_clock();
				state = 0;
			#state 10-13 is for reactions only
			10:
				refresh();
				reacting = true;
				reactionUser = fighters[not_turn];
				reactionTarget = fighters[turn];
				user_actor.z_index = 0;
				targ_actor.z_index = 1;
				obj_ram.btl_user = reactionUser;
				obj_ram.scr_msg(reactionUser.plr_name + "'s /yReaction/w!");
				reading = true; running = false;
			11:
				if (reactionUser.isAI):
					user_actor.refresh();
				else:
					user_actor.refresh();
					if (freeplay):
						obj_ram.input_player = i_invert(turn);
					obj_ram.scr_btl_cmds_open(reactionUser.get_cmds());
					menuing = true;
					running = false;
			12:
				if (reactionUser.isAI):
					move = btl_ai.decide_move(reactionUser, reactionTarget)
				else:
					if (reactionUser.state == "state_grab" or reactionUser.state == "state_grapple"):
						move = reactionUser.grappleMoves[obj_ram.menu_index];
					elif (reactionUser.state == "state_grabbed" or reactionUser.state == "state_grappled"):
						move = reactionUser.grappledMoves[obj_ram.menu_index];
					else:
						move = reactionUser.moves[obj_ram.menu_index];
				var msg = move["use_line"];
				msg = msg.replace("{user}", reactionUser.plr_name);
				obj_ram.scr_msg(msg);
				targ_actor.change_ani(move["use_ani"]);
				stats.findVars()
				reading = true;
				running = false;
				reactionUser.Action(move["cost"]);
				update_hud();
			13:
				var hit = obj_ram.call_btl_code(move["success"], reactionUser, reactionTarget);
				result = null;
				if (hit):
					result = obj_ram.call_btl_code(move["code"], reactionUser, reactionTarget);
					var dmg = result[0];
					var alive = result[1];
					var msg = result[2];
					var targ_ani = result[3];
					var user_ani = result[4];
					
					if (targ_ani):
						targ_actor.change_ani(targ_ani);
					
					if (user_ani):
						user_actor.change_ani(user_ani);
						
					if (dmg > 0):
						var tmp_nmb = set_nmb.instantiate();
						user_actor.add_child(tmp_nmb);
						tmp_nmb.ini(targ_actor, dmg);
						
					if (msg != ""):
						obj_ram.scr_msg(msg);
					stats.findVars()
					
					if (not alive or reactionTarget.get_stat("sta") <= 0):
						state = 98
				else:
					user_actor.change_ani("dodge");
					obj_ram.scr_msg("A miss!");
					# current bug means player won't ever get past this
				update_hud();
				reactionUser.checkFatigue();
				reading = true;
				running = false;
				state = 4
			99:
				obj_ram.stop_bgm();
				user_actor.change_ani("center");
				user_actor.z_index = 1;
				targ_actor.change_ani("dead");
			100:
				if (user_actor.ani_done):
					obj_ram.play_ambient("cheering");
					obj_ram.play_bgm("bgm_VictoryIsOurs");
					obj_ram.scr_msg(user.plr_name + " has /gwon/w the match!");
					reading = true;
					running = false;
				else:
					state += -1;
					
			130:
				obj_ram.stop_bgm();
				obj_ram.stop_ambient();
				if (freeplay):
					obj_ram.scene_warp(obj_ram.scene_multi);
				else:
					obj_ram.scene_warp(obj_ram.warps["home"]);
				running = false;
		state += 1;
		
		'''
		match state:
			0:
				obj_ram.scr_msg("A fierce battle begins!");
				actor_plr.change_ani(1);
				actor_init = player.initGen();
				actor2_init = player2.initGen();
				reading = true;
				running = false;
			1:
				if (actor_init > actor2_init):
					obj_ram.scr_msg(player_name + "Turn " + "What will you do?");
					reading = true;
					running = false;
					actor_plr.change_ani(0);
				else:
					obj_ram.scr_msg(player2_name + "Turn " + "What will you do?");
					reading = true;
					running = false;
					actor_plr2.change_ani(0);
			2:
				#need to add more player 2 animations
				if (actor_init > actor2_init):
					obj_ram.scr_btl_cmds_open(obj_ram.tmp_btl_cmds);
					menuing = true;
					running = false;
					actor_plr.change_ani(2);
				else:
					obj_ram.scr_btl_cmds_open(obj_ram.tmp_btl_cmds);
					menuing = true;
					running = false;
					actor_plr.change_ani(2);
			3:
				obj_ram.scr_msg("You have selected action " + str(obj_ram.menu_index) + ".");
				running = false;
				reading = true;
			4:
				match obj_ram.menu_index:
					0:
						if (actor_init > actor2_init):
							obj_ram.scr_msg(player_name + " punches!");
							player.punchAction();
							stats.findVars();
							#stats._process(1);
							running = false; reading = true;
							actor_plr.change_ani(3);
						else:
							obj_ram.scr_msg(player2_name + " punches!");
							player2.punchAction();
							stats.findVars();
							#stats._process(1);
							running = false; reading = true;
							actor_plr.change_ani(3);
					1:
						if (actor_init > actor2_init):
							obj_ram.scr_msg(player_name + " kicks!");
							player.kickAction();
							stats.findVars();
							#stats._process(1);
							running = false; reading = true;
							actor_plr.change_ani(3);
						else:
							obj_ram.scr_msg(player2_name + " kicks!");
							player2.kickAction();
							stats.findVars();
							#stats._process(1);
							running = false; reading = true;
							actor_plr.change_ani(3);
					2:
						if (actor_init > actor2_init):
							obj_ram.scr_msg(player_name + " performs a takedown!");
							player.takedownAction();
							stats.findVars();
							#stats._process(1);
							running = false; reading = true;
							actor_plr.change_ani(3);
						else:
							obj_ram.scr_msg(player2_name + " performs a takedown!");
							player2.takedownAction();
							stats.findVars();
							#stats._process(1);
							running = false; reading = true;
							actor_plr.change_ani(3);
			5:
				if (actor_init > actor2_init):
					if (ifHits(player, player2)):
						obj_ram.scr_msg(player2_name + " gets hit!| Owch!");
						running = false; reading = true;
						actor_plr.change_ani(4);
					else:
						obj_ram.scr_msg(player2_name + " Avoids the attack!");
						running = false; reading = true;
						actor_plr.change_ani(4);
				else:
					if (ifHits(player2, player)):
						obj_ram.scr_msg(player_name + " gets hit!| Owch!");
						running = false; reading = true;
						actor_plr.change_ani(4);
					else:
						obj_ram.scr_msg(player_name + " Avoids the attack!");
						running = false; reading = true;
						actor_plr.change_ani(4);
			6:
				if (actor_init > actor2_init):
					obj_ram.scr_msg(player2_name + "Turn " + "What will you do?");
					reading = true;
					running = false;
					actor_plr.change_ani(0);
				else:
					obj_ram.scr_msg(player_name + "Turn " + "What will you do?");
					reading = true;
					running = false;
					actor_plr2.change_ani(0);
			7:
				#need to add more player 2 animations
				if (actor_init > actor2_init):
					obj_ram.scr_btl_cmds_open(obj_ram.tmp_btl_cmds);
					menuing = true;
					running = false;
					actor_plr.change_ani(2);
				else:
					obj_ram.scr_btl_cmds_open(obj_ram.tmp_btl_cmds);
					menuing = true;
					running = false;
					actor_plr.change_ani(2);
			8:
				obj_ram.scr_msg("You have selected action " + str(obj_ram.menu_index) + ".");
				running = false;
				reading = true;
			9:
				match obj_ram.menu_index:
					0:
						if (actor_init < actor2_init):
							obj_ram.scr_msg(player_name + " punches!");
							player.punchAction();
							stats.findVars();
							#stats._process(1);
							running = false; reading = true;
							actor_plr.change_ani(3);
						else:
							obj_ram.scr_msg(player2_name + " punches!");
							player2.punchAction();
							stats.findVars();
							#stats._process(1);
							running = false; reading = true;
							actor_plr.change_ani(3);
					1:
						if (actor_init < actor2_init):
							obj_ram.scr_msg(player_name + " kicks!");
							player.kickAction();
							stats.findVars();
							#stats._process(1);
							running = false; reading = true;
							actor_plr.change_ani(3);
						else:
							obj_ram.scr_msg(player2_name + " kicks!");
							player2.kickAction();
							stats.findVars();
							#stats._process(1);
							running = false; reading = true;
							actor_plr.change_ani(3);
					2:
						if (actor_init < actor2_init):
							obj_ram.scr_msg(player_name + " performs a takedown!");
							player.takedownAction();
							stats.findVars();
							#stats._process(1);
							running = false; reading = true;
							actor_plr.change_ani(3);
						else:
							obj_ram.scr_msg(player2_name + " performs a takedown!");
							player2.takedownAction();
							stats.findVars();
							#stats._process(1);
							running = false; reading = true;
							actor_plr.change_ani(3);
			10:
				if (actor_init > actor2_init):
					if (ifHits(player2, player)):
						obj_ram.scr_msg(player_name + " gets hit!| Owch!");
						running = false; reading = true;
						actor_plr.change_ani(4);
					else:
						obj_ram.scr_msg(player_name + " Avoids the attack!");
						running = false; reading = true;
						actor_plr.change_ani(4);
				else:
					if (ifHits(player, player2)):
						obj_ram.scr_msg(player2_name + " gets hit!| Owch!");
						running = false; reading = true;
						actor_plr.change_ani(4);
					else:
						obj_ram.scr_msg(player2_name + " Avoids the attack!");
						running = false; reading = true;
						actor_plr.change_ani(4);
			11:
				player.nextTurn();
				player2.nextTurn();
				stats.findVars();
				obj_ram.scr_msg("Time to start over!| Yay!");
				running = false;
				reading = true;
				state = -1;
		state += 1;
		'''
		
		
func ifHits(at, df):
	var hitProb = ((at.attackScore()/(at.attackScore() + df.toHit())) * 100)
	hitProb = ceili(hitProb)
	var hitPer = randGen.randi_range(1, 100)
	if (hitPer <= hitProb):
		return true
	else:
		return false
		
		
func batTurnTime(p1, p2):
	if (player.get_stat("Turn Time") > player2.get_stat("Turn Time")):
		turnTime = player.get_stat("Turn Time");
		player2.finalAP(turnTime)
	else:
		turnTime = player2.get_stat("Turn Time");
		player.finalAP(turnTime)
		
		
#These reactions are causing the game to crash, due to messages. To be fixed
func reaction(def):
	percent = ((def.get_stat("rfx") / 10.0) * 100)/2
	print(percent)
	roll = randGen.randi_range(1, 100)
	print(roll)
	return roll <= percent
	
	
		
