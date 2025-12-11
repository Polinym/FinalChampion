extends Node2D
var obj_bgm;
var obj_ambient;

var ambients = {};
var ambient_names;
var playing = "";

var sfx;
var bgm;
var plr;
var sfx2;
var sfx3;

var mute = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	obj_bgm = get_node("obj_bgm");
	obj_ambient = get_node("obj_ambient");
	
	sfx = {};
	add_sound("blip");
	add_sound("blip_confirm");
	add_sound("blip_exit");
	add_sound("blip_text");
	
	add_sound("menu_back");
	add_sound("menu_blip");
	add_sound("menu_close");
	add_sound("menu_confirm");
	add_sound("menu_open");
	
	add_sound("btl_cmds_open");
	add_sound("btl_cmds_blip");
	
	add_sound("prompt_blip");
	add_sound("prompt_confirm");
	
	add_sound("cd_1");
	add_sound("cd_2");
	add_sound("cd_3");
	add_sound("cd_fight");
	add_sound("dingdingding");
	
	add_sound("victory");
	
	add_sound("dodge");
	add_sound("kick");
	add_sound("punch");
	add_sound("throw");
	add_sound("grab");
	add_sound("finisher");
	add_sound("death");
	
	add_sound("menu_punch");
	add_sound("menu_punch_back");
	add_sound("pick_fighter");
	add_sound("start_multi");
	
	add_sound("purchase");
	add_sound("alarm");
	add_sound("octo_ringtone");
	add_sound("phone_ringing");
	add_sound("answer_phone");
	add_sound("crowd");
	
	add_sound("ambient/crowd");
	add_sound("ambient/rain");
	add_sound("ambient/rain_inside");
	add_sound("ambient/wind");
	add_sound("ambient/cheering");
	
	add_sound("advance");
	
	ambient_names = ["crowd", "rain", "rain_inside", "wind", "cheering"];
	for tmp_name in ambient_names:
		ambients[tmp_name] = false;
	
	bgm = {};
	add_bgm("bgm_AnotherDayInTheFuture");
	add_bgm("bgm_ForbiddenLand");
	add_bgm("bgm_VictoryIsOurs");
	add_bgm("bgm_ChooseYourFighter");
	add_bgm("bgm_JustChillin");
	add_bgm("bgm_ExcuseMe");
	add_bgm("bgm_NumblyComfortable");
	add_bgm("bgm_WaitingForTheRainToPass");
	add_bgm("bgm_Unease");
	add_bgm("bgm_LetsGoDoTheThing");
	add_bgm("bgm_RottingBiscuits");
	add_bgm("bgm_WhereNobodyDaredToGo");
	obj_bgm.volume_db = -9;
	
	plr = AudioStreamPlayer.new();
	plr.volume_db = -3;
	add_child(plr);
	
	sfx2 = AudioStreamPlayer.new();
	sfx2.volume_db = -3;
	add_child(sfx2);
	
	sfx3 = AudioStreamPlayer.new();
	sfx3.volume_db = -3;
	add_child(sfx3);
		
func add_sound(arg_snd_path):
	sfx[arg_snd_path] = load("res://sfx/" + arg_snd_path + ".wav");
	
func add_bgm(arg_snd_path):
	bgm[arg_snd_path] = load("res://bgm/" + arg_snd_path + ".wav");
	
func play_sound(arg_snd_path):
	if not (mute):
		plr.stream = sfx[arg_snd_path];
		plr.play();
	
func play_sound2(arg_snd_path):
	if not (mute):
		sfx2.stream = sfx[arg_snd_path];
		sfx2.play();
	
func play_sound3(arg_snd_path):
	if not (mute):
		sfx3.stream = sfx[arg_snd_path];
		sfx3.play();
	
func play_bgm(arg_snd_path):
	if not mute:
		if not playing == arg_snd_path:
			playing = arg_snd_path;
			obj_bgm.stream = bgm[arg_snd_path];
			obj_bgm.play();
	
func stop_bgm():
	obj_bgm.stop();

func stop_sfx():
	plr.stop();
	sfx2.stop();
	
func stop_ambient():
	obj_ambient.stop();

func play_ambient(arg_name):
	if not (mute):
		if not (ambients[arg_name]):
			obj_ambient.stream = sfx["ambient/" + arg_name];
			obj_ambient.play();
			ambients[arg_name] = true;

func clear_ambient():
	for tmp_name in ambient_names:
		ambients[tmp_name] = false;
	obj_ambient.stop();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
