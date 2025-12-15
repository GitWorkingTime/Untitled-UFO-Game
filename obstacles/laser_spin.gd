extends Node2D

onready var anim = $AnimationPlayer
onready var levelManager = get_node("/root/World/LevelManager")
signal endThisNode()


export var rotationSpeed = 5
var spinEnabled = false

func _ready():
	levelManager.connect("levelChange", self, "levelChange")
	anim.play("LoadingIn")
	yield(anim, "animation_finished")
	
	anim.play("LaserUse")
	yield(anim, "animation_finished")
	
	spinEnabled = true
	
	pass

func _physics_process(delta):
	
	if(spinEnabled == false):
		return
	
	rotation_degrees += fmod(rotationSpeed * delta, 360)
	
	pass


func levelChange():
	anim.play("LaserGone")
	yield(anim, "animation_finished")
	
	anim.play("LoadingOut")
	yield(anim, "animation_finished")
	
	queue_free()
	
	pass

