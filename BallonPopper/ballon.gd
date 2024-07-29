extends Area3D

@export var clicks_to_pop := 3
@export var scale_per_click := 0.2
@export var score_to_give := 1

func _on_input_event(camera, event, position, normal, shape_idx):
	if (event is InputEventMouseButton 
	and event.button_index == MOUSE_BUTTON_LEFT
	and event.pressed):
		clicks_to_pop -= 1
		if clicks_to_pop == 0:
			get_parent().inc_score(score_to_give)
			queue_free()
		else:
			scale += Vector3.ONE * scale_per_click
