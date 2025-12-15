extends Node2D

onready var missile = preload("res://Scenes/Obstacles/Missile.tscn")
onready var anim = $AnimationPlayer
onready var tip = get_node("Tip")


func _ready():
	
	anim.play("LoadIn")
	yield(anim, "animation_finished")
	
	var missile_instance = missile.instance()
	missile_instance.global_position = tip.global_position
	missile_instance.get_node("Sprite").rotation = global_rotation
	get_tree().get_root().add_child(missile_instance)
	
	yield(get_tree().create_timer(1), "timeout")
	
	anim.play("LoadOut")
	yield(anim, "animation_finished")
	
	queue_free()
	
	pass

