extends Node

@export var start_button: Button

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta):
	
	# Hack fix because mouse is locked in title screen when it shouldn't
	if get_tree().paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_start_pressed():
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	start_button.hide()
