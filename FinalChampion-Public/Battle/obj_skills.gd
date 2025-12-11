extends Node

var skills = {}
var wrestlingSkill = {}
var kickboxingSkill = {}
var boxingSkill = {}
var muaiThaiSkill = {}
var judoSkill = {}
var bjjSkill = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func ini():
	wrestlingSkill["Punch"] = 0
	wrestlingSkill["Kick"] = 0
	wrestlingSkill["Grapple"] = 10
	wrestlingSkill["Choke"] = 0
	wrestlingSkill["Joint Lock"] = 5
	wrestlingSkill["Takedown"] = 10
	wrestlingSkill["Grapple Midigation"] = 5
	
	kickboxingSkill["Punch"] = 5
	kickboxingSkill["Kick"] = 10
	kickboxingSkill["Grapple"] = 0
	kickboxingSkill["Choke"] = 0
	kickboxingSkill["Joint Lock"] = 0
	kickboxingSkill["Takedown"] = 0
	kickboxingSkill["Strike Midigation"] = 10
	
	boxingSkill["Punch"] = 15
	boxingSkill["Kick"] = 0
	boxingSkill["Grapple"] = 0
	boxingSkill["Choke"] = 0
	boxingSkill["Joint Lock"] = 0
	boxingSkill["Takedown"] = 0
	boxingSkill["Strike Midigation"] = 10
	
	muaiThaiSkill["Punch"] = 10
	muaiThaiSkill["Kick"] = 10
	muaiThaiSkill["Grapple"] = 5
	muaiThaiSkill["Choke"] = 0
	muaiThaiSkill["Joint Lock"] = 0
	muaiThaiSkill["Takedown"] = 0
	muaiThaiSkill["Strike Midigation"] = 10
	
	judoSkill["Punch"] = 0
	judoSkill["Kick"] = 0
	judoSkill["Grapple"] = 5
	judoSkill["Choke"] = 5
	judoSkill["Joint Lock"] = 5
	judoSkill["Takedown"] = 5
	judoSkill["Grapple Midigation"] = 15
	
	bjjSkill["Punch"] = 0
	bjjSkill["Kick"] = 0
	bjjSkill["Grapple"] = 5
	bjjSkill["Choke"] = 10
	bjjSkill["Joint Lock"] = 10
	bjjSkill["Takedown"] = 0
	bjjSkill["Grapple Midigation"] = 5
	
	skills["Wrestling Skill"] = wrestlingSkill
	skills["Kickboxing Skill"] = kickboxingSkill
	skills["Boxing Skill"] = boxingSkill
	skills["Muai Thai Skill"] = muaiThaiSkill
	skills["Judo Skill"] = judoSkill
	skills["BJJ Skill"] = bjjSkill
