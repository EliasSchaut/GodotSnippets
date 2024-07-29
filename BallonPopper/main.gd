extends Node3D

var score := 0
@onready var score_label: Label = $ScoreLabel

func inc_score(amount: int):
	score += amount
	score_label.text = str("Score: ", score)
