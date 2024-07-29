extends Area2D

@onready var animated_sprite = $Sprite2D

func animate():
	animated_sprite.play("default")

func _on_player_entered(player: Player):
	animate()
