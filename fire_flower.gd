extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
	var tween = create_tween()
	var target_pos = global_position + Vector2(0,-16)
	tween.tween_property(self, "global_position", target_pos, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.has_method("become_fire_player"):
			body.become_fire_player()
		queue_free()
