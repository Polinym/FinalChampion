extends Node2D
var set_phone = load("res://UI&Menues/set_phone.tscn");

var action;
var player;
var done = false;

var phone_msg = "";

# Called when the node enters the scene tree for the first time.
func _ready():
	action = "";
	player = obj_ram.ow_player;
	
	phone_msg = "/A[Y'ello?";
	phone_msg += ">Yeah, hi!]";
	phone_msg += ">/0...";
	phone_msg += ">/3[Yeah, I'm up, I'm up.]";
	phone_msg += ">/0...";
	phone_msg += ">/3[I'm an adult now, I can take care of myself.";
	phone_msg += ">I have my own apartment for crying out loud!";
	phone_msg += ">/AI need to get going.| My match's gonna start real soon.";
	phone_msg += ">/AOkay, bye Mom!]";


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not done:
		var pos = self.position;
		var plr_pos = player.position;
		if (pos.distance_to(Vector2(plr_pos.x+8, plr_pos.y+16)) < 16):
			match action:
				"stare_right":
					obj_ram.actor.play_ani("stare_right");
					done = true;
				"phonecall":
					player.state = "phonelock";
					var tmp_phone = set_phone.instantiate();
					player.add_child(tmp_phone);
					tmp_phone.position.y += -32;
					obj_ram.phone = tmp_phone;
					obj_ram.play_sound("octo_ringtone");
					obj_ram.play_sound2("phone_ringing");
					obj_ram.trigger_msg = phone_msg;
					done = true;
				
		
