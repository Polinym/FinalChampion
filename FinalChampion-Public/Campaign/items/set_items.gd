extends Node2D
var player; var items;
var item;
var set_label = load("res://UI&Menues/set_label.tscn");

var obj_box;
var obj_sprite;
var obj_cursor;

var spr_item_phone = load("res://spr/menu/items/item_phone.png");
var spr_item_flower = load("res://spr/menu/items/item_flower.png");

var sprs = {};
var names = {};
var desc = {};


var pos = 0;

var state = 255;
var move_dist = 28;
var move_speed = 8;
var ani_count = 0; var ani_wait = move_dist;

var item_count = -1;

var lbl_item_name;
var lbl_item_desc;
var lbl_items;

var desc_pos = 0;
var desc_txt = "";
var desc_work_txt = "";

var start_y = 0;

var done = false;
var ini = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	player = obj_ram.player;
	names["phone"] = "Phone";
	names["flower"] = "Pretty Flower";
	
	sprs["phone"] = spr_item_phone;
	sprs["flower"] = spr_item_flower;
	
	desc["phone"] = "A cellular#communication device#that flips open.";
	desc["flower"] = "A flower bought#from a nice girl#you met.";
	
	obj_box = get_node("obj_box");
	obj_sprite = get_node("obj_sprite");
	obj_cursor = get_node("obj_cursor");
	
	items = player.items;
	item_count = len(player.items)-1;
	
	lbl_item_name = set_label.instantiate(); add_child(lbl_item_name);
	lbl_item_name.change_font("title");
	lbl_item_name.ini(8, 8, "");
	
	lbl_item_desc = set_label.instantiate(); add_child(lbl_item_desc);
	lbl_item_desc.change_font("kip2");
	lbl_item_desc.ini(8, 24, "");
	
	var tmp_txt = "";
	for item in items:
		tmp_txt += names[item];
	
	lbl_items = set_label.instantiate(); add_child(lbl_items);
	lbl_items.change_font("kip2");
	lbl_items.ini(16, 24+52, "");
	
	start_y = obj_cursor.position.y;
	
	
func update_item():
	item = items[pos];
	obj_sprite.texture = sprs[item];
	lbl_item_name.draw(names[item]);
	desc_txt = "";
	desc_work_txt = desc[item];
	desc_pos = 0;
	
func update_cursor():
	obj_ram.play_sound("blip");
	obj_cursor.position.y = start_y + (pos * 16);
	obj_cursor.frame = 0;
	update_item();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		0:
			if (ani_count < move_dist):
				position.y += -move_speed;
				ani_count += 1;
			else:
				state += 1;
				obj_cursor.visible = true;
				obj_cursor.frame = 0;
				obj_sprite.visible = true;
				var tmp_txt = "";
				for item in items:
					tmp_txt += names[item] + "#";
				lbl_items.draw(tmp_txt);
				update_item();
				ani_count = 0;
				ani_wait = 20;
		1:
			if (desc_txt != desc_work_txt):
				desc_txt += desc_work_txt[desc_pos];
				lbl_item_desc.draw(desc_txt);
				desc_pos += 1;
			if (ani_count < ani_wait):
				ani_count += 1;
			else:
				if (obj_cursor.frame == 0):
					obj_cursor.frame = 1;
				else:
					obj_cursor.frame = 0;
				ani_count = 0;
				
			item = items[pos];
			if (obj_ram.keyboard_check("vk_down")):
				if (pos < item_count):
					pos += 1;
					update_cursor();
			elif (obj_ram.keyboard_check("vk_up")):
				if (pos > 0):
					pos += -1;
					update_cursor();
			elif (obj_ram.keyboard_check("vk_shift")):
				obj_ram.play_sound("menu_back");
				obj_cursor.visible = false;
				ani_count = 0;
				ani_wait = 14;
				state += 1;
		2:
			if (ani_count < move_dist):
				position.y += move_speed;
				ani_count += 1;
			else:
				ani_count = 0;
				done = true;
				state += 1;
				lbl_items.clear();
				lbl_item_desc.clear();
				lbl_item_name.clear();
		
