extends Node2D

onready var player = get_node("/root/World/Player")

export var missileSpeed = 2
export var timeFollowingSeconds = 2.5
export var rotationSpeed = 3
var timeElapsed = 0
var targetLocked = false
var idleTime = 0.4

func _physics_process(delta):
	var dir = Vector2(cos($Sprite.rotation), sin($Sprite.rotation))
	timeElapsed += delta * Engine.time_scale
	
	if(timeElapsed > idleTime and targetLocked == false):
		targetLocked = true
		timeElapsed = 0
	
	if(timeElapsed < timeFollowingSeconds and targetLocked == true):
		rotateToPlayer(player, delta)
	
	translate(dir * missileSpeed * Engine.time_scale)
	
	pass

func rotateToPlayer(target, delta):
	var dir = (target.global_position - global_position)
	var angleTo = $Sprite.transform.x.angle_to(dir)
	$Sprite.rotate(sign(angleTo) * min(delta * rotationSpeed, abs(angleTo)))
	
	pass


func _on_Area2D_body_entered(body):
	
	if(body.is_in_group("walls") or body.is_in_group("player")):
		queue_free()
	
	pass # Replace with function body.


func _on_Area2D_area_entered(area):
	
	if(area.is_in_group("shield")):
		queue_free()
	
	pass # Replace with function body.

