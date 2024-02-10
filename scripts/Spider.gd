extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 10
@export var playerPath = NodePath()

@onready var _sprite_2d = $Pivot/PlayerSprite
@onready var _animation_tree: AnimationTree = $Pivot/AnimationTree
@onready var _player = get_node(playerPath)

var target_velocity = Vector3.ZERO
var distance = Vector3.ZERO
var isClose: bool = false

func flip_sprites_h(value: bool):
	_sprite_2d.set_flip_h(value)

func _physics_process(_delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	distance = (_player.global_position - global_position)
	
	isClose = distance.abs().x < 9 and distance.abs().z < 5
	
	if distance != Vector3.ZERO:
		direction = distance.normalized()
		
	if direction.x > 0:
		flip_sprites_h(false)
	else:
		flip_sprites_h(true)

	if !isClose:
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	else:
		target_velocity = Vector3.ZERO

	# Moving the Character
	velocity = target_velocity
	move_and_slide()
	
	update_animation_parameters()

func update_animation_parameters():
		if isClose:
			_animation_tree["parameters/conditions/notMoving"] = true
			_animation_tree["parameters/conditions/isMoving"] = false
			
			_animation_tree["parameters/conditions/attacking"] = true
			_animation_tree["parameters/conditions/notAttacking"] = false
		else:
			_animation_tree["parameters/conditions/notMoving"] = false
			_animation_tree["parameters/conditions/isMoving"] = true
			
			_animation_tree["parameters/conditions/attacking"] = false
			_animation_tree["parameters/conditions/notAttacking"] = true
