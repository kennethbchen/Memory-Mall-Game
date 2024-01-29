extends Control

@onready var textbox: RichTextLabel = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.player_entered_text_info.connect(on_display_text)
	EventBus.player_exited_text_info.connect(on_hide_text)
	on_hide_text()
	
func on_display_text(text: String):
	textbox.text = text
	visible = true
	
func on_hide_text():
	textbox.text = ""
	visible = false
