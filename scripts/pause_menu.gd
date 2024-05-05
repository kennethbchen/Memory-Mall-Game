extends NinePatchRect


@export var default_theme: Theme
@export var player: CharacterBody3D

@export var teleport_button_parent: Control

@export_subgroup("Wiggle")
@export var wiggle_post_process_material: ShaderMaterial
@export var wiggle_outline_materials: Array[ShaderMaterial]

signal pause_menu_opened()
signal pause_menu_closed()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_pause_menu()
	
	for node in get_tree().get_nodes_in_group("info_area"):
		
		# Create new button for pause menu
		var new_button = Button.new()
		new_button.text = node.name
		teleport_button_parent.add_child(new_button)
		new_button.theme = default_theme
		
		var on_press = func():
			player.teleport_to(node.position + Vector3(0, 0.1, 0))
			hide_pause_menu()

		new_button.pressed.connect(on_press)
		
		# Make info area mark its corresponding button as read
		node.activated.connect(_set_teleport_button_read.bind(new_button))
	
func _unhandled_input(event):
	
	if event.is_action_pressed("game_pause") and not visible:
		show_pause_menu()
		
	elif event.is_action_pressed("game_pause") and visible:
		hide_pause_menu()
		

func show_pause_menu():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()
		
func hide_pause_menu():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()
	
func on_slider_changed(value: float, name: String):
	
	if name == "Master" or name == "Music" or name == "SFX":
		
		# Slider ranges from 0 to 100
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index(name), remap(value, 0, 100, -30, 0))
	
	if name == "Wiggle":
		
		"""
		for mat in wiggle_outline_materials:
			mat.set_shader_parameter("noise_sensitivity", remap(value, 0, 100, 0, 0.05))
		"""
		
		var wiggle_range = remap(value, 0, 100, 0, 0.007)
		wiggle_post_process_material.set_shader_parameter("wiggle_range", Vector2(wiggle_range, wiggle_range) )

func _set_teleport_button_read(button: Button):
	button.theme_type_variation = "ButtonRead"
