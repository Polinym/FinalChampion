extends Node2D
var cutscene = {};

var cuts_sample = [];
var cuts_intro = [];
var cuts_prefight = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	cuts_sample.append( ["", false, "So this is a cutscene."] );
	cuts_sample.append( ["", false, "As you can see, it plays text in a sequence."] );
	cuts_sample.append( ["", false, "There will also be support for actions like changing backgrounds."] );
	cuts_sample.append( ["", false, "But this will do for now."] );
	cuts_sample.append( ["", false, "This is cutscene -| over and out!"] );
	cuts_sample.append( ["end", false, ""] );
	cutscene["sample"] = cuts_sample;
	
	cuts_intro.append( ["bck", "cityscape", "" ]);
	cuts_intro.append( ["", false, "Just on the border of your waking mind,"] );
	cuts_intro.append( ["", false, "there lies another time,| where darkness and light| are one."] );
	cuts_intro.append( ["", false, "A bustling metropolis of the future."] );
	cuts_intro.append( ["", false, "The year is 2095."] );
	cuts_intro.append( ["", false, "Today is the day the \"Iron Arena\" hosts one of the last annual martial arts competitions,| where traditional fighting is still upheld." ]);
	cuts_intro.append( ["", false, "And here we find a young man who wishes to claim the title of champion..."] );
	cuts_intro.append( ["end", false, "home"] );
	cutscene["intro"] = cuts_intro;
	
	cuts_prefight.append( ["bck", "prefight", ""] );
	cuts_prefight.append( ["", false, "/A[I see the arena out there.| This must be the right place.]"] );
	cuts_prefight.append( ["", false, "/4[I wonder who I'm going up against...]"] );
	cuts_prefight.append( ["", false, "/0Just then, a tall man dressed in a sharp green suit stormed in.]"] );
	cuts_prefight.append( ["", false, "/z[Aye!| Outta the way, stringbean!| I'm LOOKIN' fer my /vOPPONENT/w.]" ]);
	cuts_prefight.append( ["", false, "/4[Wait a minute, I think I've seen your face on...| TV before.]" ]);
	cuts_prefight.append( ["", false, "/4[A-aren't you, uh,| /u/5/vZakton, the crime boss/w?!]"]);
	cuts_prefight.append( ["", false, "/Z[Nyeh heh heh...| heard of me, have ya?]"]);
	cuts_prefight.append( ["", false, "/Z[That's right, I'm the leader of the one-and-only /vPiraca crew/w.]"]);
	cuts_prefight.append( ["", false, "/Z[The gang's on the loose, and there ain't nothing' you can do.]"]);
	cuts_prefight.append( ["", false, "/z[And I didn't get to be their boss just off my good#looks.]"]);
	cuts_prefight.append( ["", false, "/z[I happen to be a world-championship /yKICK|-BOX|-ER/w!]"]);
	cuts_prefight.append( ["", false, "/Z[You mess with me, I'll mess you up.]"]);
	cuts_prefight.append( ["", false, "/5[D-doesn't matter!| /AAll that matters is what goes down in the ring!]"]);
	cuts_prefight.append( ["", false, "/Z*Snort*| [S'ppose you can try, but why?| Ya know ya gonna lose.]"]);
	cuts_prefight.append( ["", false, "/A[We'll see about that.]"]);
	cuts_prefight.append( ["prefight", false, "street"] );
	cutscene["prefight"] = cuts_prefight;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
