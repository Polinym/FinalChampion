extends Node2D

var lbl_name;
var lbl_arts;
var lbl_hp; var lbl_hp_bar; var lbl_hp_nmb;
var lbl_mp; var lbl_mp_bar; var lbl_mp_nmb;
var lbl_str; var lbl_str_bar; var lbl_str_nmb;
var lbl_agi; var lbl_agi_bar; var lbl_agi_nmb;
var lbl_rfx; var lbl_rfx_bar; var lbl_rfx_nmb;
var stat_lbls = [];
var stat_lbls_nmb = [];
var lbl_free;

var font_bar;

var player;
var set_label;
var set_font;
var draw_x;
var draw_y;
var cursor;
var ani_count = 0;
var ani_wait = 20;
var cursor_y;
var cursor_x;
var cursor_pos = 0;
var cursor_last_pos = 5;
var done = false;
var stat_max = 80;
var stat_names;
var free_stats;
var stats = [];

var Stamina;
var Energy;
var Strength;
var Agility;
var Reflexes;

var limits = [ [30, 80], [30, 80], [0x1, 0x9], [0x1, 0x9], [0x1, 0x9] ];
var stat_mods = [5, 5, 1, 1, 1];

# Called when the node enters the scene tree for the first time.
func _ready():
	free_stats = 5;
	
	set_label = load("res://UI&Menues/set_label.tscn");
	set_font = load("res://UI&Menues/font/set_font.tscn");
	font_bar = load("res://spr/menu/font_bar.tres");

	player = obj_ram.player;
	
	#There's no dark side of the moon, really.
	#Matter of fact, it's all dark.
	
	player.MaxStamina = 40;
	player.MaxEnergy = 32;
	player.Stamina = player.MaxStamina;
	player.Energy = player.MaxEnergy;
	player.Strength = 6;
	player.Agility = 3;
	player.Reflexes = 4;
	
	
	
	cursor = get_node("obj_stats_cursor");
	
	Stamina = player.Stamina;
	Energy = player.Energy;
	Strength = player.Strength;
	Agility = player.Agility;
	Reflexes = player.Reflexes;
	stats = [Stamina, Energy, Strength, Agility, Reflexes];
	stat_names = ["STAMINA: ", "ENERGY: ", "STRENGTH: ", "AGILITY:  ", "REFLEXES: "];
	
	draw_x = 8; draw_y = 16;
	lbl_name = add_label(player.plr_name);
	lbl_name.change_font("monshou");
	
	#lbl_arts = add_label(player.Arts);
	lbl_free = add_label("FREE POINTS: " + str(free_stats));
	lbl_free.change_font("monshou");
	draw_y += 84;
	cursor_x = draw_x;
	cursor_y = draw_y;
	update_cursor();
	
	var tmp_x = draw_x + 80; var tmp_y;
	var tmp_x2 = tmp_x + 64;
	tmp_y = draw_y;
	lbl_hp = add_label("STAMINA: "); 
	lbl_hp_bar = add_bar(tmp_x, tmp_y, Stamina, stat_max);
	lbl_hp_nmb = add_label2(tmp_x2, tmp_y, str(Stamina));
	
	tmp_y = draw_y;
	lbl_mp = add_label("ENERGY: "); 
	lbl_mp_bar = add_bar(tmp_x, tmp_y, Energy, stat_max);
	lbl_mp_nmb = add_label2(tmp_x2, tmp_y, str(Energy));
	
	tmp_y = draw_y;
	lbl_str = add_label("STRENGTH: "); 
	lbl_str_bar = add_bar(tmp_x, tmp_y, Strength, stat_max);
	lbl_str_nmb = add_label2(tmp_x2, tmp_y, str(Strength));
	
	tmp_y = draw_y;
	lbl_agi = add_label("AGILITY:  "); 
	lbl_agi_bar = add_bar(tmp_x, tmp_y, Agility, stat_max);
	lbl_agi_nmb = add_label2(tmp_x2, tmp_y, str(Agility));
	
	tmp_y = draw_y;
	lbl_rfx = add_label("REFLEXES: "); 
	lbl_rfx_bar = add_bar(tmp_x, tmp_y, Reflexes, stat_max);
	lbl_rfx_nmb = add_label2(tmp_x2, tmp_y, str(Reflexes));
	
	stat_lbls_nmb = [lbl_hp_nmb, lbl_mp_nmb, lbl_str_nmb, lbl_agi_nmb, lbl_rfx_nmb];
	stat_lbls = [lbl_hp_bar, lbl_mp_bar, lbl_str_bar, lbl_agi_bar, lbl_rfx_bar];
	var lbl_okay = add_label("OKAY!");
	
func cursor_ani():
	if (ani_count < ani_wait):
		ani_count += 1;
	else:
		var tmp_frame = cursor.frame;
		if (tmp_frame == 0):
			tmp_frame = 1;
		else:
			tmp_frame = 0;
		cursor.frame = tmp_frame;
		ani_count = 0;

func update_cursor():
	cursor.frame = 0;
	ani_count = 0;
	cursor.position.x = cursor_x;
	cursor.position.y = cursor_y + (cursor_pos * 16);
	
func add_bar(arg_x, arg_y, arg_val, arg_val_max):
	var tmp_lbl = instance_create(set_font);
	tmp_lbl.ini(font_bar, 2, 4);
	tmp_lbl.pos(arg_x, arg_y);
	update_bar(tmp_lbl, arg_val, arg_val_max);
	return tmp_lbl;
	
func update_bar(arg_bar, arg_val, arg_val_max):
	var lst = [];
	for i in range(arg_val):
		lst.append(0);
	var rest = arg_val_max - arg_val;
	for i in range(rest):
		lst.append(1);
	lst.append(2);
	arg_bar.draw_raw(lst);

func add_label(arg_str):
	var tmp_lbl = instance_create(set_label);
	tmp_lbl.change_font("nmb");
	tmp_lbl.ini(draw_x, draw_y, arg_str);
	draw_y += 16;
	return tmp_lbl;
	
func add_label2(arg_x, arg_y, arg_str):
	var tmp_lbl = instance_create(set_label);
	tmp_lbl.ini(arg_x, arg_y, arg_str);
	return tmp_lbl;
	
func instance_create(arg_res):
	var tmp_inst = arg_res.instantiate();
	add_child(tmp_inst);
	return tmp_inst;
	
func stat_modify(arg_amt):
	var tmp_pos = cursor_pos;
	var tmp_limits = limits[tmp_pos];
	var stat = stats[tmp_pos];
	var can = ( stat < tmp_limits[1] );
	if (arg_amt < 0):
		can = ( stat > tmp_limits[0] );
	if (can):
		if (arg_amt < 0):
			free_stats += 1;
		else:
			if (free_stats < 1):
				return false;
			free_stats += -1;
		stat += arg_amt;
		stats[tmp_pos] = stat;
		update_display();
			
func update_display():
	for i in range(5):
		var tmp_stat = stats[i];
		update_bar(stat_lbls[i], tmp_stat, stat_max);
		stat_lbls_nmb[i].draw(str(tmp_stat));
		
	lbl_free.draw("FREE POINTS: " + str(free_stats));
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not done:
		cursor_ani();
		if (obj_ram.keyboard_check("vk_down")):
			if (cursor_pos < cursor_last_pos):
				cursor_pos += 1;
			else:
				cursor_pos = 0;
			update_cursor();
			# Make a noise
			obj_ram.play_sound("blip");
		elif (obj_ram.keyboard_check("vk_up")):
			if (cursor_pos > 0):
				cursor_pos += -1;
			else:
				cursor_pos = cursor_last_pos;
			update_cursor();
			# Make a noise
			obj_ram.play_sound("blip");
		elif (obj_ram.keyboard_check("vk_right") or obj_ram.keyboard_check("vk_space")):
			if (cursor_pos < 5):
				stat_modify(stat_mods[cursor_pos]);
				# Make a noise
				obj_ram.play_sound("blip");
			else:
				obj_ram.cutscene_warp("intro");
				# Make a noise
				obj_ram.stop_bgm();
				obj_ram.play_sound("blip_confirm");
		elif (obj_ram.keyboard_check("vk_left")):
			if (cursor_pos < 5):
				stat_modify(-stat_mods[cursor_pos]);
				# Make a noise
				obj_ram.play_sound("blip_exit");
		elif (obj_ram.keyboard_check("vk_shift")):
			obj_ram.scene_warp(obj_ram.scene_ma);
			# Make a noise
			obj_ram.play_sound("blip_exit");
			done = true;
		
