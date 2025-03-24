extends Node3D

@onready var fish = preload("res://fish_1.tscn")

func _on_timer_timeout() -> void:
	var fish_spawn = fish.instantiate()
	add_child(fish_spawn)
