extends Area2D

@export var speed = 300
const Player = preload("res://scripts/player.gd")
signal died

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	global_position.x -= speed * delta

func die():
	emit_signal("died")
	queue_free()

func _on_player_entered(player: Player):
	player.take_damage()
	die()
