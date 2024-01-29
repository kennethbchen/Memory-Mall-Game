extends Control

@export var animation_time: float = 0.25

@onready var textbox: RichTextLabel = $RichTextLabel

# Position is normalized viewport position (0 - 1)
var original_position: Vector2 = Vector2.ZERO

func _ready():
	visible = false
	EventBus.player_entered_text_info.connect(on_display_text)
	EventBus.player_exited_text_info.connect(on_hide_text)
	original_position = position / get_viewport_rect().size
	on_hide_text()
	
func on_display_text(text: String):
	textbox.text = text
	make_visible()
	
func on_hide_text():
	make_hidden()

func make_visible():
	visible = true
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "position", original_position * get_viewport_rect().size, animation_time)
	
func make_hidden():
	
	get_rect()
	var hide_position = original_position * get_viewport_rect().size + Vector2(0, get_viewport_rect().size.y * 0.4)
	print(hide_position)
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "position", hide_position, animation_time)
	t.finished.connect(func():
		textbox.text = ""
		visible = false
	)
