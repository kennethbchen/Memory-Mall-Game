extends NinePatchRect


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
