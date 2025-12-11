extends Node2D
var txt_obj;
var txt;
var font_text;
var font_monshou;
var font_nmb;
var font_kip2;
var font_kip_blue;
var font_kip_green;
var font_kip_violet;
var font_kip_yellow;
var font_title;

# Called when the node enters the scene tree for the first time.
func _ready():
	var font_obj = load("res://UI&Menues/font/set_font.tscn");
	font_text = load("res://UI&Menues/font/source/ani_font_fe.tres");
	font_monshou = load("res://UI&Menues/font/source/ani_font_monshou.tres");
	font_nmb = load("res://UI&Menues/font/source/ani_font_nmb.tres");
	font_kip2 = load("res://UI&Menues/font/source/ani_font_kip2.tres");
	font_title = load("res://UI&Menues/font/source/ani_font_title.tres");
	
	font_kip_blue = load("res://UI&Menues/font/source/ani_kip_blues.tres");
	font_kip_green = load("res://UI&Menues/font/source/ani_kip_green.tres");
	font_kip_violet = load("res://UI&Menues/font/source/ani_kip_violet.tres");
	font_kip_yellow = load("res://UI&Menues/font/source/ani_kip_yellow.tres");
	txt_obj = instance_create(font_obj);
	txt_obj.ini(font_text, 8, 8);
	txt_obj.pos(-128, -128);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass;
	
func ini(arg_x, arg_y, arg_txt):
	txt = arg_txt;
	txt_obj.pos(arg_x, arg_y);
	draw(arg_txt);
	
func draw(arg_txt):
	txt = arg_txt;
	txt_obj.draw_text(arg_txt);
	
func clear():
	txt_obj.clear();
	
func change_font(arg_font):
	match arg_font:
		"monshou":
			txt_obj.ini(font_monshou, 8, 16);
		"text":
			txt_obj.ini(font_text, 8, 8);
		"nmb":
			txt_obj.ini(font_nmb, 7, 7);
		"kip2":
			txt_obj.ini(font_kip2, 7, 16);
		"kip_blue":
			txt_obj.ini(font_kip_blue, 7, 16);
		"kip_green":
			txt_obj.ini(font_kip_green, 7, 16);
		"kip_violet":
			txt_obj.ini(font_kip_violet, 7, 16);
		"kip_yellow":
			txt_obj.ini(font_kip_yellow, 7, 16);
		"title":
			txt_obj.ini(font_title, 7, 16);
	if (txt):
		txt_obj.clear();
		txt_obj.draw_text(txt);


func instance_create(arg_res):
	var tmp_inst = arg_res.instantiate();
	add_child(tmp_inst);
	return tmp_inst;
