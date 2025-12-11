extends Node2D
var obj_sprite;
var obj_shadow;
var obj_token;


var spr_p2 = load("res://spr/btl/multi/ani_hand_p2.tres");
var spr_token_p2 = load("res://spr/btl/multi/token_p2.png");

var index = 0;
var x; var y;

var move_speed = 2;

var icons;
var state = 1;

var left_token = null;
var char_index = -1;

# Called when the node enters the scene tree for the first time.
func _ready():
	obj_sprite = get_node("obj_sprite");
	obj_shadow = get_node("obj_shadow");
	obj_token = get_node("obj_token");
	
func make_p2():
	index = 1;
	obj_sprite.sprite_frames = spr_p2;
	obj_token.texture = spr_token_p2;
	
func check_input():
	obj_ram.input_player = index;
	if (obj_ram.keyboard_hold("vk_down")):
			y += move_speed;
	elif (obj_ram.keyboard_hold("vk_up")):
		y += -move_speed;
	if (obj_ram.keyboard_hold("vk_right")):
		x += move_speed;
	elif (obj_ram.keyboard_hold("vk_left")):
		x += -move_speed;
	obj_ram.input_player = 0;
			
func check_select():
	obj_ram.input_player = index;
	var result = obj_ram.keyboard_check("vk_space");
	obj_ram.input_player = 0;
	return result
	
func check_deslect():
	obj_ram.input_player = index;
	var result = obj_ram.keyboard_check("vk_shift");
	obj_ram.input_player = 0;
	return result
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	x = position.x;
	y = position.y;
	
	check_input();
	
	obj_sprite.frame = state;
	obj_shadow.frame = obj_sprite.frame;
	position.x = x;
	position.y = y;
