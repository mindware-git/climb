extends Node2D

var score := 0

func _on_timer_timeout() -> void:
	score += 1
	$CanvasLayer/ScoreLabel.text = "Score: %d" % score
