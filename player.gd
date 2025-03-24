extends CharacterBody3D

const DECEL = 0.25
const ACCEL = 0.25
const SPEED = 8
const JUMP_VELOCITY = 6

@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0)
@export var CAMERA_CONTROLLER : Camera3D
@export var MOUSE_SENSITIVITY : float = 0.5
@export var camera_katana : Camera3D

var melee_damage = 5
var _mouse_input : bool = false
var _rotation_input : float
var _mouse_rotation : Vector3
var _tilt_input : float
var _player_rotation : Vector3
var _camera_rotation : Vector3
var player_health : float = 100

@onready var particle : PackedScene = preload("res://hit_particle.tscn")
@onready var melee_anim = $AnimationPlayer
@onready var hitbox = $cameracontroller/Camera3D/hitbox
@onready var hbar = $cameracontroller/Camera3D/SubViewportContainer/SubViewport/Sprite3D/health_bar
@onready var sound = $AudioStreamPlayer3D2
@onready var hurt = $AudioStreamPlayer3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent):
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if  _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY

func _process(_delta):
	camera_katana.global_transform = CAMERA_CONTROLLER.global_transform

func melee():
	if Input.is_action_just_pressed("attack"):
		if not melee_anim.is_playing():
			melee_anim.play("attack_katana")
			melee_anim.queue("return_katana")
		if melee_anim.current_animation == "attack_katana":
			for body in hitbox.get_overlapping_bodies():
				if body.is_in_group("Enemy"):
					sound.play()
					var particle_two = particle.instantiate() as GPUParticles3D
					get_tree().get_root().add_child(particle_two)
					particle_two.emitting = true
					particle_two.global_position = body.global_position
					body.health -= melee_damage

func _update_camera(delta):
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)
	
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	CAMERA_CONTROLLER.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	_rotation_input = 0.0
	_tilt_input = 0.0

func update_health_bar():
	hbar.value = player_health

func _physics_process(delta: float) -> void:
	
	melee()
	
	check_health()
	
	update_health_bar()
	
	if Input.is_action_pressed("exit"):
		get_tree().quit(0)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY
	
	if Input.is_action_just_pressed("jump") and is_on_wall():
		velocity.y += JUMP_VELOCITY
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	_update_camera(delta)
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "front", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x,direction.x * SPEED, ACCEL)
		velocity.z = lerp(velocity.z,direction.z * SPEED, ACCEL)
	
	else:
		velocity.x = move_toward(velocity.x, 0, DECEL)
		velocity.z = move_toward(velocity.z, 0, DECEL)
	
	move_and_slide()

func check_health():
	if player_health <= 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://death.tscn")
	if player_health == 75:
		hurt.play()
	if player_health == 50:
		hurt.play
	if player_health == 25:
		hurt.play

#lava
func _on_area_3d_body_entered(_body: CharacterBody3D) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://death.tscn")
