extends Node2D
var obj_plr;
var obj_rain;
var obj_npc;
var obj_gate;
var obj_trigger;

# Called when the node enters the scene tree for the first time.
func _ready():
	obj_ram.in_ow = true;
	
	var tmp_txt = "";
	obj_plr = load("res://Campaign/ow/set_plr.tscn").instantiate();
	add_child(obj_plr);
	obj_ram.ow_player = obj_plr;
	obj_plr.position.x = obj_ram.spawn[0];
	obj_plr.position.y = obj_ram.spawn[1];
	obj_plr.get_node("obj_sprite_reflect").visible = true;
	
	obj_npc = load("res://Campaign/ow/npc/set_npc.tscn");
	obj_gate = load("res://Campaign/ow/set_gate.tscn");
	obj_trigger = load("res://Campaign/ow/set_trigger.tscn");
	
	var tmp_trigger = obj_trigger.instantiate(); add_child(tmp_trigger);
	tmp_trigger.action = "stare_right";
	tmp_trigger.position.x = 192;
	tmp_trigger.position.y = 112;
	
	var tmp_gate_down = obj_gate.instantiate(); add_child(tmp_gate_down);
	tmp_gate_down.ini(96, 168-24, "street2", "yv", [312, 56], 0);
	
	var tmp_gate_up = obj_gate.instantiate(); add_child(tmp_gate_up);
	tmp_gate_up.ini(408, 64, "prefight", "y^", [120, 120], 2);
	
	var tmp_recept = obj_npc.instantiate(); add_child(tmp_recept);
	tmp_txt = "/b|[Welcome to the Iron Arena!"
	tmp_txt += ">Are you here to compete in the /gmartial arts competition/w| by any chance?]"
	tmp_txt += ">/A[Absolutely!| Where do I go?]";
	tmp_txt += ">/0[Just to the right, big entrance.| You can't miss it.]";
	tmp_txt += ">/A[Cool, thanks!]";
	tmp_recept.ini(128, 60, "recept", tmp_txt, "Receptionist");
	tmp_recept.get_node("obj_shadow").visible = false;
	tmp_recept.face = false;
	tmp_recept.look_around = false;
	var tmp_refl = tmp_recept.get_node("obj_reflect");
	tmp_refl.visible = true;
	tmp_refl.position.y += 7;
	
	var tmp_zakton = obj_npc.instantiate(); add_child(tmp_zakton);
	tmp_txt = "[Outta the way, stringbean."
	tmp_txt += ">Unless you'd like a knuckle sandwich upside ya head.]";
	tmp_zakton.ini(352, 72, "zakton", tmp_txt, "SUSPICIOUS MAN");
	tmp_zakton.set_reflect("zakton");
	obj_ram.actor = tmp_recept;
	
	obj_ram.clear_ambients();
	obj_ram.play_ambient("rain_inside");
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
