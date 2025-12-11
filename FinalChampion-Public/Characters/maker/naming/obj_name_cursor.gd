extends Node2D;
var set_label;

var ani_count = 0;
var ani_wait = 20;
var pos_x = 0;
var pos_y = 0;
var last_pos_x = 11;
var last_pos_y = 5;
var start_x = 32;
var start_y = 88;
var done = false;
var keyboard = [];
var name_obj;
var input_name;
var x_sep = 16;
var y_sep = 16;
var player;
var cursor;

# Called when the node enters the scene tree for the first time.
func _ready():
	obj_ram.play_bgm("bgm_ExcuseMe");
	player = obj_ram.player;
	keyboard.append("ABCDEFGHIJKL");
	keyboard.append("MNOPQRSTUVWX");
	keyboard.append("YZ0123456789");
	keyboard.append("abcdefghijkl");
	keyboard.append("mnopqrstuvwx");
	keyboard.append("yz.!?\"*-@() ");
	name_obj = get_node("obj_name");
	set_label = load("res://UI&Menues/set_label.tscn");
	var tmp_lbl = instance_create(set_label);
	tmp_lbl.change_font("monshou");
	var x = self.position.x; 
	var y = self.position.y;
	var tmp_txt = "";
	for row in keyboard:
		for c in row:
			tmp_txt += c + " ";
		tmp_txt += "#";
	tmp_lbl.ini(x+32, y+80, tmp_txt);
	
	
	cursor = get_node("obj_name_cursor");
	cursor.position.x = start_x;
	cursor.position.y = start_y;
	
	input_name = "";
	update_name();
	
func instance_create(arg_res):
	var tmp_inst = arg_res.instantiate();
	add_child(tmp_inst);
	return tmp_inst;
	
func update_name():
	name_obj.text = input_name;
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not done:
		var do_update = false;
		
		
		if (ani_count < ani_wait):
			ani_count += 1;
		else:
			if (cursor.frame == 0):
				cursor.frame = 1;
			else:
				cursor.frame = 0;
			ani_count = 0;
				
				
		if (obj_ram.keyboard_check("vk_right")):
			if (pos_x < last_pos_x):
				pos_x += 1;
			else:
				pos_x = 0;
			do_update = true;
			obj_ram.play_sound("blip");
		elif (obj_ram.keyboard_check("vk_left")):
			if (pos_x > 0):
				pos_x += -1;
			else:
				pos_x = last_pos_x;
			do_update = true;
			obj_ram.play_sound("blip");
		elif (obj_ram.keyboard_check("vk_up")):
			if (pos_y > 0):
				pos_y += -1;
			else:
				pos_y = last_pos_y;
			do_update = true;
			obj_ram.play_sound("blip");
		elif (obj_ram.keyboard_check("vk_down")):
			if (pos_y < last_pos_y):
				pos_y += 1;
			else:
				pos_y = 0;
			do_update = true;
			obj_ram.play_sound("blip");
		elif (obj_ram.keyboard_check("vk_shift")):
			if (len(input_name) > 0):
				input_name = input_name.substr(0, len(input_name)-1);
			update_name();
			obj_ram.play_sound("blip_exit");
		elif (obj_ram.keyboard_check("vk_space")):
			var key = keyboard[pos_y][pos_x];
			if (len(input_name) < 8):
				input_name += key;
			obj_ram.play_sound("blip");
			update_name();
		elif (obj_ram.keyboard_check("vk_x")):
			if (input_name != ""):
				player.plr_name = input_name;
				obj_ram.play_sound("blip_confirm");
				obj_ram.scene_warp(obj_ram.scene_ma);
				done = true;
		if (do_update):
			cursor.frame = 0;
			ani_count = 0;
			update();

func update():
	cursor.position.x = start_x + (pos_x * x_sep);
	cursor.position.y = start_y + (pos_y * y_sep);
