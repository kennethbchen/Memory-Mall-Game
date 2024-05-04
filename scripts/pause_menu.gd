extends NinePatchRect


@export var wiggle_post_process_material: ShaderMaterial

@export var wiggle_outline_materials: Array[ShaderMaterial]

signal pause_menu_opened()
signal pause_menu_closed()

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_pause_menu()
	
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
		print(name, " ", AudioServer.get_bus_volume_db(AudioServer.get_bus_index(name)))
	
	if name == "Wiggle":
		
		"""
		for mat in wiggle_outline_materials:
			mat.set_shader_parameter("noise_sensitivity", remap(value, 0, 100, 0, 0.05))
		"""
		
		var wiggle_range = remap(value, 0, 100, 0, 0.007)
		wiggle_post_process_material.set_shader_parameter("wiggle_range", Vector2(wiggle_range, wiggle_range) )
		
		print(name, " ", value)
