extends Control

func set_score(final_score: int):
	$Panel/Score.text = "SCORE: " + str(final_score)

func _on_retry_button_pressed():
	get_tree().reload_current_scene()
