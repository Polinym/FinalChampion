extends AnimatedSprite2D
var ani_count = 0;
var ani_wait = 20;
var pos_x = 0;
var pos_y = 0;
var last_pos = 1;
var last_pos_x = 1;
var start_x = self.position.x;
var start_y = self.position.y;
var done = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not done:
		var do_update = false;
		
		
		if (ani_count < ani_wait):
			ani_count += 1;
		else:
			if (self.frame == 0):
				self.frame = 1;
			else:
				self.frame = 0;
			ani_count = 0;
				
				
		if (obj_ram.keyboard_check("vk_down")):
			if (pos_x < last_pos):
				pos_x += 1;
			else:
				pos_x = 0;
			do_update = true;
		elif (obj_ram.keyboard_check("vk_up")):
			if (pos_x > 0):
				pos_x += -1;
			else:
				pos_x = last_pos;
			do_update = true;
		elif (obj_ram.keyboard_check("vk_space")):
			match pos_x:
				0:
					obj_ram.goto_battle();
					done = true;
				1:
					obj_ram.scene_warp(obj_ram.scene_name);
					done = true;
		if (do_update):
			self.frame = 0;
			ani_count = 0;
			update();

func update():
	self.position.x = start_x + (pos_x * 7);
	self.position.y = start_y + (pos_y * 14);
