extends Node2D
var obj_sprite;

var ani_count = 0; var ani_wait = 15;
var animating = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	obj_sprite = get_node("obj_sprite");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (ani_count < ani_wait):
		ani_count += 1;
	else:
		ani_count = 0;
		var frame = obj_sprite.frame;
		if (frame == 0):
			frame = 1;
		else:
			frame = 0;
		obj_sprite.frame = frame;
