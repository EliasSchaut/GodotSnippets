extends Node2D

@onready var spawn_positions := $SpawnPositions.get_children()
const Enemy := preload("res://scripts/enemy.gd")
const PathEnemy := preload("res://scripts/path_enemy.gd")
const enemy_scene := preload("res://scenes/enemy.tscn")
const path_enemy_scene := preload("res://scenes/path_enemy.tscn")
signal enemy_spawned(enemy_instance: Enemy)
signal path_enemy_spawned(path_enemy_instance: PathEnemy)

func spawn_enemy():
	var random_spawn_position: Marker2D = spawn_positions.pick_random()
	var enemy := enemy_scene.instantiate()
	enemy.global_position = random_spawn_position.global_position
	emit_signal("enemy_spawned", enemy)

func spawn_path_enemy():
	var path_enemy = path_enemy_scene.instantiate()
	emit_signal("path_enemy_spawned", path_enemy)

func _on_enemy_spawn_timeout():
	spawn_enemy()

func _on_path_enemy_spawn_timeout():
	spawn_path_enemy()
