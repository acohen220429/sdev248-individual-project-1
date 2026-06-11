extends CharacterBody2D

const SPEED = 50.0
var direction = -1
var is_squished = false
var is_awake = false

func _physics_process(delta: float) -> void:
	if is_squished or not is_awake:
		return
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = direction * SPEED
	
	move_and_slide()
	
	if is_on_wall():
		direction *= -1

func squish() -> void:
	is_squished = true
	velocity = Vector2.ZERO
	
	collision_layer = 0
	collision_mask = 0
	
	$CollisionShape2D.queue_free()
	$HeadDetector/CollisionShape2D.queue_free()
	
	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale:y", 0.1, 0.15)
	tween.tween_property($Sprite2D, "position:y", 7.0, 0.15)
	
	await get_tree().create_timer(0.5).timeout
	queue_free()


func _on_head_detector_body_entered(body: Node2D) -> void:
	if is_squished:
		return
	
	if body.name == "Player":
		body.velocity.y = body.JUMP_VELOCITY * 0.6
		squish()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_awake = true
