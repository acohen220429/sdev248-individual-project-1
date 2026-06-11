extends Control

@onready var start_button: Button = $VBoxContainer/StartButton

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
