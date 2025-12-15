extends RigidBody2D




func _on_Area2D_body_entered(body):
	
	if(body.is_in_group("player")):
		if(body.get_node("CollisionDetection/CollisionDetector").disabled == true):
			queue_free()
			pass
		
		pass
	
	
	if(body.is_in_group("walls")):
		queue_free()
	
	pass # Replace with function body.

