extends Node2D

var rng = RandomNumberGenerator.new()

var xPosition
var yPosition

var this

onready var anim = $AnimationPlayer

func _ready():
	this = get_node(".")
	inflate()
	pass

func inflate():
	
	rng.randomize()
	xPosition = rng.randi_range(-576, 576)
	yPosition = rng.randi_range(256, -256)
	
	this.position.x = xPosition
	this.position.y = yPosition
	
	anim.play("Inflate")
	
	yield(anim, "animation_finished")
	
	queue_free()
	
	
	pass

