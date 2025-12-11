extends Node2D

var chr_objs = [];
var chr_objs_count = 0;
var chr;
var frames;
var width;
var height;
var pos_x;
var pos_y;
var start_x;
var start_y;
var is_text = false;
var ascii_tbl = {};
var length = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	chr = load("res://UI&Menues/font/set_chr.tscn");
	ascii_tbl = obj_ram.ascii_tbl;
	
func pos(arg_x, arg_y):
	start_x = 0;
	start_y = 0;
	self.position.x = arg_x;
	self.position.y = arg_y;
	pos_x = 0;
	pos_y = 0;
	
func ini(arg_frames, arg_width, arg_height):
	length = 0;
	frames = arg_frames;
	width = arg_width;
	height = arg_height;
	start_x = 0; 
	start_y = 0;
	
func add(arg_index):
	length += 1;
	pos_x += width;
	var tmp_chr = chr.instantiate();
	tmp_chr.position.x = pos_x;
	tmp_chr.position.y = pos_y;
	tmp_chr.sprite_frames = frames;
	tmp_chr.frame = arg_index;
	add_child(tmp_chr);
	
func draw_raw(arg_lst):
	if (length > 0):
		clear();
	for c in arg_lst:
		add(c);
	
func draw_text(arg_txt):
	if (length > 0):
		clear();
	for c in arg_txt:
		if (c == "#"):
			pos_x = 0;
			pos_y += height;
		else:
			add(obj_ram.get_ascii(c));
	
	
func clear():
	length = 0;
	pos_x = 0;
	pos_y = 0;
	var childs = get_children();
	for c in childs:
		c.queue_free();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
