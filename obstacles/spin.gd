extends Node2D

onready var rotater = get_node("Rotater")
onready var projectile = preload("res://Scenes/Obstacles/Projectile.tscn")
onready var timer = $Timer
onready var anim = $AnimationPlayer

export var rotationSpeed = 50
export var shootingPoints = 4
export var radius = 15
export var waitTime = 0.5
export var projectileSpeed = 50
export var projectileLimit = 20

var step
var rng = RandomNumberGenerator.new()

func _ready():
	
	rng.randomize()
	
	var x = rng.randi_range(-450, 450)
	var y = rng.randi_range(-225, 225)
	
	self.position.x = x
	self.position.y = y
	
	
	step = (2*PI) / shootingPoints
	timer.wait_time = waitTime
	
	anim.play("LoadingIn")
	yield(anim, "animation_finished")
	
	timer.start()
	
	pass



func _physics_process(delta):
	rotater.rotation += rotationSpeed * delta
	pass



func _on_Timer_timeout():
	
	if(projectileLimit <= 0):
		
		anim.play("LoadingOut")
		yield(anim,"animation_finished")
		queue_free()
		
		return
	
	
	for i in range(shootingPoints):
		var dir = fmod(rotater.rotation + (step * i), (2*PI))
		var projectile_instance = projectile.instance()
		projectile_instance.position = global_position
		projectile_instance.apply_impulse(Vector2(), Vector2(projectileSpeed, 0).rotated(dir))
		get_tree().get_root().add_child(projectile_instance)
		projectileLimit -= 1
	
	pass # Replace with function body.

