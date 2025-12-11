extends Node2D
var state = 0;
var ani_count = 0; var ani_wait = 3;

var obj_flare;
var obj_prompt;

var back = false;
var done = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	obj_flare = get_node("obj_flare");
	obj_prompt = get_node("obj_prompt");
	obj_ram.play_sound("menu_punch");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		0:
			var x = obj_flare.position.x;
			if (x < 0):
				x += 32;
			else:
				obj_prompt.visible = true;
				state = 1;
			obj_flare.position.x = x;
		1:
			if (ani_count < ani_wait):
				ani_count += 1;
			else:
				var frame = obj_prompt.frame;
				if (frame < 3):
					frame += 1;
				else:
					frame = 0;
				obj_prompt.frame = frame;
				ani_count = 0;
			if (obj_ram.keyboard_check("vk_shift")):
				state = 255;
				back = true;
			elif (obj_ram.keyboard_check("vk_x")):
				obj_ram.in_btl = true;
				obj_ram.play_sound3("crowd");
				obj_ram.play_sound2("start_multi");
				obj_ram.slow_warp = true;
				obj_ram.stop_bgm();
				obj_ram.scene_warp(obj_ram.scene_btl);
				
				obj_ram.ready_freeplay();
				
				done = true;
				state = 3;
		2:
			obj_prompt.visible = false;
			var x = obj_flare.position.x;
			if (x > -256):
				x += -64;
			else:
				queue_free();
			obj_flare.position.x = x;
		3:
			obj_prompt.visible = false;
			var x = obj_flare.position.x;
			if (x < 768):
				x += 32;
			obj_flare.position.x = x;
