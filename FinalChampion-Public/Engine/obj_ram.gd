extends Node

var tree;

var scene;
var root;

var scene_ini;
var scene_title;
var scene_btl;
var scene_name;
var scene_stats;
var scene_list;
var scene_ma;
var scene_cuts;
var scene_plr;
var scene_gym;
var scene_prefight;
var scene_multi;
var scene_boot;

var scene_rm_home;
var scene_rm_street;
var scene_rm_street2;
var scene_rm_lobby;


var inst_text = -1;
var inst_text_obj = -1;

var inst_btl_cmds = -1;
var inst_btl_cursor = -1;
var btl_cmds_open = false;

var set_btl_cmds;
var set_text;
var set_hp_bar;
var set_dummy;
var set_db;

var set_data;
var inst_data;
var obj_moves;
var obj_skills;
var btl_ai;
var player;
var player2;
var dummy;
var db;

var text_done = false;
var text_open = false;
var current_scene = -1;
var tmp_btl_cmds = ["Punch", "Kick", "Takedown", "Sweep", "Grapple"];


var menu_index = 0;
var menu_done = false;
var menu = -1;

var random = RandomNumberGenerator.new()

var dest;
var warp;
var ascii_text;
var ascii_tbl = {};
var sound;
var cuts; var cuts_name = "";

var btl_user = -1;
var btl_targ = -1;

var bases = {};

var in_btl = false;
var in_ow = false;

var ow_player = -1;

var warp_a = "";
var warp_b = "";
var warps = {};

var spawn = [160, 88];
var spawn_dir = 0;

var actor = null;
var player_name = "PlayerName";
var speaker_name = "";

var blink = false;
var eko = 20;

var yes_txt = "";
var no_txt = "";
var yes_prompt = "";
var no_prompt = "";

var show_eko = false;

var flags = {};

var phone = null;

var trigger_msg = "";

var icons = [];
var slow_warp = false;

var input_player = 0;
var input_map = {};

var freeplay = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	ascii_text = " !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
	define_ascii();
	
	set_btl_cmds = load("res://Battle/btl_cmds/set_btl_cmds.tscn");
	set_text = load("res://UI&Menues/text/set_text.tscn");
	set_data = load("res://Battle/data.tscn");

	set_db = load("res://Database/Repository/ControllerDB.gd");
	db = set_db.new();

	
	warp = load("res://UI&Menues/efx/fade/set_warp.tscn");
	print(warp);
	
	set_hp_bar = load("res://UI&Menues/bar/set_bar.tscn");
	
	set_dummy = load("res://Characters/data/set_dummy.tscn");
	inst_data = set_data.instantiate();
	
	obj_moves = inst_data.get_node("obj_moves");
	obj_moves.ini();
	
	obj_skills = inst_data.get_node("obj_skills");
	obj_skills.ini()
	
	btl_ai = inst_data.get_node("btl_ai")
	btl_ai._ini(obj_moves.moves, obj_moves.grappleMoves, obj_moves.grappledMoves)
	
	player = inst_data.get_node("obj_player");
	player.plr_name = "Owen";
	player.ini(obj_moves, obj_skills, false);
	player.index = 0;
	#player.Strength = 40;
	
	player2 = inst_data.get_node("obj_player2");
	player2.plr_name = "Zakton";
	player2.ini(obj_moves, obj_skills, true);
	player2.index = 1;
	
	sound = get_node("obj_sound"); sound.mute = false;
	cuts = get_node("obj_cuts");
	
	var tmp_ini_scene = load("res://ini.tscn");
	dest = tmp_ini_scene;
	
	#Do some weird Godot stuff...
	root = get_tree().root
	scene = root.get_child(root.get_child_count() - 1);
	
	scene_title = ResourceLoader.load("res://Main Menu/title/set_title.tscn");
	scene_btl = ResourceLoader.load("res://Battle/mode/set_btl.tscn");
	scene_name = ResourceLoader.load("res://Characters/maker/naming/set_keyboard.tscn");
	scene_stats = ResourceLoader.load("res://Characters/maker/stats/set_stats.tscn");
	scene_list = ResourceLoader.load("res://Characters/viewer/set_viewer.tscn");
	scene_ma = ResourceLoader.load("res://Characters/maker/ma/set_ma.tscn");
	scene_cuts = ResourceLoader.load("res://Campaign/cuts/set_cuts_con.tscn");
	
	scene_plr = ResourceLoader.load("res://Campaign/ow/set_plr.tscn");
	
	scene_rm_home = ResourceLoader.load("res://Campaign/ow/maps/set_rm_home.tscn");
	scene_rm_street = ResourceLoader.load("res://Campaign/ow/maps/set_rm_street.tscn");
	scene_rm_street2 = ResourceLoader.load("res://Campaign/ow/maps/set_rm_street2.tscn");
	scene_rm_lobby = ResourceLoader.load("res://Campaign/ow/maps/set_rm_lobby.tscn");
	
	scene_gym = ResourceLoader.load("res://Campaign/gym/set_gym.tscn");
	scene_prefight = ResourceLoader.load("res://Campaign/prefight/set_prefight.tscn");
	scene_multi = ResourceLoader.load("res://Multiplayer/set_multi.tscn");
	scene_boot = ResourceLoader.load("res://Bootup/scene_boot.tscn");
	
	warps["street"] = scene_rm_street;
	warps["street2"] = scene_rm_street2;
	warps["home"] = scene_rm_home;
	warps["lobby"] = scene_rm_lobby;
	
	#Please edit me! Currently using placeholder values!
	#Stamina, Energy, Strength, Agility, Reflexes
	bases["Wrestling"] = [50, 55, 1, 1, 1];
	bases["Judo"] = [51, 54, 1, 1, 1];
	bases["BJJ"] = [52, 53, 1, 1, 1];
	bases["Boxing"] = [53, 52, 1, 1, 1];
	bases["Muay Thai"] = [54, 51, 1, 1, 1];
	bases["Kick Boxing"] = [55, 50, 1, 1, 1];
	
	input_map["vk_space"] = ["vk_space", "vk_e"];
	input_map["vk_shift"] = ["vk_shift", "vk_q"];
	input_map["vk_up"] = ["vk_up", "vk_w"];
	input_map["vk_down"] = ["vk_down", "vk_s"];
	input_map["vk_left"] = ["vk_left", "vk_a"];
	input_map["vk_right"] = ["vk_right", "vk_d"];
	input_map["vk_z"] = ["vk_z", "vk_r"];
	input_map["vk_x"] = ["vk_x", "vk_t"];
	
	icons = [];
	icons.append(load("res://spr/icon/icon_owen.png"));
	icons.append(load("res://spr/icon/icon_zakton.png"));
	icons.append(load("res://spr/icon/icon_seth.png"));
	
	new_flags();
	
	dest = scene_boot;
	scene_change();
	
	#scene_warp(scene_title);
	
func new_flags():
	flags["watched_intro"] = false;
	
func set_flag(arg_flag):
	flags[arg_flag] = true;

func check_flag(arg_flag):
	return flags[arg_flag];
	
func define_ascii():
	ascii_tbl = {};
	var index = 0;
	for c in ascii_text:
		ascii_tbl[c] = index;
		index += 1;
	
func get_ascii(arg_char):
	return ascii_tbl[arg_char];

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	do_nothing();

#DO NOTHING!
func do_nothing():
	return true;
	
func limit_camera(arg_left, arg_top, arg_right, arg_bottom):
	var cam = ow_player.get_node("obj_camera");
	cam.limit_left = arg_left;
	cam.limit_right = arg_right;
	cam.limit_bottom = arg_bottom;
	cam.limit_top = arg_top;
	
func instance_create(arg_set):
	var tmp = arg_set.instantiate();
	add_child(tmp);
	return tmp;
	
func instance_destroy(arg_inst):
	arg_inst.queue_free();
	
func goto_battle():
	scene_warp(scene_btl);
	
#Random number generator, with min and max (inclusive).
func scr_rng(arg_min ,arg_max):
	return random.randi_range(arg_min, arg_max);
	
#Print a msg on the screen. When obj_text is done, is sets obj_ram.text_done to true.
func scr_msg(arg_msg):
	if not (text_open):
		text_open = true;
		inst_text = set_text.instantiate();
		inst_text_obj = inst_text.get_node("obj_text");
		scene.add_child(inst_text);
	inst_text_obj.ini(arg_msg);
	
#Close the textbox.
func scr_msg_close():
	if (text_open):
		text_open = false;
		inst_text.free();
	
#Open the btl_cmds menu
func scr_btl_cmds_open(arg_cmds):
	if not (btl_cmds_open):
		inst_btl_cmds = set_btl_cmds.instantiate();
		inst_btl_cursor = inst_btl_cmds.get_node("obj_btl_cmds_cursor");
		scene.add_child(inst_btl_cmds);
		btl_cmds_open = true;
	inst_btl_cursor.ini(2, arg_cmds);
	
#And use this to close it.
func scr_btl_cmds_close():
	if (btl_cmds_open):
		inst_btl_cmds.queue_free();
		inst_btl_cmds = -1;
		inst_btl_cursor = -1;
		btl_cmds_open = false;
	
#Draw the HP bar on the screen.
func spawn_hp_bar():
	var hpbar = set_hp_bar.instantiate();
	scene.add_child(hpbar);
	var tlm = hpbar.get_node("tlm");
	tlm.ini(uf_player_hp, player.max_hp);
	
func scene_warp(arg_scene):
	in_ow = false;
	dest = arg_scene;
	var tmp_warp = warp.instantiate();
	add_child(tmp_warp);
	
func scene_warp2(arg_scene):
	in_ow = false;
	dest = arg_scene;
	var tmp_warp = warp.instantiate();
	add_child(tmp_warp);
	
func cutscene_warp(arg_cuts):
	in_ow = false;
	dest = scene_cuts;
	cuts_name = arg_cuts;
	var tmp_warp = warp.instantiate();
	add_child(tmp_warp);
	
#Change the current scene you're playing in.
#This will come in handy for when we want to switch out of battle
#mode and into other menus, like the title screen or character creator.
func scene_change():
	text_open = false;
	call_deferred("scene_change2", dest)
	
#Left here for some reason, probably don't want it in the future.
func uf_player_hp():
	return player.hp;
	
#...I don't remember why I have one function call another,
#but I'm sure there's a good reason for it...
#Edit: I remember now!
#When transition warps were added, scene_warp() was changed to
#create the warp object instead, and the actual scene-changing is
#handled by this function now. This way, scene_warp() could keep its
#name while not "technically" swapping scenes right away.
func scene_change2(arg_scene):
	scene.free()
	var s = arg_scene;
	scene = s.instantiate();
	get_tree().root.add_child(scene);
	if (cuts_name != ""):
		scene.cuts = cuts.cutscene[cuts_name];
		scene.running = true;
		cuts_name = "";

func play_sound(arg_snd_path):
	sound.play_sound(arg_snd_path);
	
func play_sound2(arg_snd_path):
	sound.play_sound2(arg_snd_path);
	
func play_sound3(arg_snd_path):
	sound.play_sound3(arg_snd_path);

func play_ambient(arg_ambient):
	sound.play_ambient(arg_ambient);
	
func play_bgm(arg_bgm):
	sound.play_bgm(arg_bgm);
	
func stop_sfx():
	sound.stop_sfx();
func stop_bgm():
	sound.stop_bgm();

func clear_ambients():
	sound.clear_ambient();
	
func stop_ambient():
	sound.stop_ambient();
	
#Gets keyboard input.
#This makes the syntax nicer! :)
func keyboard_check(arg_key):
	return Input.is_action_just_pressed(input_map[arg_key][input_player]);
	
func keyboard_hold(arg_key):
	return Input.is_action_pressed(input_map[arg_key][input_player]);
	
func call_btl_code(arg_code, arg_u, arg_t):
	return obj_moves.call_move(arg_code, arg_u, arg_t);
	
func get_char(arg_name):
	var tmp_char = db.getCharacterByName(arg_name);
	#name, stamina, agility, reflexes, energy, conditioning, state, attack_speed):
	dummy = instance_create(set_dummy);
	dummy.plr_name = tmp_char.name;
	dummy.Stamina = tmp_char.stamina;
	dummy.Energy = tmp_char.energy;
	dummy.Strength = tmp_char.strength;
	dummy.Agility = tmp_char.agility;
	dummy.Reflexes = tmp_char.reflexes;
	#Misc. assignment
	return dummy;
	
func text_display_hold(arg_state):
	obj_ram.inst_text_obj.should_close = arg_state;
	
	
func get_chars():
	return db.getAllCharacters();

func add_char(name,	MaxStamina,	MaxEnergy, Strength, Agility, Reflexes, wrestling, muay_thai, judo, bjj, boxing, kick_boxing):
	"Adds a character to the character database"
	
	# Add a character to the database
	db.addCharacter(name,MaxStamina,MaxEnergy,Strength,Agility,Reflexes)
	db.addMartialArt(name, wrestling, muay_thai, judo, bjj, boxing, kick_boxing)
	
func ready_freeplay():
	in_btl = true;
	player2.isAI = false;
	
