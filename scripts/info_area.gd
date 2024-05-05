extends Area3D

@export_multiline var text: String = "Placeholder Text"

signal activated()

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node3D):
	EventBus.player_entered_text_info.emit(text)
	activated.emit()

func _on_body_exited(body: Node3D):
	EventBus.player_exited_text_info.emit()
