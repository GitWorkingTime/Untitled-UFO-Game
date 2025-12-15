extends KinematicBody2D

signal healthUpdated(new_value)

#Movement configuration
var motion = Vector2()
export var maxSpeed = 200
export var acceleration = 2000
export var health = 5 setget setHealth
func setHealth(new_value:int) -> void:
	health -= new_value
	emit_signal("healthUpdated", health)
	#print("health change")
	pass

onready var anim = $FlashPlayer
export onready var collisionDetection = get_node("CollisionDetection")

#Abilities
var typeOfAbilities = 1 # 1 == teleport, 2 == shield
export var skillPoints = 10
var isUsingAbilities = false

#For the teleport
var teleportUnlocked = false
onready var slowDownTime = false
onready var crosshair = get_node("CrosshairNode")
export var teleportLevel = 1
onready var teleportLevelCounter = 
get_parent().get_node("UI/AbilityPanel/TeleportPanel/UpgradeRange/UpgradeProgress")
var teleportCooldown = 5
export var teleportCDLvl = 1
onready var teleportCDLvlCounter = 
get_parent().get_node("UI/AbilityPanel/TeleportPanel/UpgradeCooldown/UpgradeProgress")
var isTeleportCooldown = false

#For the shield
var shieldUnlocked = false
var shieldHealth = 3
export var shieldLevel = 1
onready var shieldLevelCounter = 
get_parent().get_node("UI/AbilityPanel/ShieldPanel/UpgradeHealth/UpgradeProgress")
onready var shield = get_node("Shield")
onready var isShieldOn = false
export var shieldCooldown = 5
var shieldCDLvl = 1
onready var shieldCDLvlCounter = 
get_parent().get_node("UI/AbilityPanel/ShieldPanel/UpgradeCooldown/UpgradeProgress")
var isShieldCooldown = false

#UI
var isPanelOn = false
onready var abilityPanel = get_parent().get_node("UI/AbilityPanel")
onready var gameOver = get_parent().get_node("UI/GameOver")
var canRestart = false
onready var abilitiesTabs = get_parent().get_node("UI/AbilityTabs")


func _physics_process(delta):
	
	#Death State
	if(health <= 0):
		gameOver.visible = true
		if(canRestart == false):
			gameOver.get_node("Restart").disabled = true
			yield(get_tree().create_timer(5), "timeout")
			gameOver.get_node("Restart").disabled = false
			canRestart = true
			pass
		return
	
	#Movement
	var axis = get_axis_input()
	if(axis == Vector2.ZERO):
		apply_friction(acceleration * delta)
	else:
		apply_movement(acceleration * delta * axis)
	
	motion = move_and_slide(motion)
	
	#Opening and closing the power menu
	powerMenu()
	
	#Choosing the type of abilities
	if(Input.is_action_just_pressed("1") and isUsingAbilities == false):
		typeOfAbilities = 1
		get_parent().get_node("UI/AbilityTabs/Teleport").rect_position.y = 793
		get_parent().get_node("UI/AbilityTabs/Shield").rect_position.y = 813
		get_parent().get_node("UI/AbilityTabs/Teleport/button").modulate = Color8(200, 200, 200, 
255)
		yield(get_tree().create_timer(0.15), "timeout")
		get_parent().get_node("UI/AbilityTabs/Teleport/button").modulate = Color8(255, 255, 255, 
255)
		pass
	elif(Input.is_action_just_pressed("2") and isUsingAbilities == false):
		typeOfAbilities = 2
		get_parent().get_node("UI/AbilityTabs/Teleport").rect_position.y = 813
		get_parent().get_node("UI/AbilityTabs/Shield").rect_position.y = 793
		get_parent().get_node("UI/AbilityTabs/Shield/button").modulate = Color8(200, 200, 200, 255)
		yield(get_tree().create_timer(0.15), "timeout")
		get_parent().get_node("UI/AbilityTabs/Shield/button").modulate = Color8(255, 255, 255, 255)
		pass
	
	#Using the abilities
	if(Input.is_action_just_pressed("space")):
		if(shieldUnlocked == false and teleportUnlocked == false):
			return
			pass
		
		if(isTeleportCooldown == true and typeOfAbilities== 1):
			return
			pass
		
		if(shieldHealth <= 0):
			shieldHealth = 3 + (shieldLevel - 1)
			pass
		
		isUsingAbilities = !isUsingAbilities
		pass
	abilities()
	
	if(shieldUnlocked == true):
		get_parent().get_node("UI/AbilityTabs/Shield/button").visible = true
		pass
	
	if(teleportUnlocked == true):
		get_parent().get_node("UI/AbilityTabs/Teleport/button").visible = true
		pass
	
	pass

#Opens and closes power menu
func powerMenu():
	if(Input.is_action_just_pressed("r") and isPanelOn == false):
		abilityPanel.visible = true
		abilitiesTabs.visible = false
		isPanelOn = true
		Engine.time_scale = 0
		pass
	elif(Input.is_action_just_pressed("r") and isPanelOn == true):
		abilityPanel.visible = false
		abilitiesTabs.visible = true
		isPanelOn = false
		Engine.time_scale = 1
		pass
	pass

func abilities():
	if(isUsingAbilities == true):
		if(typeOfAbilities == 1 and teleportUnlocked == true and isTeleportCooldown == false):
			
			
			crosshair.show()
			Engine.time_scale = 0.005
			
			if(Input.is_mouse_button_pressed(1)):
				self.global_position.x = crosshair.global_position.x
				self.global_position.y = crosshair.global_position.y
				motion = Vector2.ZERO
				crosshair.hide()
				isUsingAbilities = false
				isTeleportCooldown = true
				get_parent().get_node("UI/AbilityTabs/Teleport").modulate = Color8(86, 86, 
86, 255)
				yield(get_tree().create_timer(teleportCooldown), "timeout")
				get_parent().get_node("UI/AbilityTabs/Teleport").modulate = Color8(255, 
255, 255, 255)
				isTeleportCooldown = false
				
				pass
			pass
		elif(typeOfAbilities == 2 and shieldUnlocked == true and isShieldCooldown == false):
			shield.show()
			shield.get_node("CollisionShape2D").set_deferred("disabled", false)
			self.get_node("CollisionDetection/CollisionDetector").set_deferred("disabled", 
true)
			
			if(shieldHealth <= 0):
				shield.hide()
				shield.get_node("CollisionShape2D").set_deferred("disabled", true)
				
self.get_node("CollisionDetection/CollisionDetector").set_deferred("disabled", false)
				isUsingAbilities = false
				isShieldCooldown = true
				get_parent().get_node("UI/AbilityTabs/Shield").modulate = Color8(86, 86, 
86, 255)
				yield(get_tree().create_timer(shieldCooldown), "timeout")
				get_parent().get_node("UI/AbilityTabs/Shield").modulate = Color8(255, 255, 
255, 255)
				isShieldCooldown = false
				pass
			
			pass
		pass
	elif(isUsingAbilities == false):
		if(typeOfAbilities == 1):
			crosshair.hide()
			if(isPanelOn == false):
				Engine.time_scale = 1
			pass
		elif(typeOfAbilities == 2):
			shield.hide()
			shield.get_node("CollisionShape2D").set_deferred("disabled", true)
			self.get_node("CollisionDetection/CollisionDetector").set_deferred("disabled", 
false)
			pass
		pass
	pass

#Movement
func get_axis_input():
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("Right")) - int(Input.is_action_pressed("Left"))
	axis.y = int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))
	return axis.normalized()
	pass

func apply_friction(amount):
	if motion.length() > amount:
		motion -= motion.normalized() * amount
	else:
		motion = Vector2.ZERO
		pass
	pass

func apply_movement(acceleration):
	motion += acceleration
	motion = motion.clamped(maxSpeed)
	pass

func _on_Shield2_body_entered(body):
	if(body.is_in_group("projectile")):
		shieldHealth -= 1
		body.queue_free()
	
	pass # Replace with function body.

#Response to damage
func _on_Player_healthUpdated(new_value):
	
	anim.play("Flash")
	self.get_node("CollisionDetection/CollisionDetector").set_deferred("disabled", true)
	
	yield(anim, "animation_finished")
	
	self.get_node("CollisionDetection/CollisionDetector").set_deferred("disabled", false)
	
	pass # Replace with function body.

#Obstacle detection
func _on_CollisionDetection_body_entered(body):
	
	if(body.is_in_group("projectile")):
		body.queue_free()
		setHealth(1)
		pass
	
	pass # Replace with function body.

func _on_CollisionDetection_area_entered(area):
	
	if(area.is_in_group("Laser")):
		setHealth(1)
		pass
	
	if(area.is_in_group("Missile")):
		setHealth(1)
		pass
	
	if(area.is_in_group("Inflate")):
		setHealth(1)
		pass
	
	if(area.is_in_group("WallSmasher")):
		setHealth(1)
		pass
	pass # Replace with function body.

#Restart the game
func _on_Restart_button_down():
	health = 5
	motion = Vector2.ZERO
	self.position.x = 0
	self.position.y = 0
	gameOver.visible = false
	canRestart = false
	pass # Replace with function body.

#Unlock teleport
func _on_Teleport_button_down():
	if(skillPoints > 0):
		skillPoints -= 1
		teleportUnlocked = true
		get_parent().get_node("UI/AbilityPanel/TeleportPanel/TeleportUnlock").visible = false
		get_parent().get_node("UI/AbilityPanel/TeleportPanel/TeleportCover").visible = false
		
		get_parent().get_node("UI/AbilityTabs/Teleport").modulate = Color8(255, 255, 255, 255)
		get_parent().get_node("UI/AbilityPanel/TeleportPanel/UpgradeRange").visible = true
		get_parent().get_node("UI/AbilityPanel/TeleportPanel/UpgradeCooldown").visible = true
		
		pass
	pass # Replace with function body.

#Unlock shield
func _on_Shield_button_down():
	if(skillPoints > 0):
		skillPoints -= 1
		shieldUnlocked = true
		get_parent().get_node("UI/AbilityPanel/ShieldPanel/ShieldUnlock").visible = false
		get_parent().get_node("UI/AbilityPanel/ShieldPanel/ShieldCover").visible = false
		
		get_parent().get_node("UI/AbilityTabs/Shield").modulate = Color8(255, 255, 255, 255)
		get_parent().get_node("UI/AbilityPanel/ShieldPanel/UpgradeHealth").visible = true
		get_parent().get_node("UI/AbilityPanel/ShieldPanel/UpgradeCooldown").visible = true
		
		pass
	pass # Replace with function body.

func _on_UpgradeRange_Button_button_down():
	if(skillPoints <= 0):
		return
		pass
	#Max level
	if(teleportLevel >= 3):
		return
		pass
	skillPoints -= 1
	teleportLevel += 1
	teleportLevelCounter.text = "LEVEL: " + str(teleportLevel)
	pass # Replace with function body.

func _on_Shield_area_entered(area):
	if(area.is_in_group("Laser") or area.is_in_group("Missile") or area.is_in_group("Inflate")):
		shieldHealth -= 1
	pass # Replace with function body.

func _on_UpgradeHealth_Button_button_down():
	if(skillPoints <= 0):
		return
		pass
	#Max level
	if(shieldLevel >= 5):
		return
		pass
	skillPoints -= 1
	shieldLevel += 1
	shieldLevelCounter.text = "LEVEL: " + str(shieldLevel)
	pass # Replace with function body.

#Add a cooldown upgrade because the abilities will have a cooldown on them
func _on_UpgradeCooldown_Button_Teleport_button_down(): #For Teleport Cooldown
	if(skillPoints <= 0):
		return
		pass
	if(teleportCDLvl >= 5):
		return
		pass
	skillPoints -= 1
	teleportCDLvl += 1
	teleportCooldown = clamp(teleportCooldown - ((teleportCDLvl - 1) * 0.8), 1, 5)
	teleportCDLvlCounter.text = "LEVEL: " + str(teleportCDLvl)
	pass # Replace with function body.

func _on_UpgradeCooldown_Button_Shield_button_down(): #For Shield Cooldown
	if(skillPoints <= 0):
		return
		pass
	if(shieldCDLvl >= 5):
		return
		pass
	skillPoints -= 1
	shieldCDLvl += 1
	shieldCooldown = clamp(shieldCooldown - ((shieldCDLvl - 1) * 0.8), 1, 5)
	shieldCDLvlCounter.text = "LEVEL: " + str(shieldCDLvl)
	pass # Replace with function body.

func _on_Reset_button_down(): #Reset and return skill points
	var sum = 0
	var SPTeleportRange = teleportLevel - 1
	var SPTeleportCooldown = teleportCDLvl - 1
	var SPShieldHealth = shieldLevel - 1
	var SPShieldCooldown = shieldCDLvl - 1
	sum = SPTeleportRange + SPTeleportCooldown + SPShieldHealth + SPShieldCooldown
	if(teleportUnlocked == true):
		sum += 1
		pass
	if(shieldUnlocked == true):
		sum += 1
		pass
	
	#Return SP
	skillPoints += sum
	
	#Reset back to start
	teleportLevel = 1
	teleportCDLvl = 1
	shieldLevel = 1
	shieldCDLvl = 1
	
	#Reset Teleport panel
	get_parent().get_node("UI/AbilityPanel/TeleportPanel/UpgradeCooldown").hide()
	get_parent().get_node("UI/AbilityPanel/TeleportPanel/UpgradeRange").hide()
	get_parent().get_node("UI/AbilityPanel/TeleportPanel/TeleportCover").show()
	get_parent().get_node("UI/AbilityPanel/TeleportPanel/TeleportUnlock").show()
	
	#Reset shield panel
	get_parent().get_node("UI/AbilityPanel/ShieldPanel/UpgradeCooldown").hide()
	get_parent().get_node("UI/AbilityPanel/ShieldPanel/UpgradeHealth").hide()
	get_parent().get_node("UI/AbilityPanel/ShieldPanel/ShieldCover").show()
	get_parent().get_node("UI/AbilityPanel/ShieldPanel/ShieldUnlock").show()
	
	#Reset level counters
	teleportCDLvlCounter.text = "LEVEL: " + str(teleportCDLvl)
	teleportLevelCounter.text = "LEVEL: " + str(teleportLevel)
	shieldCDLvlCounter.text = "LEVEL: " + str(shieldCDLvl)
	shieldLevelCounter.text = "LEVEL: " + str(shieldLevel)
	
	#Reset unlock
	teleportUnlocked = false
	shieldUnlocked = false
	
	#Reset ability tabs
	get_parent().get_node("UI/AbilityTabs/Teleport").modulate = Color8(86, 86, 86, 255)
	get_parent().get_node("UI/AbilityTabs/Teleport/button").hide()
	get_parent().get_node("UI/AbilityTabs/Teleport").rect_position.y = 813
	get_parent().get_node("UI/AbilityTabs/Shield").modulate = Color8(86, 86, 86, 255)
	get_parent().get_node("UI/AbilityTabs/Shield/button").hide()
	get_parent().get_node("UI/AbilityTabs/Shield").rect_position.y = 813
	
	#Turn off ability use
	isUsingAbilities = false
	pass # Replace with function body.

