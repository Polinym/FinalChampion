extends AnimatedSprite2D
var ani_count = 0;
var ani_wait = 25;
var state = 0;

var ani2_count = 0;
var ani2_wait = 100;

var player;

var txt;

# Called when the node enters the scene tree for the first time.
func _ready():
	txt = "/3[Mmm...| ah, did I oversleep?";
	txt += ">/ANo, I got plenty of time.";
	txt += ">/AThough I'd better get going.| I don't wanna miss my /gfirst match/w!]"
	txt += ">[Gosh, I can really hear the rain pouring out there.]";


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ani_update = false;
	var ani2_update = false;
	if (ani_count < ani_wait):
		ani_count += 1;
	else:
		ani_count = 0;
		ani_update = true;
	if (ani2_count < ani2_wait):
		ani2_count += 1;
	else:
		ani2_count = 0;
		ani2_update = true;
		
	match state:
		0:
			if (ani_update):
				if (frame == 0):
					frame = 1;
				else:
					frame = 0;
			if (ani2_update):
				obj_ram.play_sound("alarm");
				ani2_wait = 10;
				state = 1;
		1:
			if (ani_update):
				if (frame == 0):
					frame = 1;
				else:
					frame = 0;
			if (ani2_update):
				ani_wait = 15;
				ani2_wait = 100;
				frame = 2;
				state = 2;
		2:
			if (ani_update):
				if (frame == 2):
					frame = 3;
				else:
					frame = 2;
			if (ani2_update):
				ani2_wait = 45;
				frame = 4;
				state = 3;
		3:
			if (ani2_update):
				player = obj_ram.ow_player;
				obj_ram.scr_msg(txt);
				state = 4;
		4:
			if (obj_ram.text_done):
				obj_ram.set_flag("watched_intro");
				obj_ram.text_done = false;
				player.visible = true;
				player.state = "free";
				queue_free();
			
			
					
			
