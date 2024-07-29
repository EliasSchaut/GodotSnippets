extends Node2D

const Enemy := preload("res://scripts/enemy.gd")
const PathEnemy := preload("res://scripts/path_enemy.gd")
const game_over_screen_scene := preload("res://scenes/game_over_screen.tscn")

@export var lives := 3
@onready var player := $Player
@onready var ui := $UI
@onready var hud := $UI/HUD
@onready var enemy_hit_sound := $EnemyHitSound
@onready var player_took_damage_sound := $PlayerTookDamageSound
var score := 0

func _on_enemy_entered_deathzone(enemy: Enemy):
	enemy.queue_free()

func _on_player_took_damage():
	lives -= 1
	hud.set_lives(lives)
	player_took_damage_sound.play()
	if lives == 0:
		player.die()
		var game_over_screen := game_over_screen_scene.instantiate()
		game_over_screen.set_score(score)
		await get_tree().create_timer(1.5).timeout
		ui.add_child(game_over_screen)

func _on_enemy_died():
	score += 100
	hud.set_score_label(score)
	enemy_hit_sound.play()

func _on_enemy_spawned(enemy: Enemy):
	add_child(enemy)
	enemy.connect("died", _on_enemy_died)


func _on_path_enemy_spawned(path_enemy: PathEnemy):
	add_child(path_enemy)
	path_enemy.enemy.connect("died", _on_enemy_died)
