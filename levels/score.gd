extends Label

onready var score = get_parent().get_parent().get_parent().get_node("LevelManager")

func _process(delta):
	self.text = "SCORE: " + str(score.levelDisplay)
	
	pass

