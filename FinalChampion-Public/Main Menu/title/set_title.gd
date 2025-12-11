extends Node2D
var set_label = load("res://UI&Menues/set_label.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	obj_ram.play_bgm("bgm_WhereNobodyDaredToGo");
	var lbl_opts = set_label.instantiate();
	add_child(lbl_opts);
	lbl_opts.change_font("title");
	lbl_opts.ini(80, 104, "Campaign Mode#Freeplay Mode");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
