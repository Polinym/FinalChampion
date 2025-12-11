extends Node2D
var set_label = load("res://UI&Menues/set_label.tscn");

var spr_char = load("res://spr/camp/ani_char.tres");
var spr_char_btl = load("res://spr/btl/actor/ani_char_btl.tres");
var spr_char_workout = load("res://spr/camp/ani_char_workout.tres");
var spr_char_run = load("res://spr/camp/ani_char_run.tres");


var opts = [];
var opt_names = ["Strength", "Agility", "Reflexes", "Leave"];
var pos = 0; var last_pos = 3;
var opt;

var obj_actor;
var obj_blink;
var obj_treadmill;
var obj_blink_run;

var ani_count = 0; var ani_wait = 10;

var state = 0;
var running = false;
var reading = false;

var player;
var player_name = "Owen";

var blink_count = 0; var blink_wait = 40;
var blink = false;

var actor_ani_count = 0; 
var actor_ani_wait = 0;
var actor_ani_state = 0;
var actor_ani = "";

var lbl_title;

var treadmill_count = 0;
var treadmill_wait = 3;

var energy = 2;

# Called when the node enters the scene tree for the first time.
func _ready():
	obj_ram.play_bgm("bgm_JustChillin");
	opts.append(get_node("obj_opt_strength"));
	opts.append(get_node("obj_opt_agility"));
	opts.append(get_node("obj_opt_reflexes"));
	opts.append(get_node("obj_opt_leave"));
	obj_blink = get_node("obj_blink");
	obj_actor = get_node("obj_actor");
	obj_treadmill = get_node("obj_treadmill");
	obj_blink_run = get_node("obj_blink_run");
	
	lbl_title = set_label.instantiate();
	add_child(lbl_title);
	lbl_title.change_font("title");
	lbl_title.ini(112, 12, "GYM");
	
	var i = 0;
	for opt in opts:
		var tmp_label = set_label.instantiate();
		opt.add_child(tmp_label);
		tmp_label.change_font("title");
		tmp_label.ini(32, 8, opt_names[i]);
		i += 1;
	
	player = obj_ram.player;
	player_name = player.plr_name;


func opt_blink_ani():
	if (ani_count < ani_wait):
		ani_count += 1;
	else:
		if (opt.frame == 0):
			opt.frame = 1;
		else:
			opt.frame = 0;
		ani_count = 0;
	
func opt_blink_reset():
	for opt in opts:
		opt.frame = 0;
	opt = opts[pos];
	opt.frame = 1;
	ani_count = 0;
	
func blink_ani():
	if (actor_ani == "idle"):
		if (blink_count < blink_wait):
			blink_count += 1;
		else:
			blink_count = 0;
			if (blink):
				obj_blink.visible = false;
				obj_blink_run.visible = false;
				blink_wait = obj_ram.scr_rng(85, 165);
				obj_ram.blink = false;
				blink = false;
			else:
				obj_blink.visible = true;
				obj_blink_run.visible = true;
				blink_wait = 15;
				obj_ram.blink = true;
				blink = true;
				
func change_actor_ani(arg_ani):
	var offset_x = obj_actor.offset.x;
	var offset_y = obj_actor.offset.y;
	obj_treadmill.visible = false;
	obj_blink_run.modulate[3] = 0;
	actor_ani_count = 0;
	actor_ani = arg_ani;
	match arg_ani:
		"idle":
			offset_x = 0;
			obj_actor.sprite_frames = spr_char;
			obj_actor.frame = 0;
		"celebrate":
			offset_x = -8;
			obj_actor.sprite_frames = spr_char_btl;
			obj_actor.frame = 16;
			actor_ani_wait = 22;
		"workout":
			offset_x = -4;
			obj_actor.sprite_frames = spr_char_workout;
			obj_actor.frame = 0;
			actor_ani_state = 0;
			actor_ani_wait = 16;
		"leave":
			offset_x = 0;
			obj_actor.sprite_frames = spr_char;
			obj_actor.frame = 6;
			actor_ani_wait = 12;
		"run":
			obj_actor.sprite_frames = spr_char_run;
			obj_actor.frame = 0;
			obj_treadmill.visible = true;
			obj_blink_run.modulate[3] = 1;
			actor_ani_wait = 6;
	obj_actor.offset.x = offset_x;
	obj_actor.offset.y = offset_y;
			
func do_actor_ani():
	var ani_update = false;
	if (actor_ani_count < actor_ani_wait):
		actor_ani_count += 1;
	else:
		ani_update = true;
		actor_ani_count = 0;
	match actor_ani:
		"idle":
			obj_actor.frame = 0;
		"celebrate":
			if (ani_update):
				if (obj_actor.frame == 16):
					obj_actor.frame = 17;
				else:
					obj_actor.frame = 16;
		"leave":
			obj_actor.position.x += 0.5;
			if (ani_update):
				if (obj_actor.frame == 6):
					obj_actor.frame = 7;
				else:
					obj_actor.frame = 6;
		"run":
			if (ani_update):
				var tmp_frame = obj_actor.frame;
				if (tmp_frame < 3):
					tmp_frame += 1;
				else:
					tmp_frame = 0;
				obj_actor.frame = tmp_frame;
		"workout":
			if (ani_update):
				match actor_ani_state:
					0:
						obj_actor.frame = 1;
						actor_ani_wait = 12;
					1:
						obj_actor.frame = 2;
						actor_ani_wait = 10;
					2:
						obj_actor.frame = 3;
						actor_ani_wait = 28;
					3:
						obj_actor.frame = 2;
						actor_ani_wait = 6;
					4:
						obj_actor.frame = 1;
						actor_ani_wait = 5;
					5:
						obj_actor.frame = 0;
						actor_ani_wait = 30;
				if (actor_ani_state < 5):
					actor_ani_state += 1;
				else:
					actor_ani_state = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	do_actor_ani();
	if (treadmill_count < treadmill_wait):
		treadmill_count += 1;
	else:
		var tmp_frame = obj_treadmill.frame;
		if (tmp_frame == 0):
			tmp_frame = 1;
		else:
			tmp_frame = 0;
		obj_treadmill.frame = tmp_frame;
		treadmill_count = 0;
	match state:
		0:
			obj_ram.scr_msg("This is the /ygym/w.| What stat will " + player_name + " work on?");
			obj_ram.text_display_hold(false);
			state = 1;
		1:
			opt = opts[pos];
			opt_blink_ani();
			if (obj_ram.keyboard_check("vk_down")):
				if (pos < last_pos):
					pos += 1;
					opt_blink_reset();
					obj_ram.play_sound("prompt_blip");
			elif (obj_ram.keyboard_check("vk_up")):
				if (pos > 0):
					pos += -1;
					opt_blink_reset();
					obj_ram.play_sound("prompt_blip");
			elif (obj_ram.keyboard_check("vk_space")):
				obj_ram.play_sound("prompt_confirm");
				opt.frame = 2;
				match pos:
					0:
						change_actor_ani("workout");
						obj_ram.scr_msg(player_name + " got to work lifting weights and working on his strength...|");
						state = 3;
					1:
						change_actor_ani("run");
						obj_ram.scr_msg(player_name + " ran on the treadmill, working on his agility|");
						state = 5;
					3:
						obj_ram.scr_msg(player_name + " decided to head home.");
						change_actor_ani("leave");
						obj_ram.text_display_hold(true);
						state = 2;
		2:
			if (obj_ram.text_done):
				obj_ram.text_done = false;
				obj_ram.scene_warp(obj_ram.warps["home"]);
				obj_ram.spawn_dir = 2;
				obj_ram.spawn = [120, 80];
		3:
			if (obj_ram.text_done):
				player.Strength += 1;
				obj_ram.text_done = false;
				obj_ram.play_sound2("victory");
				change_actor_ani("celebrate");
				var tmp_msg = "His /yStrength/w increased by /g1/w!|";
				obj_ram.scr_msg(tmp_msg);
				state = 6;
				energy += -1;
				if (energy < 1):
					state = 4;
		4:
			if (obj_ram.text_done):
				obj_ram.text_done = false;
				change_actor_ani("leave");
				var tmp_msg = "Tired from his workout, he then decided to head home.";
				obj_ram.scr_msg(tmp_msg);
				state = 2;
				
		5:
			if (obj_ram.text_done):
				player.Agility += 1;
				obj_ram.text_done = false;
				change_actor_ani("celebrate");
				obj_ram.play_sound2("victory");
				var tmp_msg = "His /yAgility/w increased by /g1/w!|";
				obj_ram.scr_msg(tmp_msg);
				state = 6;
				energy += -1;
				if (energy < 1):
					state = 4;
				
		6:
			if (obj_ram.text_done):
				obj_ram.text_done = false;
				state = 1;
				change_actor_ani("idle");
					
