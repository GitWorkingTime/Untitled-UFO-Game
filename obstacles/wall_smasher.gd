extends Node2D

signal endNode()

#Position 1 = (-524, 204)
#Position 2 = (524, -204)
var timeElapsed = 0
var x = 0
onready var anim = $AnimationPlayer
var leftOrRight = 0 #0 == right, 1 == left
var start = false;
var end = false;
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	leftOrRight = rng.randi_range(0, 1)
	self.visible = false
	if(leftOrRight == 0):
		self.rotation_degrees = 0
		self.global_position.x = -524
		self.global_position.y = 204
		
	elif(leftOrRight == 1):
		self.rotation_degrees = 180
		self.global_position.x = 524
		self.global_position.y = -204
	
	self.visible = true
	anim.play("Smasher_loadIn")
	yield(anim, "animation_finished")
	
	self.get_node("Direction").visible = true
	anim.play("Direction_loadIn")
	yield(anim, "animation_finished")
	
	anim.play("Direction_loadOut")
	yield(anim, "animation_finished")
	self.get_node("Direction").visible = false
	
	self.get_node("Detection/CollisionShape2D").disabled = false
	start = true
	
	
	pass


func _physics_process(delta):
	
	if(start == false or end == true):
		$Base.rotation_degrees += 10 * timeElapsed * Engine.time_scale
		return
	
	
	$Base.rotation_degrees += 10 * timeElapsed * Engine.time_scale
	timeElapsed += delta * Engine.time_scale
	if(leftOrRight == 0):
		
		if(self.global_position.x < 524):
			x = (40 * timeElapsed * timeElapsed) # Create a parabola with time
			self.global_position.x += x  * Engine.time_scale #Move to the right
			
		else:
			self.global_position.x = 524
			end = true
		
	elif(leftOrRight == 1):
		
		if(self.global_position.x > -524):
			x = (40 * timeElapsed * timeElapsed)
			self.global_position.x -= x * Engine.time_scale #Move to the left
			
		else:
			self.global_position.x = -524
			end = true
		pass
	
	if(end == true):
		emit_signal("endNode")
	
	pass

func _on_WallSmasher_endNode():
	self.get_node("Detection/CollisionShape2D").disabled = true
	anim.play("Smasher_loadOut")
	yield(anim, "animation_finished")
	
	queue_free()
	pass # Replace with function body.

