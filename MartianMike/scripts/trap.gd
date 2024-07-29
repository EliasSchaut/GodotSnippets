class_name Trap extends Node2D

signal touched_player(player: Player)

func _on_hitbox_player_entered(player: Player):
	touched_player.emit(player)
