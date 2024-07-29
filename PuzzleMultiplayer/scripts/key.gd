class_name Key extends Node2D

@export var follow_offset: Vector2 = Vector2(-50, -80)
@export var lerp_speed = 5
var player: CharacterBody2D

func _process(delta):
	if Lobby.is_server() && player != null:
		global_position = lerp(player.position + follow_offset, global_position, pow(0.5, delta * lerp_speed))

func _on_key_player_entered(body: Player):
	player = body
