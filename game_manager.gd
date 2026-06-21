extends Node

var lives: int = 3
var coins: int = 0

func add_coin() -> void:
	coins += 1
	update_hud()

func reset_game_stats() -> void:
	lives = 3
	coins = 0

func lose_life() -> void:
	lives -= 1
	if lives <= 0:
		reset_game_stats()
		get_tree().change_scene_to_file("res://title_screen.tscn")
	else:
		get_tree().reload_current_scene()

func update_hud() -> void:
	var hud = get_tree().current_scene.get_node_or_null("CanvasLayer/HUD")
	if hud:
		hud.text = "LIVES: %d\nCOINS: %d" % [lives, coins]
