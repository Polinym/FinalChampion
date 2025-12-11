extends CharacterBody2D

var txt = "";
var yes_txt = ""; var yes_prompt = "";;
var no_txt = ""; var no_prompt = "";
var dir = 0;
var talked_to = false;
var talking = false;
var face = true;

var ani_count = 0; var ani_wait = 20;
var ani_ini = true;

var obj_sprite;
var obj_talk;
var obj_reflect;
var obj_blink;
var obj_reflect_blink;

var spr_soldier;
var spr_caley;
var spr_woman;
var spr_zack;
var spr_cyborg;
var spr_recept;
var spr_aeris;
var spr_zakton;
var spr_man2;

var spr_blink;
var spr_blink2;
var spr_blink3;
var spr_blink4;

var spr_reflect_zakton;

var display_name = "";

var look_around = true;
var look_count = 0; var look_wait = obj_ram.scr_rng(90, 270);

var twoframe = false;
var twoframe_count = 0; var twoframe_wait = 18;

var track_distance = 42;

var blinky = true;
var blink_count = obj_ram.scr_rng(0, 30); var blink_wait = 40;
var blinking = false;
var ani = "none";

var ani_cuts_count = 0; var ani_cuts_wait = 5;
var ani_state = 0;

var custom_blink = false;

var player;
var show_eko = false;
var reflect_blink = false;

func blink_ani():
	if (blink_count < blink_wait):
		blink_count += 1;
	else:
		blink_count = 0;
		if (blinking):
			if (custom_blink):
				obj_sprite.frame = 0;
			else:
				if (reflect_blink):
					obj_reflect_blink.visible = false;
				obj_blink.visible = false;
			blink_wait = obj_ram.scr_rng(85, 165);
			blinking = false;
		else:
			if (custom_blink):
				obj_sprite.frame = 1;
			else:
				if (reflect_blink):
					obj_reflect_blink.visible = true;
				obj_blink.visible = true;
			blink_wait = 15;
			blinking = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	spr_soldier = load("res://spr/ow/npc/ani_soldier.tres");
	spr_caley = load("res://spr/ow/npc/ani_man.tres");
	spr_woman = load("res://spr/ow/npc/ani_woman.tres");
	spr_zack = load("res://spr/ow/npc/ani_zack.tres");
	spr_cyborg = load("res://spr/ow/npc/ani_cyborg.tres");
	spr_recept = load("res://spr/ow/npc/ani_reception2.tres");
	spr_aeris = load("res://spr/ow/npc/ani_aeris.tres");
	spr_zakton = load("res://spr/ow/npc/ani_zakton.tres");
	spr_man2 = load("res://spr/ow/npc/ani_arena_man.tres");
	
	spr_blink = load("res://spr/ow/npc/ani_npc_blink.tres");
	spr_blink2 = load("res://spr/ow/npc/ani_npc_blink2.tres");
	spr_blink3 = load("res://spr/ow/npc/ani_npc_blink3.tres");
	spr_blink4 = load("res://spr/ow/npc/ani_zakton_blink.tres");
	
	spr_reflect_zakton = load("res://spr/ow/npc/ani_zakton_reflect.tres");
	
	obj_sprite = get_node("obj_sprite");
	obj_talk = get_node("obj_talk");
	obj_reflect = get_node("obj_reflect");
	obj_blink = get_node("obj_blink");
	obj_reflect_blink = obj_reflect.get_node("obj_blink");
	
	player = obj_ram.ow_player;

func ini(arg_x, arg_y, arg_sprite, arg_txt, arg_name):
	self.position.x = arg_x;
	self.position.y = arg_y;
	display_name = arg_name;
	match arg_sprite:
		"soldier":
			obj_sprite.sprite_frames = spr_soldier;
			blinky = false;
		"caley":
			obj_sprite.sprite_frames = spr_caley;
		"woman":
			obj_sprite.sprite_frames = spr_woman;
		"zack":
			obj_sprite.sprite_frames = spr_zack;
			obj_blink.position.x += 8;
		"cyborg":
			obj_sprite.sprite_frames = spr_cyborg;
			blinky = false;
		"recept":
			obj_sprite.sprite_frames = spr_recept;
			custom_blink = true;
		"aeris":
			twoframe = true;
			face = false;
			blinky = true;
			obj_sprite.sprite_frames = spr_aeris;
			obj_blink.sprite_frames = spr_blink2;
		"zakton":
			obj_sprite.sprite_frames = spr_zakton;
			obj_blink.sprite_frames = spr_blink4;
			reflect_blink = true;
	txt = arg_txt;
	
func set_reflect(arg_name):
	obj_reflect.visible = true;
	match (arg_name):
		"zakton":
			obj_reflect.sprite_frames = spr_reflect_zakton;
			obj_reflect.position.y += 4;
			
	
func update_dir(arg_dir):
	match arg_dir:
		"down":
			obj_sprite.frame = 0;
		"right":
			obj_sprite.frame = 1;
		"up":
			obj_sprite.frame = 2;
		"left":
			obj_sprite.frame = 3;
	
func talk():
	talked_to = true;
	obj_talk.frame = 1;
	obj_ram.ow_player.paused = true;
	talking = true;
	obj_ram.speaker_name = display_name;
	obj_ram.yes_txt = yes_txt;
	obj_ram.no_txt = no_txt;
	obj_ram.yes_prompt = yes_prompt;
	obj_ram.no_prompt = no_prompt;
	obj_ram.show_eko = show_eko;
	obj_ram.scr_msg(txt);
	
func set_prompt(arg_yes, arg_yes_txt, arg_no, arg_no_txt):
	yes_txt = arg_yes_txt;
	yes_prompt = arg_yes;
	no_txt = arg_no_txt;
	no_prompt = arg_no;
	
func play_ani(arg_ani):
	ani_cuts_count = 0;
	ani_state = 0;
	match (arg_ani):
		"bow":
			obj_sprite.frame = 2;
			ani = "bow";
			ani_cuts_wait = 8;
		"stare_right":
			ani_cuts_wait = 60;
			obj_sprite.frame = 4;
			ani = "stare_right";

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match ani:
		"stare_right":
			if (ani_cuts_count < ani_cuts_wait):
				ani_cuts_count += 1;
			else:
				ani_cuts_count = 0;
				ani = "none";
		"bow":
			if (ani_cuts_count < ani_cuts_wait):
				ani_cuts_count += 1;
			else:
				ani_cuts_count = 0;
				match (ani_state):
					0:
						obj_sprite.frame = 3;
						ani_cuts_wait = 12;
					1:
						obj_sprite.frame = 2;
						ani_cuts_wait = 5;
					2:
						obj_sprite.frame = 0;
						ani = "none";
				ani_state += 1;
						
					
		_:
			if (twoframe):
				if (twoframe_count < twoframe_wait):
					twoframe_count += 1;
				else:
					if (obj_sprite.frame == 0):
						obj_sprite.frame = 1;
					else:
						obj_sprite.frame = 0;
					twoframe_count = 0;
			if (blinky):
				blink_ani();
			if (talking):
				obj_ram.do_nothing();
				if (obj_ram.text_done):
					talking = false;
					obj_ram.ow_player.paused = false;
					obj_ram.text_done = false;
			else:
				var pos = self.position;
				var plr_pos = obj_ram.ow_player.position;
				
				var x = pos.x+8; var y = pos.y+16;
				var targ_x = plr_pos.x+8; var targ_y = plr_pos.y+16;
				
				var tmp_dist = Vector2(x,y).distance_to(Vector2(targ_x, targ_y));
				if (tmp_dist < track_distance):
					if (y > targ_y):
						z_index = 2;
					else:
						z_index = 0;
					if (obj_ram.ow_player.state != "free"):
						obj_talk.visible = true;
						obj_talk.modulate[3] = 0.35;
					else:
						obj_talk.modulate[3] = 1;
						if (talked_to):
							obj_talk.visible = true;
						else:
							if (ani_ini):
								obj_talk.visible = true;
								ani_ini = false;
							if (ani_count < ani_wait):
								ani_count += 1;
							else:
								obj_talk.visible = not obj_talk.visible;
								ani_count = 0;
					
					if (face):
						if (abs(targ_x - x) > abs(targ_y - y)):
							if (x > targ_x):
								obj_sprite.frame = 3;
							else:
								obj_sprite.frame = 1;
						else:
							if (y > targ_y):
								obj_sprite.frame = 2;
							else:
								obj_sprite.frame = 0;
					if (obj_ram.keyboard_check("vk_space")):
						if (player.state == "free"):
							talk();
				else:
					ani_ini = true;
					if (look_around):
						if (look_count < look_wait):
							look_count += 1;
						else:
							obj_sprite.frame = obj_ram.scr_rng(0, 3);
							look_count = 0;
							look_wait = obj_ram.scr_rng(90, 270);
					obj_talk.visible = false;
	obj_reflect.frame = obj_sprite.frame;
	obj_reflect_blink.frame = obj_reflect.frame;
	if (twoframe):
		obj_blink.frame = 0;
	else:
		obj_blink.frame = obj_sprite.frame;
