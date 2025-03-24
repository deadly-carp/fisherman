extends Control

func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://credits.tscn")


func _on_play_the_map_pressed() -> void:
	get_tree().change_scene_to_file("res://select.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
