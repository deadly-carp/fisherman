extends RayCast3D

@export var speed : float = 40.0

func _on_timer_timeout() -> void:
	queue_free()

func _physics_process(delta: float) -> void:
	position += global_basis * Vector3.MODEL_FRONT * speed * delta
	target_position = Vector3.MODEL_FRONT * speed * delta
	force_raycast_update()
	if is_colliding():
		queue_free()
