extends Area3D

@export var text: String = "Placeholder Text"

var visited: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body: Node3D):
	visited = true
	EventBus.player_entered_text_info.emit(text)

func _on_body_exited(body: Node3D):
	EventBus.player_exited_text_info.emit()
