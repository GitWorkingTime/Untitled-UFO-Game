extends Label

onready var levelCounter = get_node("/root/World/LevelManager")

func _process(delta):
	self.text = "LEVEL: " + str(levelCounter.levelDisplay)
	pass

