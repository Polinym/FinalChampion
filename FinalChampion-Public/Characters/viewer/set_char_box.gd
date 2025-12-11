extends Node2D
var set_label;
var lbl_txt;
var children;
var x; var y;

func instance_create(arg_res):
	var tmp_inst = arg_res.instantiate();
	add_child(tmp_inst);
	return tmp_inst;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_label = load("res://UI&Menues/set_label.tscn");
	lbl_txt = instance_create(set_label);
	x = self.position.x; y = self.position.y;
	#lbl_txt.ini(x + 32, y + 40, "");
	lbl_txt.ini(x + 40, y + 48, "");
	children = get_children();
	self.visible = false;
	
func open(arg_txt):
	self.visible = true;
	lbl_txt.draw(arg_txt);
	
func close():
	self.visible = false;
	lbl_txt.draw("");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
