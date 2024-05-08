extends Node


@export var first_footstep_delay_sec: float = 0.2

@export var footstep_interval_sec: float = 0.5

@export var fast_footstep_interval_sec: float = 0.25

@export var sfx_controller: SoundEffectController

var player: Player

var footstep_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	player = get_parent()
	
	footstep_timer = Timer.new()
	add_child(footstep_timer)
	
	footstep_timer.wait_time = footstep_interval_sec
	footstep_timer.one_shot = true
	footstep_timer.timeout.connect(_on_footstep_timer_timeout)
	footstep_timer.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if player.moving and footstep_timer.is_stopped():
		footstep_timer.start(first_footstep_delay_sec)

	elif not player.moving and not footstep_timer.is_stopped():
		footstep_timer.stop()

func _on_footstep_timer_timeout():
	
	var next_footstep_time = fast_footstep_interval_sec if player.running else footstep_interval_sec

	footstep_timer.start(next_footstep_time)
	
	sfx_controller.play("footstep")


