extends CharacterBody2D

var set_opts = load("res://Campaign/opts/set_opts.tscn");
var set_status = load("res://Campaign/status/set_status.tscn");

var obj_blink;
var obj_sprite;
var obj_shadow;
var obj_reflect;
var obj_camera;
var obj_screen;

var spr_reflect = load("res://spr/camp/ani_char_reflect.tres");
var spr_reflect_blink = load("res://spr/camp/ani_blink_reflect.tres");

var spr_base = load("res://spr/camp/ani_char.tres");
var spr_ani_putaway = load("res://spr/camp/ani_char_putaway.tres");
var spr_phone = load("res://spr/camp/ani_char_phone.tres");

var dir = 0;
var txt;

var ani_frame = 0;
var ani_count = 0; var ani_wait = 6;

var blink_count = 0; var blink_wait = 40;
var blink = false;

var walking = false;
var paused = false;
var state = "free";

var image_alpha = 0;
var image_color;
var fade_speed = 0.1;

var screen_alpha = 0;

var menuing = false;
var opts;
var status;

var ani2_count = 0; var ani2_wait = 10;
var ani2_frame = 0;

func update_alpha():
	image_color[3] = image_alpha;
	obj_sprite.modulate = image_color;
	obj_blink.modulate = image_color;
	obj_shadow.modulate = image_color;

# Called when the node enters the scene tree for the first time.
func _ready():
	obj_sprite = get_node("obj_sprite");
	obj_blink = obj_sprite.get_node("obj_blink");
	obj_shadow = get_node("obj_shadow");
	obj_reflect = get_node("obj_sprite_reflect");
	obj_camera = get_node("obj_camera");
	obj_screen = obj_camera.get_node("obj_screen");
	
	image_color = self.modulate;
	
	
	var tmp_dir = obj_ram.spawn_dir;
	dir = tmp_dir;
	obj_sprite.frame = tmp_dir*4;

func blink_ani():
	if (blink_count < blink_wait):
		blink_count += 1;
	else:
		blink_count = 0;
		if (blink):
			obj_blink.visible = false;
			obj_reflect.sprite_frames = spr_reflect;
			blink_wait = obj_ram.scr_rng(85, 165);
			obj_ram.blink = false;
			blink = false;
		else:
			obj_blink.visible = true;
			obj_reflect.sprite_frames = spr_reflect_blink;
			blink_wait = 15;
			obj_ram.blink = true;
			blink = true;
			
func walk_input():
	if not paused:
		if (obj_ram.keyboard_hold("vk_right")):
			dir = 1;
			walking = true;
			move_and_collide(Vector2(1, 0));
		elif (obj_ram.keyboard_hold("vk_left")):
			dir = 3;
			walking = true;
			move_and_collide(Vector2(-1, 0));
			
		if (obj_ram.keyboard_hold("vk_down")):
			dir = 0;
			walking = true;
			move_and_collide(Vector2(0, 1));
		elif (obj_ram.keyboard_hold("vk_up")):
			dir = 2;
			walking = true;
			move_and_collide(Vector2(0, -1));
			
func walk_ani():
	if (walking):
		if (ani_count < ani_wait):
			ani_count += 1;
		else:
			ani_count = 0;
			if (ani_frame < 3):
				ani_frame += 1;
			else:
				ani_frame = 0;
	else:
		ani_frame = 0;
	var tmp_frame = (dir * 4) + ani_frame
	obj_sprite.frame = tmp_frame;
	obj_blink.frame = obj_sprite.frame;
	obj_reflect.frame = tmp_frame;
	
func play_ani(arg_ani):
	ani2_count = 0;
	state = "ani_" + arg_ani;
	obj_blink.visible = false;
	blink = false;
	match arg_ani:
		"putaway":
			ani2_wait = 6;
			ani2_frame = 0;
			obj_sprite.frame = 0;
			obj_sprite.sprite_frames = spr_ani_putaway;
		"pullout":
			ani2_wait = 6;
			ani2_frame = 5;
			obj_sprite.frame = 0;
			obj_sprite.sprite_frames = spr_ani_putaway;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		"free":
			if (screen_alpha > 0):
				screen_alpha += -0.1;
			walking = false;
			if (obj_ram.keyboard_check("vk_shift")):
				opts = set_opts.instantiate();
				status = set_status.instantiate();
				obj_ram.scene.add_child(opts);
				obj_ram.scene.add_child(status);
				opts.status = status;
				state = "menu";
			blink_ani();
			walk_input();
			walk_ani();
		"leave":
			blink_ani();
			walking = true;
			match dir:
				0:
					self.position.y += 1;
				1:
					self.position.x += 1;
				2:
					self.position.y += -1;
				3:
					self.position.x += -1;
			walk_ani();
		"fade":
			if (image_alpha > 0):
				image_alpha += -fade_speed;
				update_alpha();
			else:
				state = "none";
		"menu":
			if (screen_alpha < 0.7):
				screen_alpha += 0.07;
			blink_ani();
		"phonelock":
			blink_ani();
			obj_sprite.frame = (dir * 4);
			if (obj_ram.keyboard_check("vk_space")):
				obj_ram.phone.queue_free();
				play_ani("pullout");
		"ani_putaway":
			if (ani2_count < ani2_wait):
				ani2_count += 1;
			else:
				ani2_count = 0;
				if (ani2_frame < 5):
					ani2_frame += 1;
				else:
					ani2_frame = 0;
					state = "free";
					obj_sprite.sprite_frames = spr_base;
			obj_sprite.frame = ani2_frame;
		"phonecall":
			blink_ani();
			if (obj_ram.text_done):
				obj_ram.text_done = false;
				obj_ram.play_sound("answer_phone");
				play_ani("putaway");
		"ani_pullout":
			if (ani2_count < ani2_wait):
				ani2_count += 1;
			else:
				ani2_count = 0;
				if (ani2_frame > 0):
					ani2_frame += -1;
				else:
					state = "phonecall";
					obj_ram.stop_sfx();
					obj_ram.play_sound2("answer_phone");
					obj_sprite.sprite_frames = spr_phone;
					obj_ram.scr_msg(obj_ram.trigger_msg);
			obj_sprite.frame = ani2_frame;
			
	obj_screen.modulate[3] = screen_alpha;
