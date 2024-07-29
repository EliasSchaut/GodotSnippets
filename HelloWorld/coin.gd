extends Area2D

func _on_body_entered(body: CharacterBody2D):
	body.scale *= 1.1
	queue_free()
