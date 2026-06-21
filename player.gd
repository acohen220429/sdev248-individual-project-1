extends CharacterBody2D
const MUSHROOM_SCENE = preload("res://mushroom.tscn")
const FIREBALL_SCENE = preload("res://fireball.tscn")
var is_big: bool = false
var is_fire: bool = false
var knockback_timer: float = 0.0

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var ceiling_detector_shape: CollisionShape2D = $CeilingDetector/CollisionShape2D
@onready var stomp_detector_shape: CollisionShape2D = $StompDetector/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	if not is_big:
		become_small()

func become_small() -> void:
	is_big = false
	sprite.scale.y = 0.5
	sprite.position.y = 8
	
	sprite.self_modulate = Color.WHITE
	
	collision_shape.shape.size.y = 15.75
	collision_shape.position.y = 7.125
	
	ceiling_detector_shape.position.y = -0.75
	
	stomp_detector_shape.position.y = 15.5

func become_big() -> void:
	is_big = true
	sprite.scale.y = 1.0
	sprite.position.y = 0
	
	sprite.self_modulate = Color.WHITE 

	collision_shape.shape.size.y = 31.5
	collision_shape.position.y = -0.75
	
	ceiling_detector_shape.position.y = -17
	
	stomp_detector_shape.position.y = 15.5

func become_fire_player() -> void:
	if not is_big:
		become_big()
	
	is_fire = true
	sprite.self_modulate = Color(1.0, 0.6, 0.2, 1.0)


func _physics_process(delta: float) -> void:
	if knockback_timer > 0.0:
		knockback_timer -= delta
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and knockback_timer <= 0.0:
		velocity.y = JUMP_VELOCITY
	
	var direction: float = 0.0
	if knockback_timer <= 0.0:
		direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if direction > 0:
			sprite.scale.x = 1.0
		elif direction < 0:
			sprite.scale.x = -1.0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("shoot") and is_fire:
		shoot_fireball()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.name.begins_with("Enemy") and "is_squished" in collider and not collider.is_squished:
			var normal = collision.get_normal()
			if normal.dot(Vector2.UP):
				continue
			handle_player_damage(collision)


func _on_ceiling_detector_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		var check_distance = 20 if is_big else 4
		var tile_position = body.local_to_map(global_position + (Vector2.UP * check_distance))
		var cell_source_id = body.get_cell_source_id(tile_position)
		var cell_atlas_coords = body.get_cell_atlas_coords(tile_position)
		var cell_alternative_id = body.get_cell_alternative_tile(tile_position)
		
		if cell_source_id != -1:
			if cell_atlas_coords == Vector2i(1,0):
				if is_big:
					body.set_cell(tile_position, -1)
			
			elif cell_atlas_coords == Vector2i(2,0):
				body.set_cell(tile_position, cell_source_id, Vector2i(1,1))
				if cell_alternative_id == 1:
					var mushroom_instance = MUSHROOM_SCENE.instantiate()
					mushroom_instance.global_position = body.map_to_local(tile_position) + Vector2(0,-16)
					body.get_parent().add_child(mushroom_instance)
				elif cell_alternative_id == 2:
					var flower_scene = preload("res://fire_flower.tscn")
					var flower_instance = flower_scene.instantiate()
					flower_instance.global_position = body.map_to_local(tile_position)
					body.get_parent().add_child(flower_instance)
				else:
					GameManager.add_coin()
					var coin_instance = Sprite2D.new()
					coin_instance.texture = preload("res://mario1_1sprites/coin.png")
					coin_instance.global_position = body.map_to_local(tile_position)
					coin_instance.set_script(preload("res://coin_pickup.gd"))
					body.get_parent().add_child(coin_instance)
					
					
				


func _on_stomp_detector_area_entered(area: Area2D) -> void:
	if area.name == "HeadDetector":
		var enemy = area.get_parent()
		if "is_squished" in enemy and not enemy.is_squished:
			enemy.squish()
			velocity.y = JUMP_VELOCITY * 0.6

func handle_player_damage(collision: KinematicCollision2D) -> void:
	var push_direction = collision.get_normal().x
	
	if push_direction == 0:
		push_direction = -1.0 if sprite.scale.x > 0 else 1.0
	if is_fire:
		is_fire = false
		become_big()
		knockback_timer = 0.2
		velocity.x = push_direction * 200.0
		velocity.y = -200.0
	elif is_big:
		become_small()
		knockback_timer = 0.2
		velocity.x = push_direction * 200.0
		velocity.y = -200.0
	else:
		GameManager.lose_life()

func shoot_fireball() -> void:
	var fireball = FIREBALL_SCENE.instantiate()
	
	var facing_direction = 1
	if sprite.scale.x < 0:
		facing_direction = -1
	fireball.direction = facing_direction
	
	fireball.global_position = global_position + Vector2(facing_direction * 10, 0)
	
	get_parent().add_child(fireball)
	
