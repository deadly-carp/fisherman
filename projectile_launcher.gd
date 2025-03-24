extends Node3D

const BULLET = preload("res://bullet.tscn")
@onready var raycast = $"../RayCast3D"

func _on_shoot_timer_timeout() -> void:
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit.is_in_group("player"):
			var bang = BULLET.instantiate()
			add_child(bang)
			bang.global_transform = global_transform
