extends Control

func _on_main_pressed() -> void:
	get_tree().change_scene_to_file("res://world_environment.tscn")

func _on_beta_pressed() -> void:
	get_tree().change_scene_to_file("res://beta_map.tscn")

func _on_infinite_pressed() -> void:
	get_tree().change_scene_to_file("res://infi_mode.tscn")
