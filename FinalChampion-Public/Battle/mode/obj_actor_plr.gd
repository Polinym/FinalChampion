extends AnimatedSprite2D

var ani = 0;
var ani_count = 0;
var ani_wait = 6;
var ani_state = 0;
var ani_type = "";
var frame_start = 0;
var frame_end = 0;
var loop = false;
var repeat_count = 0;
var end_ani = -1;
var state = "state_free";
var other_actor = null;
var move = false;
var index = 0;
var dest_x = 0;
var move_speed = 1;
var move_count = 0;
var move_wait = 5;

var ani_move_acc = 0.3;
var ani_move_speed = 0;
var ani_move_dir = "right";

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func update_ani_forward():
	match (index):
		0:
			ani_move_dir = "right";
		1:
			ani_move_dir = "left";

func refresh():
	change_ani(state);
			
func update_ani_backward():
	match (index):
		0:
			ani_move_dir = "left";
		1:
			ani_move_dir = "right";

func change_ani(arg_type):
	var frame = 0;
	frame_start = -1;
	end_ani = "none";
	loop = false;
	ani_count = 0;
	ani_type = arg_type;
	ani_move_speed = 0;
	ani_move_acc = 0;
	
	match ani_type:
		"state_free":
			frame_start = 0; frame_end = 3;
			ani = 0; ani_wait = 35;
			ani_count = obj_ram.scr_rng(0, 30);
			state = arg_type;
			loop = true;
		"walk":
			frame_start = 4; frame_end = 7;
			ani = 0; ani_wait = 5;
			loop = true;
		"guard":
			frame_start = 8; frame_end = 11;
			ani = 0; ani_wait = 0;
			loop = true;
		"dodge":
			frame_start = 8; frame_end = 11;
			ani = 0; ani_wait = 0;
			loop = true;
			ani_move_acc = 0.3;
			ani_move_speed = 2;
			update_ani_backward();
		"punch":
			frame_start = 12; frame_end = 15;
			ani = 0; ani_wait = 3;
		"gethit":
			frame_start = 16; frame_end = 19;
			ani = 0; ani_wait = 3;
			end_ani = state;
			ani_move_acc = 0.3;
			ani_move_speed = 4;
			update_ani_backward();
		"grab":
			frame_start = 20; frame_end = 23;
			ani = 0; ani_wait = 3;
			end_ani = state;
		"state_grab":
			frame_start = 24; frame_end = 27;
			ani = 0; ani_wait = 0;
			state = arg_type;
			loop = true;
		"state_grabbed":
			frame_start = 28; frame_end = 28;
			ani = 0; ani_wait = 7;
			state = arg_type;
			loop = true;
		"grapple":
			frame_start = 32; frame_end = 35;
			ani = 0; ani_wait = 3;
			end_ani = state;
		"state_grapple":
			frame_start = 36; frame_end = 39;
			ani = 0; ani_wait = 1;
			state = arg_type;
			loop = true;
		"state_grappled":
			frame_start = 40; frame_end = 43;
			ani = 0; ani_wait = 1;
			state = arg_type;
			loop = true;
			
	if (move):
		self.frame = 4;
		move_count = 0;
			
	if (frame_start != -1):
		frame = frame_start;
	self.frame = frame;

func update_pos():
	var x = self.position.x;
	var x0 = other_actor.position.x - 52;
	var x1 = other_actor.position.x + 52;
	move = false;
	match index:
		0:
			if (x < x0):
				dest_x = x0;
				move = true;
		1:
			if (x > x1):
				dest_x = x1;
				move = true;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (move):
		move_to_pos();
	else:
		animate();
	
func move_to_pos():
	var x = self.position.x;
	var tmp_frame = self.frame;
	if (x != dest_x):
		if (move_count < move_wait):
			move_count += 1;
		else:
			if (tmp_frame < 7):
				tmp_frame += 1;
			else:
				tmp_frame = 4;
			move_count = 0;
			
			
		if (x < dest_x):
			x += move_speed;
		elif (x > dest_x):
			x += -move_speed;
		else:
			move = false;
	else:
		move = false;
	self.position.x = x;
	self.frame = tmp_frame;
	
func animate():
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
	
	var frame = self.frame;
	match ani:
		0:
			if (ani_count < ani_wait):
				ani_count += 1;
			else:
				if (frame < frame_end):
					frame += 1;
				else:
					if (loop):
						if (ani_type == "state_free"):
							ani_count = obj_ram.scr_rng(0, 30);
						frame = frame_start;
					elif (repeat_count > 0):
						repeat_count += -1;
						frame = frame_start;
					#elif (end_ani != "none"):
					#	change_ani(end_ani);
					else:
						ani = 1;
				ani_count = 0;
		1:
			#Stop! You have violated the law! Your stolen goods are now forfeit.
			obj_ram.do_nothing();
	self.frame = frame;
