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

func _get_visible_position():
	return original_position * get_viewport_rect().size
	
func _get_hide_position():
	return original_position * get_viewport_rect().size + Vector2(0, get_viewport_rect().size.y * 0.4)

func make_visible():
	
	# For consistency of tween
	position = _get_hide_position()
	visible = true
	
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "position", _get_visible_position(), animation_time)
	
func make_hidden():
	
	# For consistency of tween
	position = _get_visible_position()
	
	var t = get_tree().create_tween()
	t.set_ease(Tween.EASE_IN)
	t.set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "position", _get_hide_position(), animation_time)
	t.finished.connect(func():
		textbox.text = ""
		visible = false
	)
