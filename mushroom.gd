extends CharacterBody2D

const SPEED = 60.0
var direction = 1

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = direction * SPEED
	
	move_and_slide()
	
	if is_on_wall():
		direction *= -1


func _on_collection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if body.has_method("become_big"):
			body.become_big()
		queue_free()
