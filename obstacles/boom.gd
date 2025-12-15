extends Node2D

onready var projectile = preload("res://Scenes/Obstacles/Projectile.tscn")

export var shootingPoints = 5
export var projectileSpeed = 200

var step
var rng = RandomNumberGenerator.new()

func _ready():
	
	rng.randomize()
	
	step = (2*PI) / shootingPoints
	var anim = $AnimationPlayer
	
	self.position.x = rng.randi_range(-450, 450)
	self.position.y = rng.randi_range(-225, 225)
	
	anim.play("LoadingIn")
	yield(anim, "animation_finished")
	
	explode()
	queue_free()
	
	
	pass

func explode():
	for i in (shootingPoints):
		var dir = fmod((step * i), (2*PI))
		var projectile_instance = projectile.instance()
		projectile_instance.position = global_position
		projectile_instance.apply_impulse(Vector2(), Vector2(projectileSpeed, 0).rotated(dir))
		get_tree().get_root().add_child(projectile_instance)
		pass
	pass

