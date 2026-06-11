extends Sprite2D

func _ready() -> void:
	var tween = create_tween()
	
	var target_up_position = global_position + Vector2(0, -32)
	tween.tween_property(self, "global_position", target_up_position, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	var target_down_position = target_up_position + Vector2(0, 8)
	tween.tween_property(self, "global_position", target_down_position, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	tween.tween_callback(queue_free)
