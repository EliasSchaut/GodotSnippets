extends RigidBody3D

@export var move_speed := 5.0

func _physics_process(delta):
	var input = Input.get_axis("ui_left", "ui_right")
	linear_velocity.x = input * move_speed


func _on_body_entered(body):
	print("lol")
	if body.is_in_group("Tree"):
		get_tree().reload_current_scene()
