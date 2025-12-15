extends Node2D
#List of obstacle timers/ obstacles:
signal levelChange


#Obstacles that shoot projectiles
onready var pelletShooter = preload("res://Scenes/Obstacles/ProjectileLauncher.tscn")
onready var missileShooter = preload("res://Scenes/Obstacles/MissileLauncher.tscn")

#Obstacles that shoot projectiles in all direction
onready var bomb = preload("res://Scenes/Obstacles/Boom.tscn")
onready var bombSpinning = preload("res://Scenes/Obstacles/Spin.tscn")
onready var missileBomb = preload("res://Scenes/Obstacles/MissileBomb.tscn")

#Obstacles that take up space
onready var laser = preload("res://Scenes/Obstacles/Laser.tscn")
onready var inflate = preload("res://Scenes/Obstacles/Inflate.tscn")
onready var laserSpin = preload("res://Scenes/Obstacles/LaserSpin.tscn")
onready var wallLaser = preload("res://Scenes/Obstacles/WallLaser.tscn")
onready var wallSmasher = preload("res://Scenes/Obstacles/WallSmasher.tscn")

#Timer
onready var timer = $Timer
onready var waveWaitTime:float = 1.25

#Level
export var level = 1
export var levelDisplay = 1
var startingAmount = 3
var repeatPatternAmount = startingAmount
var lockPattern = false
var pattern = 0
var prevPattern
var loadLaserSpin = false


var rng = RandomNumberGenerator.new()
onready var player = get_parent().get_node("Player")
onready var animTransition = get_parent().get_node("TransitionScene/AnimationPlayer")

func _ready():
	rng.randomize()
	levelDisplay = level
	pattern = rng.randi_range(1,5)
	#pattern = 5
	
	animTransition.play("FadeOut")
	yield(animTransition, "animation_finished")
	
	$Countdown/CountdownAnim.play("Countdown")
	yield($Countdown/CountdownAnim, "animation_finished")
	timer.start()
	
	pass

func _process(delta):
	if(player.health <= 0):
		timer.stop()
		emit_signal("levelChange")
		pass
	pass

#Waves
func easyWave():
	timer.stop()
	rng.randomize()
	
	if(lockPattern == false):
		while(pattern == prevPattern):
			pattern = rng.randi_range(1,5)
		lockPattern = true
		pass
	
	match(pattern):
		1:
			var bomb_instance = bomb.instance()
			var bombDecreaseTime = 0.15
			var pelletShooterDecreaseTime = 0.05
			var bombWaitingTime = clamp(1.25 - ((level - 1) * bombDecreaseTime), 0.75, 1.25)
			var pelletShooterWaitingTime = clamp(0.5 - ((level - 1) * 
pelletShooterDecreaseTime), 0.15, 0.5)
			
			add_child(bomb_instance)
			yield(get_tree().create_timer(bombWaitingTime), "timeout")
			
			for i in 2:
				spawnPellet()
				yield(get_tree().create_timer(pelletShooterWaitingTime), "timeout")
				pass
			
			waveWaitTime = clamp(1.75 + ((level - 1) * -0.2), 0.95, 1.75)
			pass
		2:
			rng.randomize()
			var amountSpawned = 2
			var missileDecreaseTime = 0.1
			var missileWaitTime = clamp(1.4 - ((level - 1) * missileDecreaseTime), 0.6, 1.35)
			
			for i in amountSpawned:
				spawnMissile()
				yield(get_tree().create_timer(missileWaitTime), "timeout")
				
				pass
			
			waveWaitTime = missileWaitTime
			pass
		3:
			var bombSpinning_instance = bombSpinning.instance()
			var bombSpinningDecreaseAmount = 0.1
			var inflateDecreaseAmount = 0.1
			var bombSpinningWaitTime = clamp(1.25 - ((level -1) * bombSpinningDecreaseAmount), 
0.75, 1.25 )
			var numberOfInflates = 3
			var inflateWaitTime = clamp(0.75 - ((level - 1) * inflateDecreaseAmount), 0.15, 
0.75)
			
			add_child(bombSpinning_instance)
			yield(get_tree().create_timer(bombSpinningWaitTime), "timeout")
			
			for i in numberOfInflates:
				
				var inflate_instance = inflate.instance()
				add_child(inflate_instance)
				yield(get_tree().create_timer(inflateWaitTime), "timeout")
				
				pass
			
			waveWaitTime = clamp(1.5 + ((level - 1) * 0.05), 1.1, 1.5)
			pass
		4:
			rng.randomize()
			var laserDecreaseTime = 0.05
			var pelletShooterDecreaseTime = 0.1
			var laserWaitTime = clamp(1 - ((level - 1) * laserDecreaseTime), 0.6, 1)
			var pelletShooterWaitTime = clamp(0.75 - ((level - 1) * pelletShooterDecreaseTime), 
0.2, 0.75)
			var amountSpawned = 2
			
			for i in amountSpawned:
				spawnPellet()
				yield(get_tree().create_timer(pelletShooterWaitTime), "timeout")
				pass
			
			for i in amountSpawned:
				
				var laser_instance = laser.instance()
				add_child(laser_instance)
				yield(get_tree().create_timer(laserWaitTime), "timeout")
				pass
			
			waveWaitTime = laserWaitTime
			pass
		5:
			var laser_instance = laser.instance()
			var laserDecreaseTime = 0.075
			var inflateDecreaseTime = 0.095
			var laserWaitTime = clamp(0.7 - ((level - 1) * laserDecreaseTime), 0.4, 0.6)
			var inflateWaitTime = clamp(0.8 - ((level - 1) * inflateDecreaseTime), 0.35, 0.7)
			
			add_child(laser_instance)
			yield(get_tree().create_timer(laserWaitTime), "timeout")
			
			for i in 3:
				
				var inflate_instance = inflate.instance()
				add_child(inflate_instance)
				yield(get_tree().create_timer(inflateWaitTime), "timeout")
				pass
			
			waveWaitTime = laserWaitTime
			pass
	
	repeatPatternAmount -= 1
	timer.wait_time = waveWaitTime
	timer.start()
	pass

func mediumWave():
	timer.stop()
	rng.randomize()
	if(lockPattern == false):
		while(pattern == prevPattern):
			pattern = rng.randi_range(1,6)
		lockPattern = true
		pass
	
	
	match(pattern):
		1:
			rng.randomize()
			var missileBombDecreaseTime = 0.125
			var inflateDecreaseTime = 0.1
			
			var missileBombWaitTime = clamp(1.5 - ((level - 1) * missileBombDecreaseTime), 
0.75, 1.5)
			var inflateWaitTime = clamp(0.5 - ((level - 1) * inflateDecreaseTime), 0.15, 0.5)
			
			var missileBomb_instance = missileBomb.instance()
			var missileBombX = rng.randi_range(-200, 200)
			var missileBombY = rng.randi_range(-150, 150)
			
			missileBomb_instance.global_position.x = missileBombX
			missileBomb_instance.global_position.y = missileBombY
			
			add_child(missileBomb_instance)
			yield(get_tree().create_timer(missileBombWaitTime), "timeout")
			
			var amountOfInflates = 3
			for i in (amountOfInflates):
				var inflate_instance = inflate.instance()
				add_child(inflate_instance)
				yield(get_tree().create_timer(inflateWaitTime), "timeout")
				
				pass
			
			waveWaitTime = clamp(1.65 - ((level - 1) * 0.115), 0.6, 1.65)
			pass
		2:
			var waitTimeDecrease = 0.15
			var waitTime = clamp(1.5 - ((level - 1) * -waitTimeDecrease), 0.75, 1.5)
			
			var wallLaser_instance = wallLaser.instance()
			add_child(wallLaser_instance)
			yield(get_tree().create_timer(waitTime), "timeout")
			
			spawnMissile()
			yield(get_tree().create_timer(waitTime), "timeout")
			
			var wallLaser_instance2 = wallLaser.instance()
			add_child(wallLaser_instance2)
			yield(get_tree().create_timer(waitTime), "timeout")
			
			waveWaitTime = waitTime
			
			pass
		3:
			var wallSmasherDecreaseTime = 0.05
			var laserDecreaseTime = 0.15
			var wallSmasherWaitTime = clamp(1.5 - ((level - 1) * wallSmasherDecreaseTime), 1, 
1.5)
			var laserWaitTime = clamp(1 - ((level - 1) * laserDecreaseTime), 0.5 ,1)
			
			var wallSmasher_instance = wallSmasher.instance()
			add_child(wallSmasher_instance)
			yield(get_tree().create_timer(wallSmasherWaitTime), "timeout")
			
			for i in 2:
				var laser_instance = laser.instance()
				add_child(laser_instance)
				yield(get_tree().create_timer(laserWaitTime), "timeout")
				
				pass
			
			waveWaitTime = wallSmasherWaitTime
			pass
		4:
			var pelletShooterDecreaseTime = 0.125
			var explosiveDecreaseTime = 0.175
			
			var pelletShooterWaitTime = clamp(1 - ((level - 1) * pelletShooterDecreaseTime), 
0.5, 1)
			var explosiveWaitTime = clamp(1.5 - ((level - 1) * explosiveDecreaseTime), 0.75, 
1.5)
			
			var bombSpinning_instance = bombSpinning.instance()
			add_child(bombSpinning_instance)
			yield(get_tree().create_timer(explosiveWaitTime), "timeout")
			
			var bomb_instance = bomb.instance()
			add_child(bomb_instance)
			yield(get_tree().create_timer(explosiveWaitTime), "timeout")
			
			for i in 2:
				spawnPellet()
				yield(get_tree().create_timer(pelletShooterWaitTime), "timeout")
			
			waveWaitTime = explosiveWaitTime
			
			pass
		5:
			var laserSpinDecreaseTime = 0.15
			var wallLaserDecreaseTime = 0.175
			var laserSpinWaitTime = clamp(1.5 - ((level - 1) * laserSpinDecreaseTime), 1, 1.5)
			var wallLaserWaitTime = clamp(2 - ((level - 1) * wallLaserDecreaseTime), 1, 2)
			
			if(loadLaserSpin == false):
				var laserSpin_instance = laserSpin.instance()
				add_child(laserSpin_instance)
				yield(get_tree().create_timer(laserSpinWaitTime), "timeout")
				loadLaserSpin = true
				pass
			
			for i in 2:
				var wallLaser_instance = wallLaser.instance()
				add_child(wallLaser_instance)
				yield(get_tree().create_timer(wallLaserWaitTime), "timeout")
				pass
			
			waveWaitTime = laserSpinWaitTime
			
			pass
		6:
			var laserSpinDecreaseTime = 0.15
			var explosiveDecreaseTime = 0.125
			var laserSpinWaitTime = clamp(1.5 - ((level - 1) * laserSpinDecreaseTime), 1, 1.5)
			var explosiveWaitTime = clamp(1 - ((level - 1) * explosiveDecreaseTime), 0.5, 1)
			
			if(loadLaserSpin == false):
				var laserSpin_instance = laserSpin.instance()
				add_child(laserSpin_instance)
				yield(get_tree().create_timer(laserSpinWaitTime), "timeout")
				loadLaserSpin = true
				pass
			
			var bomb_instance = bomb.instance()
			add_child(bomb_instance)
			yield(get_tree().create_timer(explosiveWaitTime), "timeout")
			
			var bombSpinning_instance = bombSpinning.instance()
			add_child(bombSpinning_instance)
			yield(get_tree().create_timer(explosiveWaitTime), "timeout")
			
			waveWaitTime = laserSpinWaitTime
			
			pass
	
	repeatPatternAmount -= 1
	timer.wait_time = waveWaitTime
	timer.start()
	pass

func hardWave():
	timer.stop()
	if(lockPattern == false):
		while(pattern == prevPattern):
			pattern = rng.randi_range(1,8)
		lockPattern = true
		pass
	match(pattern):
		1:
			var laserSpinDecreaseTime = 0.125
			var wallLaserDecreaseTime = 0.105
			var inflateDecreaseTime = 0.1
			
			var laserSpinWaitTime = clamp(1.5 - ((level - 1) * laserSpinDecreaseTime), 1, 1.5)
			var wallLaserWaitTime = clamp(1 - ((level - 1) * wallLaserDecreaseTime), 0.65, 1)
			var inflateWaitTime = clamp(1 - ((level - 1) * inflateDecreaseTime), 0.6, 1)
			
			if(loadLaserSpin == false):
				var laserSpin_instance = laserSpin.instance()
				add_child(laserSpin_instance)
				yield(get_tree().create_timer(laserSpinWaitTime), "timeout")
				loadLaserSpin = true
				pass
			
			for i in 2:
				if(player.health <= 0):
					return
					pass
				
				var wallLaser_instance = wallLaser.instance()
				add_child(wallLaser_instance)
				yield(get_tree().create_timer(wallLaserWaitTime), "timeout")
				pass
			
			for i in 3:
				if(player.health <= 0):
					return
					pass
				
				var inflate_instance = inflate.instance()
				add_child(inflate_instance)
				yield(get_tree().create_timer(inflateWaitTime), "timeout")
				pass
			
			
			pass
		2:
			var bombsDecreaseTime = 0.125
			var bombsWaitTime = clamp(2.15 - ((level - 1) * bombsDecreaseTime), 1.1, 2.15)
			for i in 2:
				if(player.health <= 0):
					return
					pass
				
				var missileBomb_instance = missileBomb.instance()
				add_child(missileBomb_instance)
				yield(get_tree().create_timer(bombsWaitTime), "timeout")
				
				var bombSpinning_instance = bombSpinning.instance()
				add_child(bombSpinning_instance)
				yield(get_tree().create_timer(bombsWaitTime), "timeout")
				
				var bomb_instance = bomb.instance()
				add_child(bomb_instance)
				yield(get_tree().create_timer(bombsWaitTime), "timeout")
				
				pass
			
			
			pass
		3:
			var shooterDecreaseTime = 0.115
			var laserDecreaseTime = 0.125
			
			var shooterWaitTime = clamp(0.5 - ((level - 1) * shooterDecreaseTime ), 0.2, 0.5)
			var laserWaitTime = clamp(0.75 - ((level - 1) * laserDecreaseTime), 0.35, 0.75)
			
			for i in 2:
				spawnPellet()
				yield(get_tree().create_timer(shooterWaitTime), "timeout")
				
				var laser_instance = laser.instance()
				add_child(laser_instance)
				yield(get_tree().create_timer(laserWaitTime), "timeout")
				
				spawnMissile()
				yield(get_tree().create_timer(shooterWaitTime), "timeout")
				
				pass
			
			
			pass
		4:
			var wallSmasherDecreaseTime = 0.095
			var missileBombDecreaseTime = 0.125
			var pelletShooterDecreaseTime = 0.1
			
			var wallSmasherWaitTime = clamp(1.6 - ((level - 1) * wallSmasherDecreaseTime), 1.1, 
1.6)
			var missileBombWaitTime = clamp(1.4 - ((level - 1) * missileBombDecreaseTime), 0.8, 
1.4)
			var pelletShooterWaitTime = clamp(0.8 - ((level - 1) * pelletShooterDecreaseTime), 
0.6, 0.8)
			
			var wallSmasher_instance = wallSmasher.instance()
			add_child(wallSmasher_instance)
			yield(get_tree().create_timer(wallSmasherWaitTime), "timeout")
			
			for i in 2:
				spawnPellet()
				yield(get_tree().create_timer(pelletShooterWaitTime), "timeout")
				pass
			
			var missileBomb_instance = missileBomb.instance()
			add_child(missileBomb_instance)
			yield(get_tree().create_timer(missileBombWaitTime), "timeout")
			
			
			
			pass
		5:
			var wallSmasherDecreaseTime = 0.125
			var missileLauncherDecreaseTime = 0.115
			var wallLaserDecreaseTime = 0.105
			
			var wallSmasherWaitTime = clamp(2 - ((level - 1) * wallSmasherDecreaseTime), 1.25, 
2)
			var missileLauncherWaitTime = clamp(1.4 - ((level - 1 ) * 
missileLauncherDecreaseTime), 0.9, 1.4)
			var wallLaserWaitTime = clamp(1 - ((level - 1) * wallLaserDecreaseTime), 0.65, 1)
			
			var wallSmasher_instance = wallSmasher.instance()
			add_child(wallSmasher_instance)
			yield(get_tree().create_timer(wallSmasherWaitTime), "timeout")
			
			for i in 2:
				spawnMissile()
				yield(get_tree().create_timer(missileLauncherWaitTime), "timeout")
				
				var wallLaser_instance = wallLaser.instance()
				add_child(wallLaser_instance)
				yield(get_tree().create_timer(wallLaserWaitTime), "timeout")
				
				pass
			
			
			pass
		6:
			var pelletLauncherDecreaseTime = 0.11
			var bombDecreaseTime = 0.125
			var laserDecreaseTime = 0.125
			
			var pelletLauncherWaitTime = clamp(0.6 - ((level - 1) * 
pelletLauncherDecreaseTime), 0.25, 0.6)
			var bombWaitTime = clamp(0.95 - ((level - 1) * bombDecreaseTime), 0.4, 0.95)
			var laserWaitTime = clamp(1.15 - ((level - 1) * laserDecreaseTime), 0.6, 1.15)
			
			for i in 2:
				spawnPellet()
				yield(get_tree().create_timer(pelletLauncherWaitTime), "timeout")
				
				pass
			
			var bomb1_instance = bomb.instance()
			add_child(bomb1_instance)
			yield(get_tree().create_timer(bombWaitTime), "timeout")
			
			var laser_instance = laser.instance()
			add_child(laser_instance)
			yield(get_tree().create_timer(laserWaitTime), "timeout")
			
			var bomb2_instance = bomb.instance()
			add_child(bomb2_instance)
			yield(get_tree().create_timer(bombWaitTime), "timeout")
			
			for i in 2:
				spawnPellet()
				yield(get_tree().create_timer(pelletLauncherWaitTime), "timeout")
				
				pass
			
			pass
		7:
			var wallSmasherDecreaseTime = 0.175
			var laserSpinDecreaseTime = 0.075
			var wallLaserDecreaseTime = 0.125
			
			var wallSmasherWaitTime = clamp(2 - ((level - 1) * wallSmasherDecreaseTime), 1.15, 
2)
			var laserSpinWaitTime = clamp(1.25 - ((level - 1) * laserSpinDecreaseTime), 1, 
1.25)
			var wallLaserWaitTime = clamp(1.1 - ((level - 1) * wallLaserDecreaseTime), 0.75, 
1.1)
			
			if(loadLaserSpin == false):
				var laserSpin_instance = laserSpin.instance()
				add_child(laserSpin_instance)
				yield(get_tree().create_timer(laserSpinWaitTime), "timeout")
				loadLaserSpin = true
				pass
			
			var wallSmasher_instance = wallSmasher.instance()
			add_child(wallSmasher_instance)
			yield(get_tree().create_timer(wallSmasherWaitTime), "timeout")
			
			for i in 2:
				var wallLaser_instance = wallLaser.instance()
				add_child(wallLaser_instance)
				yield(get_tree().create_timer(wallLaserWaitTime), "timeout")
				
				pass
			
			pass
		8:
			var bombDecreaseTime = 0.105
			var inflateDecreaseTime = 0.095
			
			var bombWaitTime = clamp(0.9 - ((level - 1) * bombDecreaseTime), 0.6, 0.9)
			var inflateWaitTime = clamp(0.7 - ((level - 1) * inflateDecreaseTime), 0.4, 0.7)
			
			for i in 2:
				if(player.health <= 0):
					return
					pass
				
				var missileBomb_instance = missileBomb.instance()
				add_child(missileBomb_instance)
				yield(get_tree().create_timer(bombWaitTime), "timeout")
				
				for x in 4:
					if(player.health <= 0):
						return
						pass
					var inflate_instance = inflate.instance()
					add_child(inflate_instance)
					yield(get_tree().create_timer(inflateWaitTime), "timeout")
					
					pass
				
				if(player.health <= 0):
					return
					pass
				
				var bombSpinning_instance = bombSpinning.instance()
				add_child(bombSpinning_instance)
				yield(get_tree().create_timer(bombWaitTime), "timeout")
				
				for x in 4:
					if(player.health <= 0):
						return
						pass
					
					var inflate_instance = inflate.instance()
					add_child(inflate_instance)
					yield(get_tree().create_timer(inflateWaitTime), "timeout")
					pass
				
				pass
			
			pass
	
	repeatPatternAmount -= 1
	timer.wait_time = waveWaitTime
	timer.start()
	
	
	pass

func _on_Timer_timeout():
	if(repeatPatternAmount > 0):
		
		if(levelDisplay < 20):
			easyWave()
			pass
		elif(levelDisplay >= 19 and levelDisplay < 50):
			mediumWave()
			pass
		else:
			hardWave()
			pass
		pass
	elif(repeatPatternAmount <= 0 ):
		timer.stop()
		emit_signal("levelChange")
		
		prevPattern = pattern
		lockPattern = false
		loadLaserSpin = false
		
		if(level >= 19 and levelDisplay < 50):
			level = 1
		elif(level >= 29):
			level = 1
		else:
			level += 1
		levelDisplay += 1
		print(level)
		
		if(levelDisplay % 5 == 0):
			player.skillPoints += 1
			pass
		
		repeatPatternAmount = startingAmount + clamp((level - 1), 0, 7)
		
		yield(get_tree().create_timer(2), "timeout")
		
		timer.start()
		pass
	
	pass # Replace with function body.

func spawnMissile():
	rng.randomize()
	var missileShooter_instance = missileShooter.instance()
	var side = rng.randi_range(1,4)
	match(side):
		1: #Bottom
			missileShooter_instance.rotation_degrees = 270
			missileShooter_instance.position.y = 416
			missileShooter_instance.position.x = rng.randi_range(-400, 400)
			pass
		2: #Right
			missileShooter_instance.rotation_degrees = 180
			missileShooter_instance.position.y = rng.randi_range(-250, 250)
			missileShooter_instance.position.x = 736
			pass
		3: #Top
			missileShooter_instance.rotation_degrees = 90
			missileShooter_instance.position.y = -416
			missileShooter_instance.position.x = rng.randi_range(-400, 400)
			pass
		4:#Left
			missileShooter_instance.rotation_degrees = 0
			missileShooter_instance.position.y = rng.randi_range(-250, 250)
			missileShooter_instance.position.x = -736
			pass
	
	add_child(missileShooter_instance)
	pass

func spawnPellet():
	rng.randomize()
	var topOrBottom = rng.randi_range(0,1)
	if(topOrBottom == 0):
		var pelletShooter_instance = pelletShooter.instance()
		var x = rng.randi_range(-400, 400)
		#print(x)
		pelletShooter_instance.position.x = x
		pelletShooter_instance.position.y = -416
		add_child(pelletShooter_instance)
		pass
	elif(topOrBottom == 1):
		var pelletShooter_instance = pelletShooter.instance()
		var x = rng.randi_range(-400, 400)
		#print(x)
		pelletShooter_instance.position.x = x
		pelletShooter_instance.position.y = 416
		add_child(pelletShooter_instance)
		pass
	pass

func _on_Restart_button_down():
	timer.stop()
	level = 1
	levelDisplay = 1
	lockPattern = false
	loadLaserSpin = false
	timer.start()
	pass # Replace with function body.

func _on_MainMenu_button_down():
	animTransition.play("FadeIn")
	yield(animTransition, "animation_finished")
	get_tree().change_scene("res://Scenes/Main Menu.tscn")
	pass # Replace with function body.

