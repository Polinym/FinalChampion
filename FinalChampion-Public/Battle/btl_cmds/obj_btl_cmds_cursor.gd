extends Sprite2D

var pos = 0x0;
var last_pos;
var ani_count = 0;
var ani_wait = 25;
var ani_frame = 0;
var update = false;
var start_x;
var start_y;

var obj_qstats;
var stats_open = false;

var cursor_r;
var cursor_l;

var c_ani_count = 0;

var pages = [];
var page_count = 0;
var item_count;
var page = 0;
var obj_text;

var char;
var obj_btl;
var my_set;
var spr_box2;
var set_label;
var lbl;

var obj_qstats_btn;
var spr_qstats;
var spr_qstats2;
var spr_lbl_p2 = load("res://spr/btl/ani_lbl_p2.tres");

var reaction;

var lbl_count = 0; var lbl_wait = 15;

var obj_lbl_p;

# Called when the node enters the scene tree for the first time.
func _ready():
	char = obj_ram.btl_user;
	
	obj_ram.play_sound("btl_cmds_open");
	start_x = self.position.x;
	start_y = self.position.y;
	obj_btl = obj_ram.scene;
	
	my_set = get_parent();
	obj_qstats_btn = my_set.get_node("obj_qstats");
	reaction = my_set.get_node("obj_reaction");
	
	var tmp_icon = my_set.get_node("obj_icon");
	tmp_icon.texture = obj_ram.icons[char.index];
	tmp_icon.visible = true;
	
	
	
	var set_qstats = load("res://Battle/qstats/set_qstats.tscn");
	spr_box2 = load("res://spr/menu/box/menu_btl_cmds2.png");
	
	spr_qstats = load("res://spr/menu/qstats.png");
	spr_qstats2 = load("res://spr/menu/qstats_pressed.png");
	obj_qstats = set_qstats.instantiate();
	obj_btl.add_child(obj_qstats);
	obj_qstats.close();
	
	obj_qstats.position.x = 64;
	obj_qstats.position.y = 64;
	
	var reacting = obj_btl.reacting;
	var turn = obj_btl.turn;
	var use_spr2 = false;
	var tmp_x = 0;
	
	if (turn == 1):
		use_spr2 = true;
		tmp_x = 128;
	
	if (obj_btl.reacting):
		reaction.visible = true;
		reaction.play();
		if (turn == 0):
			use_spr2 = true;
		else:
			use_spr2 = true;
		tmp_x = 64;
		
	my_set.position.x = tmp_x;
	if (use_spr2):
		my_set.get_node("obj_btl_cmds_box").texture = spr_box2;
		spr_qstats = load("res://spr/menu/qstats2.png");
		spr_qstats2 = load("res://spr/menu/qstats2_pressed.png");
	my_set.position.y = 128;
	
	obj_qstats_btn.texture = spr_qstats;
	
	
	var tmp_box = my_set.get_node("obj_btl_cmds_box");
			
			
	cursor_r = get_node("../obj_btl_cmds_cursor_r");
	cursor_l = get_node("../obj_btl_cmds_cursor_l");
	
	
	set_label = load("res://UI&Menues/set_label.tscn");
	lbl = set_label.instantiate();
	obj_text = get_node("../obj_btl_cmds_text");
	obj_text.add_child(lbl);
	
	#lbl.ini(9, 158, "");
	lbl.ini(16, 16+32, "");
	lbl.change_font("nmb");
	
	if (obj_ram.freeplay):
		var tmp_index = obj_ram.input_player;
		obj_lbl_p = my_set.get_node("obj_lbl_p");
		if (tmp_index > 0):
			obj_lbl_p.sprite_frames = spr_lbl_p2;
		obj_lbl_p.visible = true;
		obj_qstats.visible = false;
	
	item_count = 1;
	
func update_cursor():
	cursor_r.visible = false;
	cursor_l.visible = false;
	if (page_count > 0):
		if (page < page_count):
			cursor_r.visible = true;
		if (page > 0):
			cursor_l.visible = true;

		
func cursor_img_index(arg_node, arg_index):
	arg_node.region_rect.position.x = arg_index * 8;
	
func ini(arg_last_pos, arg_data):
	#Initialization!
	ani_frame = 0;
	
	var i = 0;
	page_count = -1;
	pages = [];
	pos = 0x0;
	last_pos = arg_last_pos;
	var tmp_txt = "";
	for s in arg_data:
		tmp_txt += s.to_upper() + "##";
		item_count += 1;
		i += 1;
		if (i == 3):
			pages.append(tmp_txt);
			page_count += 1;
			tmp_txt = "";
			i = 0;
	if (i > 0):
		pages.append(tmp_txt);
		page_count += 1;
		tmp_txt = "";
		i = 0;
	page = 0;
	update_text();
	
func update_text():
	#Update the text displayed in the menu, based on page.
	#Also, update the visibility of the page cursors.
	update_cursor();
	lbl.draw(pages[page]);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (obj_ram.freeplay):
		if (lbl_count < lbl_wait):
			lbl_count += 1;
		else:
			if (obj_lbl_p.frame == 0):
				obj_lbl_p.frame = 1;
			else:
				obj_lbl_p.frame = 0;
			lbl_count = 0;
	if (stats_open):
		if (obj_ram.keyboard_check("vk_shift")):
			obj_qstats.close();
			obj_qstats_btn.texture = spr_qstats;
			stats_open = false;
	else:
		#Animation handler for cursor.
		#Switches between visible, not visible
		#Also handles anis for the two little page cursors, since why not?
		if (ani_count < ani_wait):
			ani_count += 1;
		else:
			if (ani_frame == 0):
				ani_frame = 1;
			else:
				ani_frame = 0;
			self.visible = not self.visible;
			cursor_img_index(cursor_r, ani_frame);
			cursor_img_index(cursor_l, ani_frame);
			ani_count = 0;
			
		#Get player input
		#Up/down move cursor as expected
		#Left/right change the page (when more than 3 moves)
		if (obj_ram.keyboard_check("vk_down")):
			update = true;
			if (pos < last_pos):
				pos += 1;
			else:
				pos = 0x0;
			obj_ram.play_sound("btl_cmds_blip");
		elif (obj_ram.keyboard_check("vk_up")):
			update = true;
			if (pos > 0):
				pos += -1;
			else:
				pos = last_pos;
			obj_ram.play_sound("btl_cmds_blip");
		elif (obj_ram.keyboard_check("vk_right")):
			update = true;
			if (page_count > 0):
				if (page < page_count):
					page += 1;
				else:
					page = 0;
			pos = 0;
			obj_ram.play_sound("btl_cmds_blip");
		elif (obj_ram.keyboard_check("vk_left")):
			update = true;
			if (page_count > 0):
				if (page > 0):
					page += -1;
				else:
					page = page_count;
			pos = 0;
			obj_ram.play_sound("btl_cmds_blip");
		elif not (obj_ram.freeplay) and (obj_ram.keyboard_check("vk_z")):
			var tmp_txt;
			obj_ram.play_sound("blip");
			tmp_txt =   "STRENGTH: " + str(char.Strength);
			tmp_txt += "##AGILITY:  " + str(char.Agility);
			tmp_txt += "##REFLEXES: " + str(char.Reflexes);
			obj_qstats.open(tmp_txt);
			obj_qstats_btn.texture = spr_qstats2;
			stats_open = true;
		elif (obj_ram.keyboard_check("vk_space")):
			#Give the current position to obj_ram, so other
			#nodes can do stuff with it.
			#Namely, obj_btl can use it to get the player's
			#chosen move.
			#If the index < item_count, then the selected move is blank
			#and don't accept it.
			var index = (page * 3) + pos;
			if (index < item_count-1):
				obj_ram.menu_index = index;
				obj_ram.menu_done = true;
				obj_qstats.queue_free();
				obj_ram.scr_btl_cmds_close();
				
		if (update):
			#Update where the cursor should be drawn.
			#Also, call update for the menu's text.
			update_text();
			self.position.y = start_y + (16*pos);
			ani_count = 0;
			self.visible = true;
			update = false;
