extends Node2D
var set_label;
var lbl_prompt;
var lbl_stats
var x; var y;
var stats = [];

var cursor_x;
var cursor_y;
var cursor;
var cursor_ani_count = 0;
var cursor_ani_wait = 20;
var pos = 0x0;
var last_pos = 6;

var points;
var max_points = 3;

var done = false;

var player;

# Called when the node enters the scene tree for the first time.
func _ready():
	player = obj_ram.player;
	
	set_label = load("res://UI&Menues/set_label.tscn");
	x = self.position.x; y = self.position.y;
	cursor = get_node("obj_cursor");
	cursor_x = cursor.position.x;
	cursor_y = cursor.position.y;
	stats.append(["Wrestling", 0]);
	stats.append(["Judo", 0]);
	stats.append(["BJJ", 0]);
	stats.append(["Boxing", 0]);
	stats.append(["Muay Thai", 0]);
	stats.append(["Kick Boxing", 0]);
	
	points = max_points;
	
	
	lbl_prompt = instance_create(set_label);
	lbl_prompt.change_font("monshou");
	lbl_prompt.ini(x + 48, y + 48, "");
	
	lbl_stats = instance_create(set_label);
	lbl_stats.change_font("monshou");
	lbl_stats.ini(x + 40, y + 74, "");
	update_display();

func fix_length(arg_str, arg_len):
	while (len(arg_str) < arg_len):
		arg_str += " ";
	return arg_str;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var okay = false;
	if not done:
		if (cursor_ani_count < cursor_ani_wait):
			cursor_ani_count += 1;
		else:
			cursor_ani_count = 0;
			cursor.visible = not cursor.visible;
		var moved = false;
		if (obj_ram.keyboard_check("vk_down")):
			if (pos < last_pos):
				pos += 1;
			else:
				pos = 0;
			obj_ram.play_sound("blip") 
			moved = true;
		elif (obj_ram.keyboard_check("vk_up")):
			if (pos > 0):
				pos += -1;
			else:
				pos = last_pos;
			moved = true;
		elif (obj_ram.keyboard_check("vk_right") or obj_ram.keyboard_check("vk_space")):
			if (pos < 6):
				if (points > 0):
					points += -1;
					stats[pos][1] += 1;
					update_display();
					obj_ram.play_sound("blip");
			else:
			#if (points < 3): OLD
				okay = true;
				obj_ram.play_sound("blip_confirm");
		elif (obj_ram.keyboard_check("vk_left") or obj_ram.keyboard_check("vk_shift")):
			if (pos < 6):
				if (points < max_points):
					if (stats[pos][1] > 0):
						stats[pos][1] += -1;
						points += 1;
						update_display();
						obj_ram.play_sound("blip_exit")
		elif (obj_ram.keyboard_check("vk_x")):
			if (points < 3):
				okay = true;
		if (okay):
			#tmp_gains tracks total gains from all Martial Arts base stats per level.
			var tmp_gains = [10, 10, 1, 1, 1];
			#For every Martial Art...
			for i in range(6):
				var tmp_set = stats[i];
				var tmp_name = tmp_set[0];
				var tmp_base = obj_ram.bases[tmp_name];
				var tmp_lvl = tmp_set[1];
				#For every level in that Martial Art... (could be 0)
				for i2 in range(tmp_lvl):
					#For every stat in that Martial Art's bases...
					for i3 in range(5):
						var tmp_gain = tmp_base[i3];
						if (i3 < 2):
							tmp_gain = ceil(tmp_gain * 0.1);
						#Add the base value to the net gains for that stat.
						tmp_gains[i3] += tmp_gain;
				#Then set the player's Martial Arts level.
				player.Arts[tmp_name] = tmp_lvl;
				
			#Finally, add the net gains to the player's stats.
			player.MaxStamina += tmp_gains[0];
			player.MaxEnergy += tmp_gains[1];
			player.Strength += tmp_gains[2];
			player.Agility += tmp_gains[3];
			player.Reflexes += tmp_gains[4];

			
			player.Stamina = player.MaxStamina;
			player.Energy = player.MaxEnergy;
			
			
			#stats.append(["Wrestling", 0]);
			#stats.append(["Judo", 0]);
			#stats.append(["BJJ", 0]);
			#stats.append(["Boxing", 0]);
			#stats.append(["Muay Thai", 0]);
			#stats.append(["Kick Boxing", 0]);
			player.Wrestling = 	stats[0][1];
			player.Judo = 		stats[1][1];
			player.BJJ = 		stats[2][1];
			player.Boxing = 	stats[3][1];
			player.MuaiThai = 	stats[4][1];
			player.Kickboxing = stats[5][1];
			
			# Push the player into the database
			# name, stamina, energy, strength, agility, 
			# reflexes, conditioning, state, attack_speed
			obj_ram.add_char(
				player.plr_name,
				player.MaxStamina,
				player.MaxEnergy,
				player.Strength,
				player.Agility,
				player.Reflexes,
				player.Wrestling, 
				player.MuaiThai, 
				player.Judo, 
				player.BJJ, 
				player.Boxing, 
				player.Kickboxing
			)
		
			# Go to next point of the campaign mode
			obj_ram.scene_warp(obj_ram.scene_stats); 
			done = true;
		elif (moved):
			update_cursor();
	
func update_display():
	var tmp_txt = "";
	lbl_prompt.draw("Points remaining: " + str(points));
	for tmp in stats:
		tmp_txt += fix_length(tmp[0], 12) + "   Lv. " + str(tmp[1]+1) + "#";
	tmp_txt += "Okay!";
	lbl_stats.draw(tmp_txt);
	
func update_cursor():
	cursor.visible = true;
	cursor.position.y = cursor_y + (16 * pos);

func instance_create(arg_res):
	var tmp_inst = arg_res.instantiate();
	add_child(tmp_inst);
	return tmp_inst;
