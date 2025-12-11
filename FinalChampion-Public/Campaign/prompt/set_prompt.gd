extends Node2D
var set_label = load("res://UI&Menues/set_label.tscn");

var state = 0;
var pos = 0;
var opts = [];
var image_alpha = 0;
var done = false;

var lbl_opts = [];

var ani_count = 0; var ani_wait = 10;

var opts_names = ["", ""];

# Called when the node enters the scene tree for the first time.
func _ready():
	opts.append(get_node("obj_prompt_a"));
	opts.append(get_node("obj_prompt_b"));
	self.modulate[3] = image_alpha;
	
	for lbl in lbl_opts:
		lbl.visible = false;
	

func ini(arg_a, arg_b):
	opts_names = [arg_a, arg_b];
	var tmp_lbl = set_label.instantiate(); add_child(tmp_lbl);
	tmp_lbl.change_font("kip2");
	tmp_lbl.ini(40, 8, opts_names[0]);
	lbl_opts.append(tmp_lbl);
	
	tmp_lbl = set_label.instantiate(); add_child(tmp_lbl);
	tmp_lbl.change_font("kip2");
	tmp_lbl.ini(40, 40, opts_names[1]);
	lbl_opts.append(tmp_lbl);

func opts_ani():
	var opt = opts[pos];
	if (opt.frame == 0):
		opt.frame = 1;
	else:
		opt.frame = 0;

func opts_reset():
	for opt in opts:
		opt.frame = 0;
	opts[pos].frame = 1;
	ani_count = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		0:
			if (image_alpha < 1):
				image_alpha += 0.2;
			else:
				for lbl in lbl_opts:
					lbl.visible = true;
				state = 1;
			self.modulate[3] = image_alpha;
		1:
			if (obj_ram.keyboard_check("vk_down")):
				if (pos < 1):
					pos += 1;
					opts_reset();
					obj_ram.play_sound("prompt_blip");
			elif (obj_ram.keyboard_check("vk_up")):
				if (pos > 0):
					pos += -1;
					opts_reset();
					obj_ram.play_sound("prompt_blip");
			elif (obj_ram.keyboard_check("vk_space")):
				opts[pos].frame = 1;
				ani_wait = 25;
				state = 2;
				obj_ram.play_sound2("prompt_confirm");
			elif (ani_count < ani_wait):
				ani_count += 1;
			else:
				opts_ani();
				ani_count = 0;
		2:
			opts_ani();
			if (image_alpha > 0):
				image_alpha += -0.2;
			else:
				done = true;
				self.visible = false;
				state = 4;
	self.modulate[3] = image_alpha;
