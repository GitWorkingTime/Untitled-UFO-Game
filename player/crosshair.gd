extends KinematicBody2D

onready var this = $"."

onready var player = get_parent().get_node(".")
export var radius = 100

func _process(delta):
	this.position = player.get_local_mouse_position().clamped(radius * player.teleportLevel)
	pass

