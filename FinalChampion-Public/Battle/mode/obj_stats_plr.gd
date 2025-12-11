extends Label
var plr;
var plr2;
var plr_health;
var plr2_health;
var exSpace = "                                              ";
var plr_speed;
var plr2_speed;
var plr_sp;
var plr2_sp;
var exSpace2 = "                                ";
var plr_en;
var plr2_en;

# Called when the node enters the scene tree for the first time.
func _ready():

	plr = obj_ram.player;
	plr2 = obj_ram.player2;
	findVars();
	'''
	if (plr.get_stat("Speed") > plr2.get_stat("Speed")):
		plr2.sp = plr2.sp * (plr2.get_stat("Speed")/plr.get_stat("Speed"))
		plr2.max_sp = plr2.max_sp * (plr2.get_stat("Speed")/plr.get_stat("Speed"))
	else:
		plr.sp = plr.sp * (plr.get_stat("Speed")/plr2.get_stat("Speed"))
		plr.max_sp = plr.max_sp * (plr.get_stat("Speed")/plr2.get_stat("Speed"))
	plr_health = "\nHP: " + str(plr.Stamina) + " / " + str(plr.MaxStamina);
	plr2_health = "HP: " + str(plr2.Stamina) + " / " + str(plr2.MaxStamina);
	plr_speed = "   Speed: " + str(plr.get_stat("Speed"));
	plr2_speed = "   Speed: " + str(plr2.get_stat("Speed"));
	plr_sp = "\nSP: " + str(plr.sp) + " / " + str(plr.max_sp);
	plr2_sp = "SP: " + str(plr2.sp) + " / " + str(plr2.max_sp);
	plr_en = " En: " + str(plr.Energy) + " ";
	plr2_en = " En: " + str(plr2.Energy) + " ";
	'''


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	findVars();
	self.text = plr.name + exSpace + plr2.name + plr_health + plr_speed + "            " + plr2_health + plr2_speed + plr_sp + plr_en + "                    " + plr2_sp + plr2_en;

func findVars():
	plr_health = "\nHP: " + str(plr.Stamina) + " / " + str(plr.MaxStamina);
	plr2_health = "HP: " + str(plr2.Stamina) + " / " + str(plr2.MaxStamina);
	plr_speed = "   Speed: " + str(plr.get_stat("Speed"));
	plr2_speed = "   Speed: " + str(plr2.get_stat("Speed"));
	plr_sp = "\nSP: " + str(plr.sp) + " / " + str(plr.max_sp);
	plr2_sp = "SP: " + str(plr2.sp) + " / " + str(plr2.max_sp);
	plr_en = " En: " + str(plr.Energy) + " ";
	plr2_en = " En: " + str(plr2.Energy) + " ";
