extends AnimatedSprite2D
var ani_count = 0;
var ani_wait = 20;
var pos = 0;
var last_pos = 1;
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
			if (pos < last_pos):
				pos += 1;
			else:
				pos = 0;
			obj_ram.play_sound("blip");
			do_update = true;
		elif (obj_ram.keyboard_check("vk_up")):
			if (pos > 0):
				pos += -1;
			else:
				pos = last_pos;
			obj_ram.play_sound("blip");
			do_update = true;
		elif (obj_ram.keyboard_check("vk_space")):
			obj_ram.play_sound("blip_confirm");
			match pos:
				0:
					obj_ram.scene_warp(obj_ram.scene_name);
					done = true;
				1:
					obj_ram.scene_warp(obj_ram.scene_multi);
					done = true;
		if (do_update):
			self.frame = 0;
			ani_count = 0;
			update();

func update():
	self.position.y = start_y + (pos * 16);
