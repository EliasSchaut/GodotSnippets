extends Area2D

func _ready():
	var sprite := $Sprite2D
	sprite.play()

func _on_body_entered(body):
	body.scale *= 1.1
	queue_free()
