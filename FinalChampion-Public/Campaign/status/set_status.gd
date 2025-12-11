extends Node2D

var set_label;
var set_eko;
var player;
var ow_player;

var lbl_info;

var state = 0;

var ani_count = 0; var ani_wait = 18;
var ani_frame = 0;

var eko_bar;

# Called when the node enters the scene tree for the first time.
func _ready():
	player = obj_ram.player;
	set_label = load("res://UI&Menues/set_label.tscn");
	set_eko = load("res://UI&Menues/set_eko.tscn");
	eko_bar = set_eko.instantiate();
	add_child(eko_bar);
	eko_bar.position.x += 124;
	eko_bar.position.y += 64;
	lbl_info = set_label.instantiate();
	add_child(lbl_info);
	lbl_info.change_font("kip2");
	var tmp_txt = player.plr_name + "#Stamina: " + str(player.Stamina) + "#Energy: " + str(player.Energy);
	lbl_info.ini(80, 8, tmp_txt);
	
	var ow_player = obj_ram.ow_player;
	var cam = ow_player.get_node("obj_camera");
	var tmp_pos = cam.get_screen_center_position();
	self.position.x = tmp_pos.x - 104;
	self.position.y = tmp_pos.y - 176;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		0:
			if (ani_count < ani_wait):
				self.position.y += 4;
				ani_count += 1;
			else:
				ani_count = 0;
				state = 1;
		1:
			obj_ram.do_nothing;
		2:
			if (ani_count < ani_wait):
				self.position.y += -4;
				ani_count += 1;
			else:
				ani_count = 0;
				queue_free();
