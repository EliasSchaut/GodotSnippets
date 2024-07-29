extends CharacterBody2D

const SPEED := 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * SPEED * delta * 1000
	move_and_slide()
