extends Control

func _on_given_up_pressed() -> void:
	get_tree().quit(0)

func _on_try_again_pressed() -> void:
	get_tree().change_scene_to_file("res://world_environment.tscn")
