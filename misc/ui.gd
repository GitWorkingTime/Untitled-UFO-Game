extends Panel

onready var abilityText = get_node("AbilityDescriptor/Message")
onready var player = get_parent().get_parent().get_node("Player")
onready var teleRangeButton = get_node("TeleportPanel/UpgradeRange/UpgradeRange_Button")
onready var teleCDButton = get_node("TeleportPanel/UpgradeCooldown/UpgradeCooldown_Button_Teleport")
onready var shieldHealthButton = get_node("ShieldPanel/UpgradeHealth/UpgradeHealth_Button")
onready var shieldCDButton = get_node("ShieldPanel/UpgradeCooldown/UpgradeCooldown_Button_Shield")

func _on_UpgradeRange_Button_mouse_entered(): #Teleport Range Enter
	abilityText.text = "Increase teleport range"
	pass # Replace with function body.

func _on_UpgradeRange_Button_mouse_exited(): #Teleport Range Exit
	abilityText.text = "Hover mouse over upgrade options"
	pass # Replace with function body.

func _on_UpgradeCooldown_Button_Teleport_mouse_entered(): #Teleport Cooldown Enter
	abilityText.text = "Decrease teleport cooldown"
	pass # Replace with function body.

func _on_UpgradeCooldown_Button_Teleport_mouse_exited(): #Teleport Cooldown Exit
	abilityText.text = "Hover mouse over upgrade options"
	pass # Replace with function body.

func _on_UpgradeHealth_Button_mouse_entered(): #Shield Health Enter
	abilityText.text = "Increase shield health"
	pass # Replace with function body.

func _on_UpgradeHealth_Button_mouse_exited(): #Shield Health Exit
	abilityText.text = "Hover mouse over upgrade options"
	pass # Replace with function body.

func _on_UpgradeCooldown_Button_Shield_mouse_entered(): #Shield Cooldown Enter
	abilityText.text = "Decrease shield cooldown"
	pass # Replace with function body.

func _on_UpgradeCooldown_Button_Shield_mouse_exited(): #Shield Cooldown Exit
	abilityText.text = "Hover mouse over upgrade options"
	pass # Replace with function body.

func _process(delta):
	if(player.teleportLevel >= 3):
		teleRangeButton.modulate = Color8(70, 70, 70, 255)
		pass
	
	if(player.teleportCDLvl >= 5):
		teleCDButton.modulate = Color8(70, 70, 70, 255)
		pass
	
	if(player.shieldHealth >= 5):
		shieldHealthButton.modulate = Color8(70, 70, 70, 255)
		pass
	
	if(player.shieldCDLvl >= 5):
		shieldCDButton.modulate = Color8(70, 70, 70, 255)
		pass
	pass

