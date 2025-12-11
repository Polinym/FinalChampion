extends AnimatedSprite2D
var do_ani = true;
var ani_count = 0; var ani_wait = 19;
var do_ani2 = true;
var ani2_count = 0; var ani2_wait = 1;
var do_ani3 = true;
var ani3_count = 0; var ani3_wait = 1;
var ani = "walk";
var x; var y;

var ani_move_speed = 0;
var ani_move_acc = 0;
var ani_move_dir = "right";

var image_alpha = 1;

func slide_ani():
	if (ani_move_speed > 0):
		var tmp_speed = ceil(ani_move_speed);
		match (ani_move_dir):
			"right":
				while (true):
					if ((x + tmp_speed) > 208):
						tmp_speed += -1;
					else:
						break;
				x += tmp_speed;
			"left":
				while (true):
					if ((x - tmp_speed) < 24):
						tmp_speed += -1;
					else:
						break;
				x += -tmp_speed;
		ani_move_speed += -ani_move_acc;

# Called when the node enters the scene tree for the first time.
func _ready():
	change_ani("ini_walk");
	
func change_ani(arg_ani):
	ani = arg_ani;
	ani_count = 0;
	ani2_count = 0;
	ani3_count = 0;
	match arg_ani:
		"ini_walk":
			ani = "walk";
			ani2_wait = 5;
			ani3_wait = 100;
			frame = 0;
		"ready_punch":
			ani_wait = 8;
			frame = 2;
		"punch":
			ani_wait = 30;
			frame = 3;
		"after_punch":
			ani_wait = 6;
			frame = 2;
		"duck":
			frame = 12;
			ani_wait = 28;
		"dodge":
			#Dodge, duck, dip, dive, and dodge.
			frame = 6;
			ani_move_dir = "left";
			ani_move_acc = 0.3;
			ani_move_speed = 2;
			ani_wait = 1;
		"ready_kick":
			frame = 20;
			ani_wait = 10;
		"kick":
			scale.x = -1;
			frame = 21;
			ani_move_dir = "left";
			ani_move_acc = 0.3;
			ani_move_speed = 3;
			ani_wait = 1;
			ani2_wait = 40;
		"ready_punch2":
			ani_wait = 8;
			frame = 2;
		"punch2":
			ani_wait = 30;
			frame = 3;
		"walk2":
			ani_wait = 19;
			ani2_wait = 5;
			ani3_wait = 110;
			frame = 0;
		"pose":
			scale.x = 1;
			ani_wait = 15;
			ani2_wait = 120;
			frame = 16;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	x = position.x;
	y = position.y;
	image_alpha = modulate[3];
	var ani_update = false;
	var ani2_update = false;
	var ani3_update = false;
	
	slide_ani();
	
	if (do_ani):
		if (ani_count < ani_wait):
			ani_count += 1;
		else:
			ani_count = 0;
			ani_update = true;
	if (do_ani2):
		if (ani2_count < ani2_wait):
			ani2_count += 1;
		else:
			ani2_count = 0;
			ani2_update = true;
	if (do_ani3):
		if (ani3_count < ani3_wait):
			ani3_count += 1;
		else:
			ani3_count = 0;
			ani3_update = true;
			
			
	match ani:
		"walk":
			if (ani_update):
				if (frame == 0):
					frame = 1;
				else:
					frame = 0;
			if (ani2_update):
				x += 1;
			if (ani3_update):
				change_ani("ready_punch");
		"ready_punch":
			if (ani_update):
				change_ani("punch");
		"punch":
			if (ani_update):
				change_ani("after_punch");
		"after_punch":
			if (ani_update):
				change_ani("duck");
		"duck":
			if (ani_update):
				change_ani("dodge");
		"dodge":
			if (ani_update):
				change_ani("ready_kick");
		"ready_kick":
			if (ani_update):
				change_ani("kick");
		"kick":
			if (ani2_update):
				change_ani("ready_punch2");
		"ready_punch2":
			if (ani_update):
				change_ani("punch2");
		"punch2":
			if (ani_update):
				change_ani("walk2");
		"walk2":
			if (ani_update):
				if (frame == 0):
					frame = 1;
				else:
					frame = 0;
			if (ani2_update):
				x += 1;
			if (ani3_update):
				change_ani("pose");
		"pose":
			if (ani_update):
				if (frame == 16):
					frame = 17;
				else:
					frame = 16;
			if (ani2_update):
				frame = 0;
				change_ani("ini_walk");
				
	position.y = y;
	position.x = x;
	modulate[3] = image_alpha;
			


func dodge_blinky():
	if (image_alpha == 1):
		image_alpha = ani_count;
		if (ani_count < 1):
			ani_count += 0.05;
	else:
		image_alpha = 1;
