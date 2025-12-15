extends Node2D

var missile = preload("res://Scenes/Obstacles/Missile.tscn")
var tips = [0, 1, 2, 3]
var dir
onready var anim = $AnimationPlayer

export var waitTime = 0.05
func _ready():
	#Set up the tips array
	tips[0] = get_node("TipsFolder/Right").global_position
	tips[1] = get_node("TipsFolder/Down").global_position
	tips[2] = get_node("TipsFolder/Left").global_position
	tips[3] = get_node("TipsFolder/Up").global_position
	
	anim.play("LoadIn")
	yield(anim, "animation_finished")
	
	for i in (tips.size()):
		dir = i * 90
		spawnMissile(tips[i].x, tips[i].y, dir)
		yield(get_tree().create_timer(waitTime), "timeout")
		pass
	
	anim.play("Fade")
	yield(anim, "animation_finished")
	
	queue_free()
	
	pass

func spawnMissile(x, y, dir):
	var missile_instance = missile.instance()
	missile_instance.global_position.x = x
	missile_instance.global_position.y = y
	missile_instance.get_node("Sprite").rotation_degrees = dir
	get_tree().get_root().add_child(missile_instance)
	
	
	pass

