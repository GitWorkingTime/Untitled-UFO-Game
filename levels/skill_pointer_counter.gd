extends Label

onready var SP = get_node("/root/World/Player")

func _process(delta):
	
	self.text = str(SP.skillPoints)
	
	pass

