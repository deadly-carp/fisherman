extends Node3D

enum {
	IDLE,
	ALERT,
}

var state = IDLE
var target 

const TURN_SPEED = 1.5
const SPEED = 3
const BULLET = preload("res://bullet.tscn")

@onready var eyes = $eyes
@onready var shoot_timer = $shoot_timer
@onready var check_timer = $check_timer
@onready var raycast = $RayCast3D
@onready var sound = $AudioStreamPlayer3D

var health = 10

func _process(_delta):
	if health <= 0:
		sound.play()
		queue_free()
	
	if state == ALERT:
		eyes.look_at(target.global_transform.origin, Vector3.UP)
		rotate_y(deg_to_rad(eyes.rotation.y * TURN_SPEED))

func _on_area_body_entered(body: Node3D):
	if body.is_in_group("player"):
		state = ALERT
		target = body
		shoot_timer.start()

		
func _on_area_body_exited(_body: Node3D):
	state = IDLE
	shoot_timer.stop()

func _on_shoot_timer_timeout():
	if raycast.is_colliding():
		var hit = raycast.get_collider()
		if hit.is_in_group("player"):
			target.player_health -= 25
	shoot_timer.start()
