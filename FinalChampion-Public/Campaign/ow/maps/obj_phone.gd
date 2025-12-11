extends AnimatedSprite2D
var ani_count = 0;
var ani_wait = 15;
var animating = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (animating):
		if (ani_count < ani_wait):
			ani_count += 1;
		else:
			ani_count = 0;
			if (frame == 0):
				frame = 1;
			else:
				frame = 0;
