extends Node2D
signal endThisNode()
#TO DO LIST:
# Make the wall laser appear from the wall
# Make the laser occur
# Delete this node once finished

#Position
var initial
var final
var x
var y
var speed = 3
var lengthY = 150
var lengthX = 250

#Orientation
var dir
var verticalOrHorizontal

var rng = RandomNumberGenerator.new()
onready var anim = $AnimationPlayer
var start = false
var end = false

func _ready():
	rng.randomize()
	dir = rng.randi_range(0, 1)
	verticalOrHorizontal = rng.randi_range(0, 1) #0 == horizontal and 1 == vertical with regards to the 
laser
	
	if(verticalOrHorizontal == 0):
		yAxisInitialization()
	elif(verticalOrHorizontal == 1):
		xAxisInitialization()
	
	anim.play("LoadingIn")
	yield(anim, "animation_finished")
	
	anim.play("StartLaser")
	yield(anim, "animation_finished")
	
	start = true
	
	
	pass

func _physics_process(delta):
	if(start == false or end == true):
		return
	
	
	if(verticalOrHorizontal == 0): #For the horizontal
		if(dir == 0):
			if(y >= final):
				y -= speed * Engine.time_scale #Move up
			else:
				end = true
			pass
		elif(dir == 1):
			if(y <= initial):
				y += speed * Engine.time_scale #Move down
			else:
				end = true
			pass
	elif(verticalOrHorizontal == 1): #For the vertical
		if(dir == 0):
			if(x >= final):
				x -= speed * Engine.time_scale #Move left
			else:
				end = true
			pass
		elif(dir == 1):
			if(x <= initial):
				x += speed * Engine.time_scale #Move right
			else:
				end = true
			pass
	
	
	self.global_position.y = y
	self.global_position.x = x
	
	if(end == true):
		emit_signal("endThisNode")
	
	pass

func xAxisInitialization():
	rng.randomize()
	x = rng.randi_range(-300, 300)
	
	var topOrBottom = rng.randi_range(0, 1)
	
	if(topOrBottom == 1):
		self.rotation_degrees = 90
		y = -392
	elif(topOrBottom == 0):
		self.rotation_degrees = 270
		y = 392
	
	self.global_position.y = y
	
	initial = clamp(x + lengthX, -712, 712)
	final = clamp(x - lengthX, -712, 712)
	
	if(dir == 0):
		x = initial
	elif(dir == 1):
		x = final
	self.global_position.x = x
	
	pass

func yAxisInitialization():
	rng.randomize()
	y = rng.randi_range(-150, 150)
	
	var leftOrRight = rng.randi_range(0, 1)
	
	if(leftOrRight == 1):
		self.rotation_degrees = 0
		x = -712
	elif(leftOrRight == 0):
		self.rotation_degrees = 180
		x = 712
	
	self.global_position.x = x
	
	initial = clamp(y + lengthY, -392, 392)
	final = clamp(y - lengthY, -392, 392)
	
	if(dir == 1):
		y = final
	elif(dir == 0):
		y = initial
	
	self.global_position.y = y
	pass


func _on_WallLaser_endThisNode():
	
	anim.play("EndLaser")
	yield(anim, "animation_finished")
	
	anim.play("LoadingOut")
	yield(anim, "animation_finished")
	
	queue_free()
	
	pass # Replace with function body.

