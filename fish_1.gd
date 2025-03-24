extends CharacterBody3D

@onready var timer = $Timer
@onready var fish = $"."
@onready var sound = $AudioStreamPlayer3D

const SPEED = 5.0

var health = 15

func _process(_delta):
	if health <= 0:
		sound.play()
		queue_free()

func _physics_process(delta: float) -> void:
	position += global_basis * Vector3.MODEL_FRONT * SPEED * delta

func _on_timer_timeout() -> void:
	rotation.y = randf_range(0, 360)
	timer.start()


func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	rotation.y += 180
	
