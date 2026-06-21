extends Control

@onready var result_label: Label = $VBoxContainer/ResultLabel
@onready var restart_button: Button = $VBoxContainer/RestartButton

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	result_label.custom_minimum_size = Vector2(240, 0)
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	if GameManager.coins >= 5:
		result_label.text = "YOU WIN!\n\nYou collected %d coins and successfully paid off the legal fees! Nintendo dropped the lawsuit. We're saved!!" % GameManager.coins
	else:
		result_label.text = "YOU LOSE...\n\nYou only managed to find %d coins. Nintendo is going to bankrupt us at this point..." % GameManager.coins

func _on_restart_button_pressed() -> void:
	GameManager.reset_game_stats()
	get_tree().change_scene_to_file("res://title_screen.tscn")
