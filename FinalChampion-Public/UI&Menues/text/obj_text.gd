extends Node2D
var txt = "";
var work_txt = "";
var printed_line = false;
var pos = 0x0;
var state = 0x0;
var stop_at = 0x0;
var pause_count = 0x0;
var chars_limit = 20;
var chars = 0x0;
var delay_count = 0;
var delay_wait = 1;
var shifter = -1;
var set_label;
var obj_box;
var end_action = "";

var set_prompt = load("res://Campaign/prompt/set_prompt.tscn");
var obj_prompt = null;

var set_eko = load("res://UI&Menues/set_eko.tscn");
var obj_eko = null;

var spr_char;
var spr_char_sad;
var spr_char_happy;
var spr_char_puzzled;
var spr_char_shocked;

var spr_zakton;
var spr_zakton_angry;

var spr_blink;
var spr_blink_zakton;

var ani_count = 0;
var ani_wait = 24;
var parent;

var obj_port;
var obj_blink;
var port_on = false;
var port_count = 0; var port_wait = 9;
var port_frame = 0;

var obj_name_box;

var lbl_txt;

var lbl_txt_blue;
var lbl_txt_green;
var lbl_txt_violet;
var lbl_txt_yellow;

var lbl_name;
var show_label = false;
var should_close = true;
var x; var y;

var spr_text;
var blip = false;
var blip_count = 2; var blip_wait = blip_count;

var image_alpha = 0;
var image_color;
var fade_speed = 0.1;
var last_name = "";

var txt_color_lbls = [];
var txt_color = -1;
var txt_colors = ["", "", "", ""];

var text_count = 0;
var text_delay = 1;

var blink_count = 0; var blink_wait = 40;
var blink = false;

func blink_ani():
	if (blink_count < blink_wait):
		blink_count += 1;
	else:
		blink_count = 0;
		if (blink):
			obj_ram.blink = false;
			blink_wait = obj_ram.scr_rng(85, 165);
			obj_ram.blink = false;
			blink = false;
		else:
			obj_ram.blink = true;
			blink_wait = 15;
			obj_ram.blink = true;
			blink = true;

func update_alpha():
	image_color[3] = image_alpha;
	obj_box.modulate = image_color;

#Thanks, Bing-AI!
# A function that takes in a string and a character limit, and inserts linebreaks at appropriate spots
'''
func scr_wrap_text(arg_text: String, limit: int) -> String:
	# Initialize an empty string to store the modified text
	var wrapped_text = ""
	# Initialize a counter to keep track of the number of characters in the current line
	var count = 0;
	var tmp_pos = 0;
	# Loop through each character in the text
	for arg_char in arg_text:
		# Add the character to the modified text
		wrapped_text += arg_char
		# Increment the counter by one
		count += 1
		# If the counter reaches the limit, or the character is a newline
		if count == limit or arg_char == "#":
			# Initialize a flag to indicate whether a linebreak was inserted or not
			var inserted = false
			# Loop backwards from the current position to find the last space or punctuation
			for i in range(tmp_pos, -1, -1):
				# If the character at position i is a space or punctuation
				if wrapped_text[i] in [" ", ".", ",", ";", ":", "?", "!"]:
					# Insert a linebreak at position i + 1
					wrapped_text = wrapped_text.insert(i + 1, "#")
					# Set the flag to true
					inserted = true
					# Break out of the loop
					break
			# If no linebreak was inserted, append a linebreak at the end of the modified text
			if not inserted:
				wrapped_text += "#";
			# Reset the counter to zero
			count = 0;
		tmp_pos += 1;
	# Return the modified text
	return wrapped_text;
'''

var breaks = " .!?:,";

func scr_wrap_text(arg_text, arg_limit):
	var tmp_ftxt = arg_text;
	var last_pos = -1;
	var tmp_c;
	var c_count = 0;
	var tmp_rpl = false;
	var skip = false;
	var tmp_i = 0;
	var tmp_pos = 0;
	while (tmp_i < len(tmp_ftxt)):
		tmp_c = tmp_ftxt[tmp_i];
		if (tmp_c in breaks):
			if (tmp_i < len(tmp_ftxt)-1) and not ( (tmp_ftxt[tmp_i+1]) in breaks) :
				last_pos = tmp_pos;
		match (tmp_c):
			"|":
				obj_ram.do_nothing();
			"[":
				obj_ram.do_nothing();
			"]":
				obj_ram.do_nothing();
			"/":
				obj_ram.do_nothing();
				tmp_i += 1;
				tmp_pos += 1;
			">":
				c_count = 0;
				last_pos = -1;
			"#":
				c_count = 0;
				last_pos = -1;
			_:
				c_count += 1;
				if (c_count > (arg_limit - 2)) and (last_pos != -1):
					arg_text = arg_text.insert(last_pos, "#");
					last_pos = -1;
					tmp_pos += 1;
					c_count = 0;
		tmp_i += 1;
		tmp_pos += 1;
	return arg_text;


# A function that takes a string and deletes everything before the first occurrence of a #
func scr_delete_before_hash(arg_text: String) -> String:
	# Find the index of the first # in the text
	var index = arg_text.find("#");
	# If the index is valid
	if index != -1:
		# Return the substring from the index + 1 to the end of the text
		return arg_text.substr(index + 1, arg_text.length() - index - 1)
	else:
		# Return the original text
		return arg_text

# Called when the node enters the scene tree for the first time.
func _ready():
	parent = get_parent();
	set_label = load("res://UI&Menues/set_label.tscn");
	x = self.position.x;
	y = self.position.y;
	lbl_txt = instance_create(set_label);
	lbl_txt.change_font("kip2");
	lbl_txt.ini(16, 176, "");
	
	lbl_txt_blue = instance_create(set_label);
	lbl_txt_blue.change_font("kip_blue");
	lbl_txt_blue.ini(16, 176, "");
	txt_color_lbls.append(lbl_txt_blue);
	
	lbl_txt_green = instance_create(set_label);
	lbl_txt_green.change_font("kip_green");
	lbl_txt_green.ini(16, 176, "");
	txt_color_lbls.append(lbl_txt_green);
	
	lbl_txt_violet = instance_create(set_label);
	lbl_txt_violet.change_font("kip_violet");
	lbl_txt_violet.ini(16, 176, "");
	txt_color_lbls.append(lbl_txt_violet);
	
	lbl_txt_yellow = instance_create(set_label);
	lbl_txt_yellow.change_font("kip_yellow");
	lbl_txt_yellow.ini(16, 176, "");
	txt_color_lbls.append(lbl_txt_yellow);
	
	
	
	lbl_name = instance_create(set_label);
	lbl_name.change_font("nmb");
	lbl_name.ini(16, 157, "");
	lbl_name.z_index = 11;
	
	image_color = self.modulate;
	image_alpha = 0;
	
	var tmp_parent = get_parent();
	parent = tmp_parent;
	obj_port = tmp_parent.get_node("obj_port");
	obj_blink = tmp_parent.get_node("obj_blink");
	obj_box = tmp_parent.get_node("obj_text_box");
	obj_name_box = tmp_parent.get_node("obj_name_box");
	
	spr_char = load("res://spr/port/char/ani_port_char.tres");
	spr_char_sad = load("res://spr/port/char/ani_port_char_sad.tres");
	spr_char_happy = load("res://spr/port/char/ani_port_char_happy.tres");
	spr_char_puzzled = load("res://spr/port/char/ani_port_char_puzzled.tres");
	spr_char_shocked = load("res://spr/port/char/ani_port_char_shocked.tres");
	
	spr_zakton = load("res://spr/port/zakton/ani_port_zakton.tres");
	spr_zakton_angry = load("res://spr/port/zakton/ani_port_zakton_angry.tres");
	
	spr_blink = load("res://spr/port/char/ani_port_char_blink.tres");
	spr_blink_zakton = load("res://spr/port/zakton/ani_port_zakton_blink.tres");
	
	if not (obj_ram.in_btl):
		spr_text = load("res://spr/menu/box/text_cuts.png");
		obj_box.texture = spr_text;
		if (obj_ram.in_ow):
			var cam = obj_ram.ow_player.get_node("obj_camera");
			var tmp_pos = cam.get_screen_center_position();
			tmp_parent.position.x = tmp_pos.x - 128;
			tmp_parent.position.y = tmp_pos.y - 112;
		state = 9;
		update_alpha();
	
	
func instance_create(arg_res):
	var tmp_inst = arg_res.instantiate();
	add_child(tmp_inst);
	return tmp_inst;
	
func update_name(arg_name):
	lbl_name.clear();
	if (arg_name == ""):
		obj_name_box.visible = false;
	else:
		lbl_name.draw(arg_name.to_upper());
		obj_name_box.visible = true;

func ini(arg_msg):
	work_txt = scr_wrap_text(arg_msg, chars_limit);
	print(work_txt);
	stop_at = len(work_txt);
	pos = 0;
	printed_line = false;
	pause_count = 0x0;
	txt = "";
	shifter = get_node("../obj_text_shifter");
	shifter.visible = false;
	blip = false;
	blip_count = blip_wait;
	txt_colors_clear();
	if (image_alpha < 1) and not (obj_ram.in_btl):
		state = 9;
	else:
		state = 1;
	
var i;

func update_txt_colors(arg_index, arg_c):
	var is_lb = (arg_c == "#");
	for i in range(4):
		var tmp_txt = txt_colors[i];
		if (is_lb) or (i == arg_index):
			tmp_txt += arg_c;
		else:
			tmp_txt += " ";
		txt_colors[i] = tmp_txt;
		
func txt_colors_clear():
	for i in range(4):
		txt_colors[i] = "";
		
func txt_colors_lb():
	for i in range(4):
		var tmp_txt = txt_colors[i];
		tmp_txt = scr_delete_before_hash(tmp_txt);
		tmp_txt = tmp_txt + "#";
		txt_colors[i] = tmp_txt;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		1:
			if (delay_count < delay_wait):
				delay_count += 1;
			else:
				delay_count = 0;
				while (true):
					if not (pos < stop_at):
						state = 3;
						shifter.visible = true;
						break;
					var c = work_txt[pos];
					pos += 1;
					
					if (c == "|"):
						pause_count = 30;
						state = 2;
						break;
					elif (c == "/"):
						var c2 = work_txt[pos];
						var tmp_clear_name = false;
						var clear_text = false;
						var tmp_offset = -1;
						match c2:
							"b":
								obj_ram.actor.play_ani("bow");
								end_action = "bow";
							"0":
								port_on = false;
								obj_ram.speaker_name = last_name;
								update_name(obj_ram.speaker_name);
								clear_text = true;
							"A":
								port_on = true;
								obj_blink.frame = 0;
								obj_port.sprite_frames = spr_char;
								tmp_clear_name = true;
								tmp_offset = 0;
								clear_text = true;
							"3":
								port_on = true;
								obj_port.sprite_frames = spr_char_sad;
								obj_blink.frame = 1;
								tmp_clear_name = true;
								tmp_offset = 0;
								clear_text = true;
							"1":
								port_on = true;
								obj_blink.frame = 2;
								obj_port.sprite_frames = spr_char_happy;
								tmp_clear_name = true;
								tmp_offset = 0;
								clear_text = true;
							"4":
								port_on = true;
								obj_blink.frame = 3;
								obj_port.sprite_frames = spr_char_puzzled;
								tmp_clear_name = true;
								tmp_offset = 0;
								clear_text = true;
							"5":
								port_on = true;
								obj_blink.frame = 4;
								obj_port.sprite_frames = spr_char_shocked;
								tmp_clear_name = true;
								tmp_offset = 0;
								clear_text = true;
							"Z":
								port_on = true;
								obj_blink.frame = 0;
								obj_port.sprite_frames = spr_zakton;
								tmp_offset = 1;
								tmp_clear_name = true;
								clear_text = true;
							"z":
								port_on = true;
								obj_blink.frame = 1;
								obj_port.sprite_frames = spr_zakton_angry;
								tmp_offset = 1;
								tmp_clear_name = true;
								clear_text = true;
							"?":
								obj_prompt = set_prompt.instantiate();
								add_child(obj_prompt);
								obj_prompt.position.x += 72;
								obj_prompt.position.y += 80;
								obj_prompt.ini(obj_ram.yes_prompt, obj_ram.no_prompt);
								if (obj_ram.show_eko):
									obj_eko = set_eko.instantiate();
									add_child(obj_eko);
									#obj_eko.position.x += 32;
								state = 10;
								break;
							"c":
								txt_color = 0;
							"g":
								txt_color = 1;
							"v":
								txt_color = 2;
							"y":
								txt_color = 3;
							"w":
								txt_color = -1;
							"u":
								obj_ram.stop_bgm();
								obj_ram.play_bgm("bgm_Unease");
							"$":
								obj_ram.eko += -1;
								obj_ram.play_sound2("purchase");
								var tmp_player = obj_ram.player;
								tmp_player.items.append("flower");
						if (tmp_offset > -1):
							match tmp_offset:
								0:
									obj_blink.sprite_frames = spr_blink;
									obj_port.offset.x = 0;
									obj_port.offset.y = 0;
									obj_blink.offset.x = 0;
									obj_blink.offset.y = 0;
								1:
									obj_blink.sprite_frames = spr_blink_zakton;
									obj_port.offset.x = -30;
									obj_port.offset.y = -40;
									obj_blink.offset.x = -30;
									obj_blink.offset.y = -40;
						if (clear_text):
							txt_colors_clear();
							txt = "";
							printed_line = false;
								
						if (tmp_clear_name):
							last_name = obj_ram.speaker_name;
							obj_ram.speaker_name = "";
							update_name("");
						pos += 1;
						break;
					elif (c == "["):
						blip = true;
					elif (c == "]"):
						blip = false;
					elif (c == ">"):
						shifter.visible = true;
						state = 4;
						break;
					elif (c == "#"):
						if not (printed_line):
							txt = txt + "#";
							update_txt_colors(txt_color, "#");
							printed_line = true;
						else:
							txt = scr_delete_before_hash(txt);
							txt = txt + "#";
							txt_colors_lb();
						break;
					else:
						if (blip):
							if (blip_count < blip_wait):
								blip_count += 1;
							else:
								obj_ram.play_sound("blip_text");
								blip_count = 0;
						txt += c;
						update_txt_colors(txt_color, c);
						if (c == " "):
							blip_count = blip_wait;
						break;
				lbl_txt.draw(txt);
				for i in range(4):
					txt_color_lbls[i].draw(txt_colors[i]);
				
				
		2:
			if (pause_count > 0):
				pause_count += -1;
			else:
				state = 1;
		3:
			if (ani_count < ani_wait):
				ani_count += 1;
			else:
				if (shifter.frame == 0):
					shifter.frame = 1;
				else:
					shifter.frame = 0;
				ani_count = 0;
			if (obj_ram.keyboard_check("vk_space")):
				state = 0;
				obj_ram.text_done = true;
				txt = "";
				shifter.visible = false;
				match (end_action):
					"bow":
						obj_ram.actor.play_ani("bow");
				obj_ram.speaker_name = "";
				if (should_close):
					obj_ram.scr_msg_close();
					obj_ram.show_eko = false;
		4:
			if (ani_count < ani_wait):
				ani_count += 1;
			else:
				if (shifter.frame == 0):
					shifter.frame = 1;
				else:
					shifter.frame = 0;
				ani_count = 0;
				
				
			if (obj_ram.keyboard_check("vk_space")):
				state = 1;
				if not (printed_line):
					txt = txt + "#";
					printed_line = true;
					update_txt_colors(txt_color, "#");
				else:
					txt = scr_delete_before_hash(txt);
					txt = txt + "#";
					txt_colors_lb();
				shifter.visible = false;
		9:
			if (image_alpha < 1):
				image_alpha += fade_speed;
				update_alpha();
			else:
				update_name(obj_ram.speaker_name);
				state = 1;
		10:
			if (obj_prompt.done):
				match obj_prompt.pos:
					0:
						obj_ram.scr_msg(obj_ram.yes_txt);
					1:
						obj_ram.scr_msg(obj_ram.no_txt);
				obj_prompt.queue_free();
				
	if (obj_port != null):
		if (port_on):
				obj_port.visible = true;
				if (state == 1):
					if (port_count < port_wait):
						port_count += 1;
					else:
						if (port_frame < 2):
							port_frame += 1;
						else:
							port_frame = 0;
						port_count = 0;
				else:
					port_frame = 0;
				obj_port.frame = port_frame;
				if not (obj_ram.in_ow):
					blink_ani();
				obj_blink.visible = obj_ram.blink;
		else:
			obj_port.visible = false;
			obj_blink.visible = false;
