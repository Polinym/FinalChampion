extends Node2D
var set_label = load("res://UI&Menues/set_label.tscn");
var obj_box_enemy;

var opts = [];
var opt;
var pos = 0; var last_pos = 1;

var ani_count = 0; var ani_wait = 15;

var state = 0;


# Called when the node enters the scene tree for the first time.
func _ready():
	obj_ram.stop_bgm();
	obj_ram.play_bgm("bgm_LetsGoDoTheThing");
	opts.append(get_node("obj_opt_view"));
	opts.append(get_node("obj_opt_fight"));
	obj_box_enemy = get_node("obj_box_enemy");
	
	var tmp_player = obj_ram.player2;
	tmp_player.plr_name = "Zakton";
	tmp_player.MaxStamina = 35;
	tmp_player.MaxEnergy = 50;
	tmp_player.Strength = 2;
	tmp_player.Agility = 1;
	tmp_player.Kickboxing = 3;
	tmp_player.Reflexes = 3;
	
	var lbl_title = set_label.instantiate(); add_child(lbl_title);
	lbl_title.change_font("title");
	lbl_title.ini(56, 24, "MATCH 1: THE SNAKE");
	
	var lbl_view = set_label.instantiate(); add_child(lbl_view);
	lbl_view.change_font("kip2");
	lbl_view.ini(40, 160, "Opponent");
	
	var lbl_fight = set_label.instantiate(); add_child(lbl_fight);
	lbl_fight.change_font("kip_green");
	lbl_fight.ini(64, 192, "FIGHT!");
	
	var plr2 = obj_ram.player2;
	var lbl_name = set_label.instantiate(); obj_box_enemy.add_child(lbl_name);
	lbl_name.change_font("title");
	lbl_name.ini(48, 8, "Zakton Farshtey");
	
	var lbl_stamina = set_label.instantiate(); obj_box_enemy.add_child(lbl_stamina);
	lbl_stamina.change_font("title");
	lbl_stamina.ini(48, 24, "Stamina: " + str(plr2.Stamina));
	
	var lbl_stats = set_label.instantiate(); obj_box_enemy.add_child(lbl_stats);
	lbl_stats.change_font("title");
	var tmp_txt = "Strength: " + str(plr2.Strength);
	tmp_txt += "#Agility: " + str(plr2.Agility);
	tmp_txt += "#Reflexes: " + str(plr2.Reflexes);
	tmp_txt += "#Kickboxing: " + str(plr2.Kickboxing);
	
	lbl_stats.ini(88, 48, tmp_txt);


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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		0:
			opt = opts[pos];
			opt_blink_ani();
			if (obj_ram.keyboard_check("vk_down")):
				if (pos < last_pos):
					pos += 1;
					opt_blink_reset();
					obj_ram.play_sound("menu_blip");
			elif (obj_ram.keyboard_check("vk_up")):
				if (pos > 0):
					pos += -1;
					opt_blink_reset();
					obj_ram.play_sound("menu_blip");
			elif (obj_ram.keyboard_check("vk_space")):
				obj_ram.play_sound("menu_confirm");
				opt.frame = 2;
				match pos:
					0:
						state = 1;
						ani_count = 0;
						ani_wait = 32;
					1:
						state = 255;
						obj_ram.in_btl = true;
						obj_ram.stop_bgm();
						obj_ram.play_sound("crowd");
						obj_ram.slow_warp = true;
						obj_ram.scene_warp(obj_ram.scene_btl);
		1:
			if (ani_count < ani_wait):
				ani_count += 1;
				obj_box_enemy.position.x += -8;
			else:
				ani_count = 0;
				state = 2;
		2:
			if (obj_ram.keyboard_check("vk_space")) or (obj_ram.keyboard_check("vk_shift")):
				obj_ram.play_sound("menu_back");
				state = 3;
		3:
			if (ani_count < ani_wait):
				ani_count += 1;
				obj_box_enemy.position.x += 8;
			else:
				ani_count = 0;
				for opt in opts:
					opt.frame = 0;
				state = 0;
