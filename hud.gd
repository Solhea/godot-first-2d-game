extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	
	await $MessageTimer.timeout
	
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)

func update_high_score(high_score: int) -> void:
	var high_score_label: String = "-"

	if high_score > 0:
		high_score_label = str(high_score)

	$HighScore.text = "High Score: " + high_score_label

func show_high_score(visible_temp: bool):
	if visible_temp:
		$NewHighScoreLabel.show()
	else:
		$NewHighScoreLabel.hide()

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()
