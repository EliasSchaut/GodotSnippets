extends Node2D

@export var TIME: int = 20
@onready var timer: Timer = $Timer
@onready var timeLeftLabel: Label = $TimeLeftLabel

func _ready():
	timeLeftLabel.text = str(TIME) + 's'

func _on_timer_timeout():
	TIME -= 1
	if (TIME == 0): get_tree().quit()
	timeLeftLabel.text = str(TIME) + 's'

func stop_timer():
	timer.stop()
