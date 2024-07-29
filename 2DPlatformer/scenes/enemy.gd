extends Area2D

@export var move_speed := 30.0
@export var move_dir := Vector2(0, -50)
@onready var SPRITE: Sprite2D = $Sprite

@onready var start_pos := global_position
@onready var target_pos := start_pos + move_dir

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position.move_toward(target_pos, move_speed * delta)

	if global_position == target_pos:
		if global_position == start_pos:
			target_pos = start_pos + move_dir
		else:
			target_pos = start_pos

func _on_frame_timer_timeout():
	SPRITE.frame_coords.x = (SPRITE.frame_coords.x + 1) % SPRITE.hframes
