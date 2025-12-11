extends Node2D
var state = 0;
var index = 3;
var numbers = [];
var done = false;
var ani_count = 0; var ani_wait = 30;
var slide = null;
var stop_at = [40, 80, 80, 80];

var sfx = ["cd_fight", "cd_1", "cd_2", "cd_3"];
var ini = true;

var obj_fight;

var bar_bottom;
var bar_top;
var bars;

# Called when the node enters the scene tree for the first time.
func _ready():
	numbers.append(get_node("obj_fight"));
	for i in range(3):
		numbers.append(get_node("obj_n" + str(i+1)));
	slide = numbers[3];
	
	for nmb in numbers:
		nmb.position.y += 12;
	

	bar_bottom = get_node("bar_bottom");
	bar_top = get_node("bar_top");
	bars = [bar_bottom, bar_top];

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (index < 1):
		bar_top.position.y += -4;
		bar_bottom.position.y += 4;
		for bar in bars:
			if (bar.modulate[3] > 0):
				bar.modulate[3] += -0.05;
	match state:
		0:
			var tmp_x = slide.position.x;
			if (tmp_x < stop_at[index]):
				tmp_x += 12;
			else:
				state = 1;
			slide.position.x = tmp_x;
		1:
			if (ini):
				obj_ram.play_sound(sfx[index]);
				ini = false;
			if (ani_count < ani_wait):
				ani_count += 1;
			else:
				state = 2;
				ani_count = 0;
		2:
			var tmp_x = slide.position.x;
			if (tmp_x < 256):
				tmp_x += 16;
				slide.position.x = tmp_x;
			else:
				ini = true;
				slide.queue_free();
				index += -1;
				slide = numbers[index];
				state = 0;
				if (index == -1):
					state = 3;
		3:
			done = true;
		
