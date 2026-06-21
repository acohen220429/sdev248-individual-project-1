extends CharacterBody2D

const SPEED = 250.0
var direction = 1
var lifetime = 1.5

func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	velocity.x = direction * SPEED
	
	var collided = move_and_slide()
	if collided:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			if collider.name.begins_with("Enemy") and "is_squished" in collider and not collider.is_squished:
				collider.queue_free()
				queue_free()
				return
		
		if is_on_wall():
			queue_free()
