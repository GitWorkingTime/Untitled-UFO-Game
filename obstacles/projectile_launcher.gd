extends KinematicBody2D

export var projectile_speed = 500

var projectile = preload("res://Scenes/Obstacles/Projectile.tscn")
onready var player = get_node("/root/World/Player")
onready var tip = get_node("Tip")
onready var anim = $AnimationPlayer

func _ready():
	look_at(player.global_position)
	anim.play("LoadingIn")
	
	yield(anim, "animation_finished")
	yield(get_tree().create_timer(1), "timeout")
	
	fire_projectile()
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	anim.play("FadeOut")
	yield(anim, "animation_finished")
	
	queue_free()
	pass

func _physics_process(delta):
	
	look_at(player.global_position)
	if(self.global_position.y < 0):
		if(rotation_degrees < 15):
			rotation_degrees = 15
		elif(rotation_degrees > 165):
			rotation_degrees = 165
	elif(self.global_position.y > 0):
		if(rotation_degrees > -15):
			rotation_degrees = -15
		elif(rotation_degrees < -165):
			rotation_degrees = -165
	#print(rotation_degrees)
	pass

func fire_projectile():
	var projectile_instance = projectile.instance()
	projectile_instance.position = tip.global_position
	projectile_instance.rotation_degrees = rotation_degrees
	projectile_instance.apply_impulse(Vector2(), Vector2(projectile_speed, 0).rotated(rotation))
	get_tree().get_root().add_child(projectile_instance)
	pass

