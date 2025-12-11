extends Node2D
var set_label;
var set_char;
var char_box;

var name_lbls = [];

var chars = [];
var char;
var port;

var lbl_x = 16;
var lbl_y = 16;

var pos = 0;
var last_pos = 2;
var frame = 0;
var cursor_x = 0;
var cursor_y = 0;
var cursor;
var update = false;
var done = false;
var char_open = false;

var ani_count = 0;
var ani_wait = 50;

func instance_create(arg_res):
	var tmp_inst = arg_res.instantiate();
	add_child(tmp_inst);
	return tmp_inst;
	
func add_label(arg_char):
	var tmp_lbl = instance_create(set_label);
	tmp_lbl.change_font("monshou");
	tmp_lbl.ini(lbl_x, lbl_y, arg_char.name);
	name_lbls.append(tmp_lbl);
	lbl_y += 16;
	
func clear_names():
	for lbl in name_lbls:
		lbl.queue_free();
	name_lbls = [];
	
func cursor_ini():
	cursor = get_node("obj_list_cursor");
	cursor_x = cursor.position.x;
	cursor_y = cursor.position.y;
	pos = 0;
	last_pos = 2;
	frame = 0;
	
func char_stats(arg_char):
	var tmp_txt = "";
	tmp_txt += arg_char.name + "#";
	#tmp_txt += arg_char.Arts + "##";
	tmp_txt += "Stamina:  " + str(arg_char.Stamina) + "##";
	tmp_txt += "Energy:   " + str(arg_char.Energy) + "##";
	tmp_txt += "Strength: " + str(arg_char.Strength) + "##";
	tmp_txt += "Agility:  " + str(arg_char.Agility) + "##";
	tmp_txt += "Reflexes: " + str(arg_char.Reflexes);
	return tmp_txt;
	
func cursor_input():
	if not done:
		if (obj_ram.keyboard_check("vk_down")):
			update = true;
			if (pos < last_pos):
				pos += 1;
			else:
				pos = 0x0;
		elif (obj_ram.keyboard_check("vk_up")):
			update = true;
			if (pos > 0):
				pos += -1;
			else:
				pos = last_pos;
		elif (obj_ram.keyboard_check("vk_shift")):
			obj_ram.play_sound("blip_exit");
			obj_ram.scene_warp(obj_ram.scene_title);
			cursor.frame = 1;
			done = true;
		elif (obj_ram.keyboard_check("vk_space")):
			obj_ram.play_sound("blip_confirm");
			char_box.open(char_stats(char));
			char_open = true;
			
				
		if (update):
			cursor.position.y = cursor_y + (pos * 16);
			obj_ram.play_sound("blip");
			char = chars[pos];
			port.texture = char.port;
			frame = 0; ani_count = 0;
			update = false;
		cursor_ani();
	
func cursor_ani():
	if (ani_count < ani_wait):
		ani_count += 1;
	else:
		if (frame == 0):
			frame = 1;
		else:
			frame = 0;
			cursor.frame = frame;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_char = load("res://Characters/viewer/set_char_box.tscn");
	set_label = load("res://UI&Menues/set_label.tscn");
	port = get_node("obj_port");
	
	# Grab all characters in the database
	var test_chars = load_all_characters();
	draw_chars(test_chars);
	
	
	cursor_ini();
	char = chars[0];
	char_box = instance_create(set_char);
	
func draw_chars(arg_chars):
	clear_names();
	chars = arg_chars;
	for char in chars:
		add_label(char);

func load_test_data():
	var test_chars = [];
	var test_char = {};
	test_char["plr_name"] = "Mars Aritia";
	test_char["port"] = load("res://spr/chars/example/port_mars.png");
	test_char["Stamina"] = 50;
	test_char["Energy"] = 50;
	test_char["Arts"] = "Placeholding Starlord";
	test_char["Strength"] = 50;
	test_char["Agility"] = 50;
	test_char["Reflexes"] = 50;
	test_chars.append(test_char);
	
	test_char = {};
	test_char["plr_name"] = "Dart Feld";
	test_char["port"] = load("res://spr/chars/example/port_dart.png");
	test_char["Stamina"] = 50;
	test_char["Energy"] = 50;
	test_char["Arts"] = "Placeholding Dragoon";
	test_char["Strength"] = 50;
	test_char["Agility"] = 50;
	test_char["Reflexes"] = 50;
	test_chars.append(test_char);
	
	test_char = {};
	test_char["plr_name"] = "Link Hylian";
	test_char["port"] = load("res://spr/chars/example/totally_link_not_mars.png");
	test_char["Stamina"] = 50;
	test_char["Energy"] = 50;
	test_char["Arts"] = "Placeholding Hero of Time";
	test_char["Strength"] = 50;
	test_char["Agility"] = 50;
	test_char["Reflexes"] = 50;
	test_chars.append(test_char);
	return test_chars;

func load_all_characters():
	# Accesses the database to get all of the characters
	# Request data from obj_ram
	var chars = obj_ram.get_chars()
	return chars

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if char_open:
		if (obj_ram.keyboard_check("vk_shift")):
			obj_ram.play_sound("blip_exit");
			char_box.close();
			char_open = false;
	else:
		cursor_input();
