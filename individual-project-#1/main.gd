extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.update_hud()


func _on_death_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameManager.lose_life()


func _on_goal_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().change_scene_to_file("res://ending_screen.tscn")
