extends Node2D
var obj_plr;
var obj_gate;

# Called when the node enters the scene tree for the first time.
func _ready():
	obj_ram.stop_bgm();
	obj_ram.in_ow = true;
	var tmp_txt = "";
	obj_plr = load("res://Campaign/ow/set_plr.tscn").instantiate();
	add_child(obj_plr);
	obj_ram.ow_player = obj_plr;
	obj_plr.position.x = obj_ram.spawn[0];
	obj_plr.position.y = obj_ram.spawn[1];
	obj_ram.limit_camera(0, 0, 256, 224);
	
	obj_plr.visible = false;
	obj_plr.state = "cuts";
	
	obj_gate = load("res://Campaign/ow/set_gate.tscn");
	var tmp_gate = obj_gate.instantiate(); add_child(tmp_gate);
	tmp_gate.ini(120, 128, "street", "yv", [24, 96], 0);
	
	var tmp_trig = load("res://Campaign/ow/set_trigger.tscn").instantiate();
	add_child(tmp_trig);
	tmp_trig.position.x = 128;
	tmp_trig.position.y = 128;
	tmp_trig.action = "phonecall";
	
	obj_ram.clear_ambients();
	obj_ram.play_ambient("rain_inside");
	
	var tmp_sleeper = get_node("obj_plr_sleep");
	if (obj_ram.check_flag("watched_intro")):
		obj_plr.visible = true;
		obj_plr.state = "free";
		tmp_sleeper.queue_free();
		tmp_trig.queue_free();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
