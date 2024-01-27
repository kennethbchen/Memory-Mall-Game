@tool

extends Node3D

@export_group("Nodes")
@export var camera_path:NodePath
@export var target_path: NodePath

var camera: Camera3D
var target: Node3D

@export_group("Camera Parameters")
@export var position_offset: Vector3
@export var rotation_offset: Vector3

@export var pitch_angle_min: float = -85
@export var pitch_angle_max: float = 10

@export_group("Mouse Parameters")
@export_range(0, 1, 0.1) var x_sensitivity: float = 1
@export_range(0, 1, 0.1) var y_sensitivity: float = 1

var mouse_locked: bool = false

func _ready():
	pass

func _unhandled_input(event: InputEvent):
	
	if event.is_action_pressed("game_lock_mouse") and not mouse_locked:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		mouse_locked = true
	
	if event.is_action_pressed("game_release_mouse") and mouse_locked:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		mouse_locked = false
		
	if event is InputEventMouseMotion and not Engine.is_editor_hint() and mouse_locked:
		
		# Yaw
		rotation_degrees.y += -event.relative.x * x_sensitivity
		
		# Pitch
		rotation_degrees.x += -event.relative.y * y_sensitivity
		
		rotation_degrees.x = clamp(rotation_degrees.x, pitch_angle_min, pitch_angle_max)


func _process(delta):
	
	if not camera:
		assert(camera_path, "Camera Not Found")
		
		camera = get_node(camera_path)
		
		assert(camera.get_parent() == self)
	if not target:
		assert(target_path, "Camera Target Not Found")
		target = get_node(target_path)
	
	position = target.position + position_offset

