extends Node2D
var set_label = load("res://UI&Menues/set_label.tscn");
var lbl;
var last_eko = -1;
var dsp_eko = 0;


# Called when the node enters the scene tree for the first time.
func _ready():
	lbl = set_label.instantiate();
	add_child(lbl);
	lbl.change_font("kip2");
	last_eko = obj_ram.eko;
	dsp_eko = last_eko;
	lbl.ini(32, 3, str(last_eko));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tmp_eko = obj_ram.eko;
	if (tmp_eko != last_eko):
		if (dsp_eko < tmp_eko):
			dsp_eko += 1;
		elif (dsp_eko > tmp_eko):
			dsp_eko += -1;
		lbl.clear();
		lbl.draw(str(dsp_eko));
		
