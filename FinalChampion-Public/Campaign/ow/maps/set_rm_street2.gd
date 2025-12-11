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
	
	var tmp_sign = get_node("obj_sign_arena");
	tmp_sign.play();
	
	obj_rain = load("res://UI&Menues/efx/rain/set_rain.tscn").instantiate();
	add_child(obj_rain);
	
	obj_npc = load("res://Campaign/ow/npc/set_npc.tscn");
	obj_gate = load("res://Campaign/ow/set_gate.tscn");
	
	var tmp_zack = obj_npc.instantiate(); add_child(tmp_zack);
	tmp_txt = "[Me?| Gone gaga over these new benchs.| I love 'em!]";
	tmp_zack.ini(24, 88, "zack", tmp_txt, "SOLDIER MAC");
	tmp_zack.get_node("obj_talk").position.x += 8;
	tmp_zack.get_node("obj_shadow").visible = false;
	
	var tmp_aeris = obj_npc.instantiate(); add_child(tmp_aeris);
	tmp_txt = "[Would you like to buy a /yflower/w?| They're only /g1 Eko/w./?";
	
	
	var tmp_aeris_no = "[Aw, well thanks for stopping by anyway.";
	tmp_aeris_no += ">I'm here selling flowers to support the church with my boyfriend,| but he's not being much of a help.";
	tmp_aeris_no += ">At least, he makes a good bodyguard!]";
	
	var tmp_aeris_yes = "[Thank you so#much!]&|#/0/$(Spent /g1 Eko/w)";
	tmp_aeris_yes += ">[I'm here selling flowers to support the church with my boyfriend,| but he's not being much of a help.";
	tmp_aeris_yes += ">At least, he makes a good bodyguard!]";
	
	tmp_aeris.set_prompt("Sure thing!", tmp_aeris_yes, "No thanks.", tmp_aeris_no);
	tmp_aeris.ini(72, 96, "aeris", tmp_txt, "FLORIST ERICE");
	tmp_aeris.show_eko = true;
	
	var tmp_gate_left = obj_gate.instantiate(); add_child(tmp_gate_left);
	tmp_gate_left.ini(16, 152, "street", "x<", [464, 0], 3);
	
	var tmp_gate_up = obj_gate.instantiate(); add_child(tmp_gate_up);
	tmp_gate_up.ini(320, 72, "lobby", "y^", [96, 120], 2);
	
	
	var tmp_cyborg = obj_npc.instantiate(); add_child(tmp_cyborg);
	tmp_txt = "[Ya here for ta human competition, ain't ya?!| Ya wouldn't last ten seconds in the CYBORG tournament, shrimp!]";
	tmp_cyborg.ini(264, 64, "cyborg", tmp_txt, "CYBORG");
	tmp_cyborg.twoframe = true;
	tmp_cyborg.face = false;
	tmp_cyborg.get_node("obj_shadow").position.x += 8;
	tmp_cyborg.get_node("obj_talk").position.x += 8;
	tmp_cyborg.look_around = false;
	
	obj_ram.clear_ambients();
	obj_ram.play_ambient("rain");
	obj_ram.play_bgm("bgm_AnotherDayInTheFuture");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
