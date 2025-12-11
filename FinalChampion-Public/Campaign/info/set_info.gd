extends Node2D
var set_label = load("res://UI&Menues/set_label.tscn");
var set_bar = load("res://UI&Menues/bar/set_bar.tscn");
var lbl_head;
var lbl_stats;
var lbl_ma;

var obj_box;
var obj_char;
var obj_blink;

var player;
var ow_player;


# Called when the node enters the scene tree for the first time.
func _ready():
	player = obj_ram.player;
	ow_player = obj_ram.ow_player;
	
	obj_box = get_node("obj_box");
	obj_char = get_node("obj_char");
	obj_blink = get_node("obj_blink");
	
	lbl_head = set_label.instantiate(); add_child(lbl_head);
	lbl_head.change_font("nmb");
	var tmp_txt = "";
	tmp_txt += "STAMINA: " + str(player.Stamina) + " / " + str(player.MaxStamina);
	tmp_txt += "##ENERGY:  " + str(player.Energy) + " / " + str(player.MaxEnergy);
	lbl_head.ini(48, 8, tmp_txt);
	
	lbl_stats = set_label.instantiate(); add_child(lbl_stats);
	lbl_stats.change_font("nmb");
	tmp_txt = "STRENGTH: " + str(player.Strength);
	tmp_txt += "##AGILITY:  " + str(player.Agility);
	tmp_txt += "##REFLEXES: " + str(player.Reflexes);
	lbl_stats.ini(4, 48, tmp_txt);
	
	var bar_stamina = set_bar.instantiate(); add_child(bar_stamina);
	bar_stamina.ini(54, 16, player, "stamina", 1);
	
	var bar_energy = set_bar.instantiate(); add_child(bar_energy);
	bar_energy.ini(54, 31, player, "energy", 1);
	
	lbl_ma = set_label.instantiate(); add_child(lbl_ma);
	lbl_ma.change_font("kip2");
	tmp_txt = "";
	tmp_txt +=  "Wrestling:  " + str(player.Wrestling);
	tmp_txt += "#Kickboxing: " + str(player.Kickboxing);
	tmp_txt += "#Boxing:     " + str(player.Boxing);
	tmp_txt += "#Muai Thai:  " + str(player.MuaiThai);
	tmp_txt += "#Judo:       " + str(player.Judo);
	tmp_txt += "#BJJ:        " + str(player.BJJ);
	lbl_ma.ini(96, 40, tmp_txt);
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
