extends KinematicBody2D

var rng = RandomNumberGenerator.new()
var this
var degree = 0
var thisPositionX
var thisPositionY

onready var anim = $AnimationPlayer



func _ready():
	this = get_node(".")
	_action()
	pass


func _action():
	#randomizePositionAndAngle()
	targetPlayer()
	anim.play("FadeIn")
	
	yield(anim, "animation_finished")
	
	queue_free()
	
	pass


func randomizePositionAndAngle():
	rng.randomize()
	degree += 15
	thisPositionX = rng.randi_range(-496, 496)
	thisPositionY = rng.randi_range(-176, 176)
	this.rotation = degree
	this.position.x = thisPositionX
	this.position.y = thisPositionY
	
	pass

func targetPlayer():
	rng.randomize()
	var player = get_node("/root/World/Player")
	self.rotation = rng.randi_range(0, 180)
	self.position.x = player.position.x
	self.position.y = player.position.y
	
	pass

