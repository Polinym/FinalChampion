extends Node2D

var set_label;
var set_info;
var set_prompt;
var set_items;

var btns;
var state = 0;

var pos = 0;
var ani_count = 0; var ani_wait = 18;
var ani_frame = 0;

var status;
var prompt;
var items;

var lbl_cmd = "";
var commands = [];

var player;

var last_pos = 5;

var reading = false;
var player_name;

var goto_gym = false;
var ini = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_label = load("res://UI&Menues/set_label.tscn");
	set_info = load("res://Campaign/info/set_info.tscn");
	set_prompt = load("res://Campaign/prompt/set_prompt.tscn");
	set_items = load("res://Campaign/items/set_items.tscn");
	
	btns = [];
	btns.append(get_node("obj_btn_info"));
	btns.append(get_node("obj_btn_gym"));
	btns.append(get_node("obj_btn_stuff"));
	btns.append(get_node("obj_btn_spar"));
	btns.append(get_node("obj_btn_quit"));
	btns.append(get_node("obj_btn_coach"));
	
	lbl_cmd = set_label.instantiate();
	add_child(lbl_cmd);
	commands = ["My Stats", "Gym", "My Items", "Sparring", "Quit Game", "Coaching"];
	lbl_cmd.ini(128, -24, "");
	lbl_cmd.change_font("kip2");
	
	player = obj_ram.ow_player;
	player_name = obj_ram.player.plr_name;
	
	var cam = player.get_node("obj_camera");
	var tmp_pos = cam.get_screen_center_position();
	self.position.x = tmp_pos.x - 104;
	self.position.y = tmp_pos.y + 150;
	
	var info_box = set_info.instantiate();
	add_child(info_box);
	info_box.position.y += -176;
	info_box.position.x += 256;
	
	items = set_items.instantiate();
	add_child(items);
	items.position.x += 0;
	items.position.y += 64;
	
	obj_ram.play_sound("menu_open");
	
func reset_btn():
	for btn in btns:
		btn.frame = 0;
	ani_frame = 1;
	ani_count = 0;
	btns[pos].frame = 1;
	lbl_cmd.draw(commands[pos]);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		0:
			if (ani_count < ani_wait):
				ani_count += 1;
				self.position.y += -4;
			else:
				ani_wait = 10;
				ani_count = 0;
				pos = 0;
				btns[0].frame = 1;
				state = 1;
				reset_btn();
		1:
			if (reading):
				if (obj_ram.text_done):
					reading = false;
					obj_ram.text_done = false;
			else:
				if (obj_ram.keyboard_check("vk_right")):
					if (pos < 4):
						pos += 2;
						reset_btn();
					obj_ram.play_sound("menu_blip");
				elif (obj_ram.keyboard_check("vk_left")):
					if (pos > 1):
						pos += -2;
						reset_btn();
					obj_ram.play_sound("menu_blip");
				elif (obj_ram.keyboard_check("vk_down")):
					match pos:
						0:
							pos = 1;
						2:
							pos = 3;
						4:
							pos = 5;
					obj_ram.play_sound("menu_blip");
					reset_btn();
				elif (obj_ram.keyboard_check("vk_up")):
					match pos:
						1:
							pos = 0;
						3:
							pos = 2;
						5:
							pos = 4;
					obj_ram.play_sound("menu_blip");
					reset_btn();
						
				elif (obj_ram.keyboard_check("vk_shift")):
					btns[pos].frame = 0;
					ani_count = 0;
					ani_wait = 18;
					state = 2;
					status.state = 2;
					obj_ram.play_sound("menu_close");
				elif (obj_ram.keyboard_check("vk_space")):
					match pos:
						0:
							ani_count = 0;
							ani_wait = 32;
							state = 3;
							status.state = 3;
							obj_ram.play_sound("menu_confirm");
						1:
							prompt = set_prompt.instantiate();
							add_child(prompt);
							prompt.ini("Go to gym", "Stay here");
							prompt.position.x += 40;
							prompt.position.y += -112;
							state = 6;
							obj_ram.play_sound("menu_confirm");
						2:
							state = 8;
							items.state = 0;
							obj_ram.play_sound("menu_confirm");
						3:
							obj_ram.scr_msg("You don't know anyone to spar against!");
							obj_ram.play_sound("menu_confirm");
							reading = true;
						4:
							prompt = set_prompt.instantiate();
							add_child(prompt);
							prompt.ini("Quit game", "Continue");
							prompt.position.x += 40;
							prompt.position.y += -112;
							state = 7;
							obj_ram.play_sound("menu_confirm");
				else:
					if (ani_count < ani_wait):
						ani_count += 1;
					else:
						if (ani_frame == 0):
							ani_frame = 1;
						else:
							ani_frame = 0;
						ani_count = 0;
						btns[pos].frame = ani_frame;
				
		2:
			if (ani_count < ani_wait):
				self.position.y += 4;
				ani_count += 1;
			else:
				player.state = "free";
				queue_free();
		3:
			if (ani_count < ani_wait):
				ani_count += 1;
				self.position.x += -8;
				status.position.x += -8;
			else:
				ani_count = 0;
				ani_wait = 10;
				state = 4;
		4:
			if (obj_ram.keyboard_check("vk_shift")) or (obj_ram.keyboard_check("vk_space")):
				state = 5;
				ani_count = 0;
				ani_wait = 32;
				obj_ram.play_sound("menu_back");
				
		5:
			if (ani_count < ani_wait):
				ani_count += 1;
				self.position.x += 8;
				status.position.x += 8;
			else:
				ani_count = 0;
				ani_wait = 10;
				state = 1;
				
		6:
			if (reading):
				if (obj_ram.text_done):
					if (goto_gym):
						state = 255;
						reading = false;
						obj_ram.text_done = false;
						obj_ram.scene_warp(obj_ram.scene_gym);
					else:
						state = 1;
						reading = false;
						obj_ram.text_done = false;
			elif (prompt != null) and (prompt.done):
				match prompt.pos:
					0:
						obj_ram.scr_msg(player_name + " caught a hoverbus to the gym.|");
						goto_gym = true;
						reading = true;
					1:
						obj_ram.scr_msg(player_name + " will stay here for now.");
						reading = true;
				prompt.queue_free();
				prompt = null;
		7:
			if (reading):
				if (obj_ram.text_done):
					if (goto_gym):
						state = 255;
						reading = false;
						obj_ram.text_done = false;
						obj_ram.in_ow = false;
						obj_ram.scene_warp(obj_ram.scene_title);
					else:
						state = 1;
						reading = false;
						obj_ram.text_done = false;
			elif (prompt != null) and (prompt.done):
				match prompt.pos:
					0:
						obj_ram.scr_msg(player_name + " decided to call it a day.|");
						goto_gym = true;
						reading = true;
					1:
						obj_ram.scr_msg("Carry on then!");
						reading = true;
				prompt.queue_free();
				prompt = null;
		8:
			if (items.done):
				items.done = false;
				state = 1;
			
