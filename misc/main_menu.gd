extends Node2D

onready var anim = get_node("Transition/AnimationPlayer")
onready var tutorial = get_node("UI/TutorialPanel")

func _on_Play_Game_button_down():
	anim.play("FadeIn")
	yield(anim, "animation_finished")
	get_tree().change_scene("res://Scenes/World.tscn")
	pass # Replace with function body.

func _on_HowToPlay_button_down():
	tutorial.show()
	pass # Replace with function body.

func _on_Return_button_down():
	tutorial.hide()
	pass # Replace with function body.

