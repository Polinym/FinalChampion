extends Node2D
var state = 0;
var spr_logo2 = load("res://Bootup/logo_2.png");

var obj_logo;
var obj_cover;

var image_alpha = 1;
var ani_count = 0;
var ani_wait = 45;
var second = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	obj_logo = get_node("obj_logo");
	obj_cover = get_node("obj_cover");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	image_alpha = obj_cover.modulate[3];
	match state:
		0:
			if (image_alpha > 0):
				image_alpha += -0.02;
			else:
				state += 1;
		1:
			if (ani_count < ani_wait):
				ani_count += 1;
			else:
				ani_count = 0;
				state += 1;
		2:
			if (image_alpha < 1):
				image_alpha += 0.02;
			else:
				if second:
					obj_ram.scene_warp(obj_ram.scene_title);
					state = 3;
				else:
					obj_logo.texture = spr_logo2;
					second = true;
					state = 0;
	obj_cover.modulate[3] = image_alpha;
