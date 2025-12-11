"""
Screen transition
"""

extends Sprite2D

var image_alpha;
var image_color;
var state = 0;
var fade_speed = 0.02;

# Called when the node enters the scene tree for the first time.
func _ready():
	if (obj_ram.slow_warp):
		fade_speed = 0.01;
		obj_ram.slow_warp = false;
	image_color = self.modulate;
	image_alpha = 0;
	update_alpha();
	
	
func update_alpha():
	image_color[3] = image_alpha;
	self.modulate = image_color;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		0:
			if (image_alpha < 1):
				image_alpha += fade_speed;
			else:
				obj_ram.scene_change();
				state = 1;
		1:
			if (image_alpha > 0):
				image_alpha += -fade_speed;
			else:
				queue_free();
	update_alpha();
