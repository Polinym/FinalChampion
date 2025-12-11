extends Node2D
var obj_bck;

var cuts;
var state = 0;
var running = false;
var reading = false;

var spr_bck_cityscape = load("res://spr/bck/cityscape.png");
var spr_bck_prefight = load("res://spr/bck/prefight.png");

var bck_alpha = 0;
var bck_show = false;
var reload = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	#Ready when you are!
	obj_bck = get_node("obj_bck");
	obj_bck.modulate[3] = 0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bck_alpha = obj_bck.modulate[3];
	if (running):
		var event = cuts[state];
		var action = event[0];
		var arg = event[1];
		var tmp_msg = event[2];
		
		match action:
			"bck":
				match arg:
					"cityscape":
						obj_bck.texture = spr_bck_cityscape;
						obj_ram.play_bgm("bgm_NumblyComfortable");
					"prefight":
						obj_bck.texture = spr_bck_prefight;
						obj_ram.stop_ambient();
						obj_ram.play_bgm("bgm_WaitingForTheRainToPass");
				bck_show = true;
				reload = true;
						
			"end":
				if (tmp_msg == ""):
					obj_ram.scene_warp(obj_ram.scene_title);
				else:
					obj_ram.scene_warp(obj_ram.warps[tmp_msg]);
				obj_ram.text_display_hold(true);
			"prefight":
				obj_ram.scene_warp(obj_ram.scene_prefight);
				obj_ram.text_display_hold(true);
			_:
				obj_ram.scr_msg(tmp_msg);
				obj_ram.text_display_hold(false);
				reading = true;
		
		if not (reload):
			running = false;
		else:
			reload = false;
		state += 1;
	
	if (reading):
		if (obj_ram.text_done):
			obj_ram.text_done = false;
			reading = false;
			running = true;
		
	if (bck_show):
		if (bck_alpha < 1):
			bck_alpha += 0.05;
		else:
			bck_show = false;
	
	obj_bck.modulate[3] = bck_alpha;
