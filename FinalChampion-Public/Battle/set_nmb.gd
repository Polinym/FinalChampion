extends Node
var set_label = load("res://UI&Menues/set_label.tscn");
var lbl;

var vspd = -2;
var vspd_dec = 0.2;

var start_y = 0;
var y;
var bounced = false;
var waiting = false;
var wait_count = 0; var wait_wait = 30;



# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

func ini(arg_actor, arg_val):
	lbl = set_label.instantiate();
	add_child(lbl);
	lbl.change_font("nmb");
	lbl.ini(0, 0, str(arg_val));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (waiting):
		if (wait_count < wait_wait):
			wait_count += 1;
		else:
			queue_free();
	else:
		y = self.position.y;
		y += vspd;
		vspd += vspd_dec;
		if (y >= 24):
			if not (bounced):
				y = 24;
				vspd = -2;
				bounced = true;
			else:
				y = 24;
				vspd = 0;
				waiting = true;
		self.position.y = y;
	
