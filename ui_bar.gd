class_name UiBar
extends Node


signal new_game

var score_string = "Score: %s"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_score(score: int = 0) -> void:
	$ScoreLabel.text = score_string % score


func _on_new_game_button_pressed() -> void:
	new_game.emit()
