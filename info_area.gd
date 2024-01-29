extends Area3D

@export var text: String = ""

var visited: bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	

func _on_body_entered(body: Node3D):
	print(body)
	visited = true

func _on_body_exited(body: Node3D):
	print("exit")
