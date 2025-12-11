extends AnimatedSprite2D

var obj_blink;
var blink_count = 0; var blink_wait = 40;
var blink = false;

var x = self.position.x;
var y = self.position.y;

var state = "state_free";

var obj_shadow;
var can_repos = true;

var ani = "";
var sub_ani = "";
var ani_count = 0;  var ani_wait = 1;
var ani_frame = 0;

var ani2_count = 0; var ani2_wait = 1;
var ani2_frame = 0;

var bounce_wait = 19;
var sweat_min = 150;
var sweat_max = 300;

var idle_base_frame = 0;
var idle_sweat_frame = 10;

var idle_down_frame = 12;
var idle_down_sweat_frame = 13;

var idle = idle_base_frame;
var idle_sweat = idle_sweat_frame;

var image_blend;
var image_alpha;

var player;
var other_actor;
var index = 0;
var can_move = true;
var can_sweat = true;
var can_blink = true;

var walking = false;
var walk_count = 0; var walk_wait = 5;
var step_count = 0; var step_wait = 1;

var image_white = 255;

var ani_move_acc = 0.3;
var ani_move_speed = 0;
var ani_move_dir = "right";

var ani_done = false;

var check_ani_updates = true;
var wiggle = false;

var offset_index = [1, -1];

func update_ani_forward():
	match (index):
		0:
			ani_move_dir = "right";
		1:
			ani_move_dir = "left";
			
func update_ani_backward():
	match (index):
		0:
			ani_move_dir = "left";
		1:
			ani_move_dir = "right";


# Called when the node enters the scene tree for the first time.
func _ready():
	obj_shadow = get_node("obj_shadow");
	obj_blink = get_node("obj_blink");
	player = obj_ram.player;
	other_actor = null;
	change_ani("state_free");
	
	
func blink_ani():
	if (blink_count < blink_wait):
		blink_count += 1;
	else:
		blink_count = 0;
		if (blink):
			obj_blink.visible = false;
			blink_wait = obj_ram.scr_rng(85, 165);
			obj_ram.blink = false;
			blink = false;
		else:
			obj_blink.visible = true;
			blink_wait = 15;
			obj_ram.blink = true;
			blink = true;
			
func slide_ani():
	var x = self.position.x;
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
	self.position.x = x;
	
	
func refresh():
	change_ani(state);
	var refresh_pos = false;
	match state:
		"state_grab":
			refresh_pos = true;
		"state_grabbed":
			refresh_pos = true;
		"state_grapple":
			refresh_pos = true;
		"state_grappled":
			refresh_pos = true;
	if (refresh_pos):
		check_walking();
		self.position.x = x;
			
			
var lock_states = ["state_grabbed", "state_grapple", "state_grab", "state_grappled"];

func change_ani(arg_ani):
	image_alpha = 1;
	ani_count = 0;
	ani2_count = 0;
	ani = arg_ani;
	sub_ani = "normal";
	check_ani_updates = true;
	wiggle = false;
	self.offset.x = 0;
	modulate[3] = 1;
	match arg_ani:
		"state_free":
			state = "state_free";
			ani_frame = 0;
			ani_wait = bounce_wait;
			ani2_wait = obj_ram.scr_rng(sweat_min, sweat_max);
			frame = 0;
		"punch":
			ani_wait = 8;
			x += -1;
			frame = 2;
			sub_ani = "ready";
		"gethit":
			if (state in lock_states):
				ani_move_acc = 0.6;
				ani_move_speed = 1;
			else:
				ani_move_acc = 0.3;
				ani_move_speed = 3;
			ani2_wait = 1;
			check_ani_updates = false;
			wiggle = true;
			ani_frame = 0;
			update_ani_backward();
			match (other_actor.ani):
				"punch":
					obj_ram.play_sound("punch");
				"kick":
					obj_ram.play_sound("kick");
			frame = 4;
		"dodge":
			ani_move_acc = 0.3;
			ani_move_speed = 2;
			ani_wait = 1;
			check_ani_updates = false;
			update_ani_backward();
			if (index == 1):
				ani2_wait = 20;
				frame = 5;
			else:
				frame = 6;
			obj_ram.play_sound("dodge");
		"grab":
			x += -1;
			ani_wait = 15;
			sub_ani = "ready";
			frame = 7;
		"grapple":
			x += -1;
			ani_wait = 15;
			sub_ani = "ready";
			frame = 8;
		"state_grab":
			state = "state_grab";
			x += 1;
			frame = 18;
		"state_grabbed":
			state = "state_grabbed";
			ani_frame = 0;
			ani_wait = 1;
			ani2_wait = 15;
			frame = 22;
		"state_grapple":
			state = "state_grapple";
			frame = 19;
		"state_grappled":
			state = "state_grappled";
			ani_frame = 0;
			ani_wait = bounce_wait;
			ani2_wait = obj_ram.scr_rng(sweat_min, sweat_max);
			frame = 12;
		"kick":
			x += -1;
			ani_wait = 15;
			sub_ani = "ready";
			frame = 20;
		"center":
			ani_wait = bounce_wait*2;
			#ani2_wait = obj_ram.scr_rng(sweat_min, sweat_max);
			frame = 0;
		"victory":
			if (index == 0):
				flip_h = true;
			ani_wait = 20;
			frame = 16;
		"dead":
			obj_ram.play_sound("finisher");
			obj_ram.play_sound2("death");
			offset.y += 8;
			frame = 15;
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	image_blend = self.modulate;
	var image_alpha = image_blend[3];
	slide_ani();
	x = self.position.x;
	y = self.position.y;
					
	var ani_update = false;
	var ani2_update = false;
	if (check_ani_updates):
		if (ani2_count < ani2_wait):
			ani2_count += 1;
			if (ani_count < ani_wait):
				ani_count += 1;
			else:
				ani_count = 0;
				ani_update = true;
		else:
			ani2_count = 0;
			ani2_update = true;
	
	can_sweat = true;
	can_blink = false;
	match ani:
		"state_free":
			match sub_ani:
				"normal":
					if (can_repos) and (check_walking()):
						do_walking();
					else:
						if (ani2_update):
							if (can_sweat):
								ani_frame = 0;
								ani_wait = 15;
								frame = 10;
								sub_ani = "sweat";
						elif (ani_update):
							if (frame == 0):
								frame = 1;
							else:
								frame = 0;
				"sweat":
					if (ani_update):
						match ani_frame:
							0:
								frame = 11;
								ani_wait = 20;
								if (index == 1):
									ani_wait = 100;
								ani_frame = 1;
							1:
								frame = 0;
								ani_wait = bounce_wait;
								ani2_count = 0;
								ani2_wait = obj_ram.scr_rng(sweat_min, sweat_max);
								ani_frame = 0;
								sub_ani = "normal";
		"punch":
			match sub_ani:
				"ready":
					if (ani_update):
						ani_wait = 30;
						sub_ani = "throw_punch";
						ani_move_acc = 0.6;
						ani_move_speed = 2;
						update_ani_forward();
						frame = 3;
						obj_ram.play_sound("throw");
		"gethit":
			can_blink = false;
			for i in range(1, 2):
				image_blend[i] = ani_count;
			if (ani_count < 1):
				ani_count += 0.05;
				
			if (wiggle):
				if (ani2_count < ani2_wait):
					ani2_count += 1;
				else:
					if (ani_frame != 1):
						ani_frame = 1;
					else:
						ani_frame = -1;
					self.offset.x = ani_frame;
					ani2_count = 0;
					if (ani2_wait < 10):
						ani2_wait += 2;
					else:
						wiggle = false;
						self.offset.x = 0;
			frame = 4;
		"dodge":
			can_blink = false;
			if (image_alpha == 1):
				image_alpha = ani_count;
				if (ani_count < 1):
					ani_count += 0.05;
			else:
				image_alpha = 1;
			if (index == 1):
				if (ani2_count < ani2_wait):
					ani2_count += 1;
				else:
					if (frame == 6):
						frame = 5;
					else:
						frame = 6;
					ani2_count = 0;
			else:
				frame = 6;
		"grab":
			match sub_ani:
				"ready":
					if (ani_update):
						x += 3;
						frame = 18;
						sub_ani = "grab";
		"grapple":
			match sub_ani:
				"ready":
					if (ani_update):
						x += 3;
						frame = 7;
						sub_ani = "grapple";
		"state_grab":
			frame = 18;
			if check_walking():
				match (index):
					0:
						x += 2;
					1:
						x += -2;
		"state_grabbed":
			if (ani2_update):
				if (frame == 22):
					frame = 23;
				else:
					frame = 22;
			if (ani_update):
				if (ani_frame == 0):
					self.offset.x = offset_index[index];
					ani_frame = 1;
				else:
					self.offset.x = 0;
					ani_frame = 0;
			if check_walking():
				match (index):
					0:
						x += 2;
					1:
						x += -2;
		"kick":
			match sub_ani:
				"ready":
					if (ani_update):
						ani_wait = 30;
						sub_ani = "throw_kick";
						ani_move_acc = 0.5;
						ani_move_speed = 3;
						update_ani_forward();
						frame = 21;
						obj_ram.play_sound("throw");
		"state_grapple":
			frame = 19;
		"state_grappled":
			match sub_ani:
				"normal":
					if (check_walking()):
						do_walking();
					else:
						if (ani2_update):
							if (can_sweat):
								ani_frame = 0;
								ani_wait = 15;
								frame = 13;
								sub_ani = "sweat";
						elif (ani_update):
							frame = 12;
				"sweat":
					if (ani_update):
						match ani_frame:
							0:
								frame = 14;
								ani_wait = 20;
								if (index == 1):
									ani_wait = 100;
								ani_frame = 1;
							1:
								frame = 12;
								ani_wait = bounce_wait;
								ani2_count = 0;
								ani2_wait = obj_ram.scr_rng(sweat_min, sweat_max);
								ani_frame = 0;
								sub_ani = "normal";
		"center":
			if (ani_update):
				if (frame == 0):
					frame = 1;
				else:
					frame = 0;
			if (x < 112):
				flip_h = false;
				manual_walk("right");
			elif (x > 112):
				flip_h = true;
				manual_walk("left");
			else:
				flip_h = false;
				ani_done = true;
				change_ani("victory");
		"victory":
			if (ani_update):
				if (frame == 16):
					frame = 17;
				else:
					frame = 16;
		"dead":
			frame = 15;
					
						
							
	blink_ani();
	obj_blink.frame = frame;
	self.position.x = x;
	self.position.y = y;
	image_blend[3] = image_alpha;
	self.modulate = image_blend;
					


func check_walking():
	var other_x = other_actor.position.x;
	var result = false;
	var tmp_dest;
	match index:
		0:
			tmp_dest = other_x-16;
			result = (can_move) and (x < tmp_dest);
			while (x > tmp_dest):
				x += -1;
		1:
			tmp_dest = other_x+16;
			result = (can_move) and (x > tmp_dest);
			while (x < tmp_dest):
				x += 1;
	return result;
			
func do_walking():
	if (walk_count < walk_wait):
		walk_count += 1;
	else:
		walk_count = 0;
		if (frame == 0):
			frame = 1;
		else:
			frame = 0;
	if (step_count < step_wait):
		step_count += 1;
	else:
		step_count = 0;
		match index:
			0:
				x += 2;
			1:
				x += -2;
				
func manual_walk(arg_dir):
	if (walk_count < walk_wait):
		walk_count += 1;
	else:
		walk_count = 0;
		if (frame == 0):
			frame = 1;
		else:
			frame = 0;
	if (step_count < step_wait):
		step_count += 1;
	else:
		step_count = 0;
		match arg_dir:
			"right":
				x += 1;
			"left":
				x += -1;
