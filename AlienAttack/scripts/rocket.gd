extends Area2D

const Enemy = preload("res://scripts/enemy.gd")
@export var speed = 600

func _physics_process(delta):
	global_position.x += speed * delta

func _on_enemy_entered(enemy: Enemy):
	enemy.die()
	die()

func die():
	queue_free()

func _on_screen_exited():
	die()

