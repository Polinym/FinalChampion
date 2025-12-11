extends Node2D
var obj_plr;
var obj_rain;
var obj_npc;
var obj_gate;

# Called when the node enters the scene tree for the first time.
func _ready():
	obj_ram.in_ow = true;
	
	var tmp_txt = "";
	obj_plr = load("res://Campaign/ow/set_plr.tscn").instantiate();
	add_child(obj_plr);
	obj_ram.ow_player = obj_plr;
	obj_plr.position.x = obj_ram.spawn[0];
	obj_plr.position.y = obj_ram.spawn[1];
	
	obj_rain = load("res://UI&Menues/efx/rain/set_rain.tscn").instantiate();
	add_child(obj_rain);
	
	obj_npc = load("res://Campaign/ow/npc/set_npc.tscn");
	obj_gate = load("res://Campaign/ow/set_gate.tscn");
	
	var tmp_npc1 = obj_npc.instantiate(); add_child(tmp_npc1);
	tmp_txt = "[Hey you!";
	tmp_txt += ">Don't go causing trouble, you hear me?!"
	tmp_txt += ">The /vempire's/w got enough on its hands without punk kids like you.]";
	tmp_npc1.ini(232, 88, "soldier", tmp_txt, "GUARD");
	
	var tmp_caley = obj_npc.instantiate(); add_child(tmp_caley);
	#tmp_txt = "Familiar Man:#[On your way to the competition, huh?";
	#tmp_txt += ">Don't let me hold you up.| I know you're pressed for time.]";
	
	tmp_txt = "[On your way to the /gcompetition/w, huh?";
	tmp_txt += ">No, I'm not wasting presentation#time!| This is a clearly /vproductive conversation/w!> The schedule doesn't REALLY matter...";
	tmp_caley.ini(128, 144, "caley", tmp_txt, "FAMILIAR MAN");
	tmp_caley.update_dir("left");
	
	var tmp_npc2 = obj_npc.instantiate(); add_child(tmp_npc2);
	tmp_txt = "[The city's crime rate's tripled in only a few weeks.";
	tmp_txt += ">Which sucks, 'cause now virtually ALL units get put on street watch, even me.]";
	tmp_npc2.ini(400, 88, "soldier", tmp_txt, "IMPERIAL GUARD");
	tmp_npc2.update_dir("right");
	
	var tmp_npc3 = obj_npc.instantiate(); add_child(tmp_npc3);
	tmp_txt = "[The streets've really gotten unsafe these days...";
	tmp_txt += ">How can they still host the /gfighting competition/w with all the /vgangs/w running around?]";
	tmp_npc3.ini(312, 104, "woman", tmp_txt, "WOMAN");
	tmp_npc3.update_dir("down");
	
	var tmp_gate_right = obj_gate.instantiate(); add_child(tmp_gate_right);
	tmp_gate_right.ini(472, 160, "street2", "x>", [24, 0], 1);
	
	var tmp_gate_top = obj_gate.instantiate(); add_child(tmp_gate_top);
	tmp_gate_top.ini(16, 112, "home", "y^", [120, 120], 2);
	tmp_gate_top.min_dist = 41;
	
	obj_ram.play_ambient("rain");
	obj_ram.play_bgm("bgm_AnotherDayInTheFuture");
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
