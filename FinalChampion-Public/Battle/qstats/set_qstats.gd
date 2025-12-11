"""
Quick stats:
	By pressing z, you can quickly display your stats
"""
extends Node2D
var set_label;
var obj_box;
var lbl_txt;
var x;
var y;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_label = load("res://UI&Menues/set_label.tscn");
	obj_box = get_node("obj_box");
	lbl_txt = instance_create(set_label);
	x = self.position.x; y = self.position.y;
	lbl_txt.ini(obj_box.position.x+16, obj_box.position.y+8, "");
	lbl_txt.change_font("nmb");

func instance_create(arg_res):
	var tmp_inst = arg_res.instantiate();
	add_child(tmp_inst);
	return tmp_inst;
	
func open(arg_txt):
	self.visible = true;
	lbl_txt.draw(arg_txt);
	
func close():
	self.visible = false;
	lbl_txt.draw("");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
