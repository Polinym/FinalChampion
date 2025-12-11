extends Node2D
var set_label = load("res://UI&Menues/set_label.tscn");
var set_hand = load("res://Multiplayer/set_hand.tscn");
var set_token = load("res://Multiplayer/set_token.tscn");
var set_ready = load("res://Multiplayer/set_ready.tscn");

var spr_actors = [];

var actors = [];
var lbl_names = [];

var name_pos = [[56, 200], [144, 200]];

var names = ["Owen", "Zakton", "Rex", "Chongel", "Kinobor", "Mac", "Kempf", "Caped Man"];

var ani_count = 0; var ani_wait = 20;
var actor_state = 0;

var icons = [];

var hand_p1;
var hand_p2;
var hands = [];

var chosen = [-1, -1, -1, -1, -1, -1, -1, -1];

var hands_over = [-1, -1, -1, -1, -1, -1, -1, -1];

var readying = false;
var ready_count = 0;

var obj_ready;
var done = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	obj_ram.stop_bgm();
	obj_ram.play_bgm("bgm_ChooseYourFighter");
	var lbl_title = set_label.instantiate(); add_child(lbl_title);
	lbl_title.change_font("title");
	lbl_title.ini(8, 8, "FREEPLAY MODE");
	
	for i in range(2):
		var tmp_lbl = set_label.instantiate(); add_child(tmp_lbl);
		tmp_lbl.change_font("kip2");
		tmp_lbl.ini(name_pos[i][0], name_pos[i][1], "Name " + str(i));
		lbl_names.append(tmp_lbl);
	
	for i in range(8):
		icons.append([get_node("obj_icon_" + str(i)), false]);
	
	actors.append(get_node("obj_actor_p1"));
	actors.append(get_node("obj_actor_p2"));
	
	actors[0].flip_h = true;
	
	spr_actors.append(load("res://spr/btl/multi/ani_multi_owen.tres"));
	spr_actors.append(load("res://spr/btl/multi/ani_multi_zakton.tres"));
	spr_actors.append(load("res://spr/btl/multi/ani_multi_rex.tres"));
	spr_actors.append(load("res://spr/btl/multi/ani_multi_chongel.tres"));
	spr_actors.append(load("res://spr/btl/multi/ani_multi_kintobor.tres"));
	spr_actors.append(load("res://spr/btl/multi/ani_multi_zac.tres"));
	spr_actors.append(load("res://spr/btl/multi/ani_multi_kempf.tres"));
	spr_actors.append(load("res://spr/btl/multi/ani_multi_seth.tres"));
	
	hand_p1 = set_hand.instantiate(); add_child(hand_p1);
	hand_p2 = set_hand.instantiate(); add_child(hand_p2);
	hands = [hand_p1, hand_p2];
	hand_p1.position = Vector2(112, 8);
	hand_p2.position = Vector2(160, 8);
	#(118, 10)
	#(168, 10)
	
	for hand in hands:
		hand.icons = icons;
	hand_p2.make_p2();

func check_hands():
	hands_over = [-1, -1, -1, -1, -1, -1, -1, -1];
	for i in range(2):
		var tmp_hand = hands[i];
		if not (readying):
			if (tmp_hand.state == 0):
				if (tmp_hand.check_deslect()):
					obj_ram.play_sound("dodge");
					tmp_hand.left_token.queue_free();
					tmp_hand.get_node("obj_token").visible = true;
					tmp_hand.state = 1;
					var last_index = tmp_hand.char_index;
					chosen[last_index] = -1;
					tmp_hand.char_index = -1;
					icons[last_index][1] = false;
					ready_count += -1;
	
	
	for i in range(8):
		var tmp_icon = icons[i][0];
		var tmp_pos1 = tmp_icon.position;
		tmp_pos1 = Vector2(tmp_pos1.x+16, tmp_pos1.y+16);
		if (hands_over[i] < 0):
			var i2 = 0;
			for hand in hands:
				if (hand.state != 0):
					var tmp_pos2 = hand.position;
					tmp_pos2 = Vector2(tmp_pos2.x+12, tmp_pos2.y+12);
					
					if (tmp_pos1.distance_to(tmp_pos2) < 16):
						if (hand.check_select()):
							obj_ram.play_sound2("pick_fighter");
							var tmp_token = set_token.instantiate(); add_child(tmp_token);
							icons[i][1] = true;
							hand.left_token = tmp_token;
							hand.state = 0;
							var tmp_token2 = hand.get_node("obj_token");
							tmp_token2.visible = false;
							tmp_token.get_node("obj_sprite").texture = tmp_token2.texture;
							var tmp_pos = hand.position;
							tmp_token.position = Vector2(tmp_pos.x-4, tmp_pos.y-4);
							hand.char_index = i;
							chosen[i] = i2;
							ready_count += 1;
							if (ready_count > 1):
								obj_ready = set_ready.instantiate();
								add_child(obj_ready);
								readying = true;
						else:
							hands_over[i] = hand.index;
						break;
				i2 += 1;
					
						
	for lbl in lbl_names:
		lbl.draw("");
	for actor in actors:
		actor.modulate[3] = 0;
	for i in range(8):
		var tmp_icon = icons[i][0];
		if icons[i][1]:
			tmp_icon.frame = 2;
			var hand_i = chosen[i];
			var tmp_actor = actors[hand_i];
			tmp_actor.sprite_frames = spr_actors[i];
			tmp_actor.modulate[3] = 1;
			lbl_names[hand_i].draw(names[i]);
		else:
			var tmp_hand = hands_over[i];
			if (tmp_hand != -1):
				tmp_icon.frame = 1;
				lbl_names[tmp_hand].draw(names[i]);
				var tmp_actor = actors[tmp_hand];
				tmp_actor.sprite_frames = spr_actors[i];
				tmp_actor.modulate[3] = 0.5;
				
			else:
				tmp_icon.frame = 0;
	if (readying):
		if (obj_ready.done):
			obj_ready.done = false;
			obj_ram.freeplay = true;
			for hand in hands:
				hand.visible = false;
		if (obj_ready.back):
			readying = false;
			ready_count = 0;
			for hand in hands:
				hand.left_token.queue_free();
				hand.get_node("obj_token").visible = true;
				hand.state = 1;
				var last_index = hand.char_index;
				chosen[last_index] = -1;
				hand.char_index = -1;
				icons[last_index][1] = false;
			obj_ram.play_sound("menu_punch_back");
			obj_ready.state = 2;

func actor_ani():
	if (ani_count < ani_wait):
		ani_count += 1;
	else:
		ani_count = 0;
		for actor in actors:
			if (actor.frame == 0):
				actor.frame = 1;
			else:
				actor.frame = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	actor_ani();
	if (not done) and (obj_ram.keyboard_check("vk_shift") and (ready_count < 1)):
		for hand in hands:
			hand.queue_free();
		for icon in icons:
			icon[0].frame = 0;
		obj_ram.freeplay = false;
		obj_ram.scene_warp(obj_ram.scene_title);
		done = true;
	if not done:
		check_hands();
