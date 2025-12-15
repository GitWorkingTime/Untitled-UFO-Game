extends TextureRect

onready var player = get_node("/root/World/Player")
onready var size = 12


func _physics_process(delta):
	self.rect_size.x = player.health * size
	if(player.health <= 0):
		self.visible = false
		pass
	elif(player.health > 0):
		self.visible = true
		pass
	pass

