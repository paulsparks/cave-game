extends CharacterBody3D

@export var speed = 30

@onready var _sprite_3d = $Pivot/PlayerSprite
@onready var _animation_tree: AnimationTree = $Pivot/AnimationTree
@onready var _on_hand_sprite = $Pivot/OnHandSprite

var target_velocity = Vector3.ZERO

func flip_sprites_h(value: bool):
	_sprite_3d.set_flip_h(value)
	_on_hand_sprite.set_flip_h(value)

func _physics_process(_delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
		flip_sprites_h(false)
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		flip_sprites_h(true)
	if Input.is_action_pressed("move_down"):
		direction.z += 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	velocity = target_velocity
	move_and_slide()
	
	update_animation_parameters()

func update_animation_parameters():
		if velocity.x == 0 and velocity.z == 0:
			_animation_tree["parameters/conditions/notMoving"] = true
			_animation_tree["parameters/conditions/isMoving"] = false
		else:
			_animation_tree["parameters/conditions/notMoving"] = false
			_animation_tree["parameters/conditions/isMoving"] = true
			
		if Input.is_action_just_pressed("attack"):
			_animation_tree["parameters/conditions/swingSword"] = true
			_animation_tree["parameters/conditions/notSwingSword"] = false
		else:
			_animation_tree["parameters/conditions/swingSword"] = false
			_animation_tree["parameters/conditions/notSwingSword"] = true
