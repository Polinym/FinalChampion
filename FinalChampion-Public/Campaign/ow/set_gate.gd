extends Node2D
var player;
var dest = "";
var check = "center";
var used = false;
var spawn;
var spawn_dir = 0;
var min_dist = -1;

# Called when the node enters the scene tree for the first time.
func _ready():
	player = obj_ram.ow_player;
	self.visible = false;
	dest = "";

func ini(arg_x, arg_y, arg_dest, arg_check, arg_spawn, arg_dir):
	self.position.x = arg_x;
	self.position.y = arg_y;
	dest = arg_dest;
	check = arg_check;
	spawn = arg_spawn;
	spawn_dir = arg_dir;
	
	
func check_distance(arg_pos, arg_pos2, arg_min):
	var new_pos = Vector2(arg_pos.x+8, arg_pos.y+16);
	var new_targ = Vector2(arg_pos2.x+8, arg_pos2.y+ 8);
	print(new_pos.distance_to(new_targ));
	return new_pos.distance_to(new_targ) < arg_min;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not used:
		var pos = self.position;
		var targ_pos = player.position;
		var do_warp = false;
		match check:
			"center":
				#var x = pos.x+8; var y = pos.y+8;
				#var targ_x = targ_pos.x+8; var targ_y = targ_pos.y+24;
				if (pos.distance_to(targ_pos) < 5):
					obj_ram.scene_warp(obj_ram.warps[dest]);
					obj_ram.spawn = spawn;
					player.paused = true;
			"x>":
				if (pos.x <= targ_pos.x):
					player.dir = 1;
					player.state = "leave";
					obj_ram.spawn = [spawn[0], player.position.y];
					do_warp = true;
			"x<":
				if (pos.x >= targ_pos.x):
					player.dir = 3;
					player.state = "leave";
					obj_ram.spawn = [spawn[0], player.position.y];
					do_warp = true;
			"yv":
				if (pos.y <= targ_pos.y):
					player.dir = 0;
					player.state = "leave";
					obj_ram.spawn = spawn;
					do_warp = true;
			"y^":
				if (pos.y >= (targ_pos.y+24)):
					if (min_dist == -1) or check_distance(pos, targ_pos, min_dist):
						player.dir = 2;
						player.state = "leave";
						obj_ram.spawn = spawn;
						do_warp = true;
					
		if (do_warp):
			match dest:
				"prefight":
					obj_ram.cutscene_warp("prefight");
					used = true;
				_:
					obj_ram.spawn_dir = spawn_dir;
					obj_ram.scene_warp(obj_ram.warps[dest]);
					used = true;
