extends Node2D
var char;
var set_font;
var font_bar;

var font_bar_stamina;
var font_bar_energy;
var font_bar_ap;

var val;
var dsp_val;
var real_val;
var real_max;
var lbl;
var x; var y;
var val_scale;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_font = load("res://UI&Menues/font/set_font.tscn");
	font_bar_stamina = 	load("res://UI&Menues/font/source/ani_bar_stamina.tres");
	font_bar_energy = 	load("res://UI&Menues/font/source/ani_bar_energy.tres");
	font_bar_ap = 		load("res://UI&Menues/font/source/ani_bar_ap.tres");

func ini(arg_x, arg_y, arg_char, arg_val, arg_scale):
	char = arg_char;
	lbl = instance_create(set_font);
	lbl.ini(font_bar, 2, 4);
	lbl.pos(arg_x, arg_y);
	val = arg_val;
	change_font(val);
	val_scale = arg_scale;
	get_value();
	dsp_val = real_val;
	update_bar(lbl, dsp_val, real_max);
	
func change_font(arg_font):
	match arg_font:
		"stamina":
			lbl.ini(font_bar_stamina, 2, 4);
		"energy":
			lbl.ini(font_bar_energy, 2, 4);
		"ap":
			lbl.ini(font_bar_ap, 2, 4);
	
func get_value():
	match val:
		"stamina":
			real_val = char.Stamina;
			real_max = char.MaxStamina;
		"energy":
			real_val = char.Energy;
			real_max = char.MaxEnergy;
		"ap":
			real_val = char.sp;
			real_max = char.max_sp;
	real_val = ceil(real_val * val_scale);
	real_max = ceil(real_max * val_scale);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_value();
	if not (dsp_val == real_val):
		if (dsp_val < real_val):
			dsp_val += 1;
		elif (dsp_val > real_val):
			dsp_val += -1;
		update_bar(lbl, dsp_val, real_max);
	
func instance_create(arg_res):
	var tmp_inst = arg_res.instantiate();
	add_child(tmp_inst);
	return tmp_inst;
	
func update_bar(arg_bar, arg_val, arg_val_max):
	var lst = [];
	for i in range(arg_val):
		lst.append(0);
	var rest = arg_val_max - arg_val;
	for i in range(rest):
		lst.append(1);
	arg_bar.draw_raw(lst);
