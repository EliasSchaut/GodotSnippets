extends CharacterBody2D

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -200.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var SPRITE: Sprite2D = $Sprite

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if direction > 0:
			SPRITE.frame_coords.y = 2
		else:
			SPRITE.frame_coords.y = 1
		velocity.x = direction * SPEED
	else:
		SPRITE.frame_coords.y = 0
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if global_position.y > 200:
		game_over()

func game_over():
	get_tree().reload_current_scene()


func _on_frame_timer_timeout():
	SPRITE.frame_coords.x = (SPRITE.frame_coords.x + 1) % SPRITE.hframes
