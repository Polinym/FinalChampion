extends Node2D
var obj_rain;
var raindrops = [];
var index = 0;
var rain_fall_count = 0; var rain_fall_wait = 5;

# Called when the node enters the scene tree for the first time.
func _ready():
	obj_rain = load("res://UI&Menues/efx/rain/set_raindrop.tscn");
	
	for i in range(100):
		var tmp_drop = drop_rain();
		tmp_drop.position.x = obj_ram.scr_rng(0, 512);
		tmp_drop.position.y = obj_ram.scr_rng(0, 224);
		


func drop_rain():
	var tmp_drop =obj_rain.instantiate();
	raindrops.append(tmp_drop);
	add_child(tmp_drop);
	return tmp_drop;
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (rain_fall_count < rain_fall_wait):
		rain_fall_count += 1;
			
	for tmp_drp in raindrops:
		tmp_drp.position.y += 12;
		if (tmp_drp.position.y > 250):
			tmp_drp.position.y = 0;
			tmp_drp.position.x = obj_ram.scr_rng(0, 512);
