class_name Enemy
extends CharacterBody3D

@export var speed = 10
@export var playerPath = NodePath()

@onready var _sprite_3d = $Pivot/PlayerSprite
@onready var _animation_tree: AnimationTree = $Pivot/AnimationTree
@onready var _player = get_node(playerPath)

var target_velocity = Vector3.ZERO
var distance = Vector3.ZERO
var is_colliding: bool = false

func _physics_process(_delta):
	movement_logic()
	update_animation_parameters()
	
func movement_logic():
	var direction = Vector3.ZERO

	distance = (_player.global_position - global_position)
	
	if distance != Vector3.ZERO:
		direction = distance.normalized()
		
	if direction.x > 0:
		_sprite_3d.set_flip_h(false)
	else:
		_sprite_3d.set_flip_h(true)

	if !is_colliding:
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	else:
		target_velocity = Vector3.ZERO

	velocity = target_velocity
	move_and_slide()

func update_animation_parameters():
		if is_colliding:
			_animation_tree["parameters/conditions/notMoving"] = true
			_animation_tree["parameters/conditions/isMoving"] = false
			
			_animation_tree["parameters/conditions/attacking"] = true
			_animation_tree["parameters/conditions/notAttacking"] = false
		else:
			_animation_tree["parameters/conditions/notMoving"] = false
			_animation_tree["parameters/conditions/isMoving"] = true
			
			_animation_tree["parameters/conditions/attacking"] = false
			_animation_tree["parameters/conditions/notAttacking"] = true

func _on_area_3d_area_entered(area):
	if area.is_in_group("player_trigger"):
		is_colliding = true

func _on_area_3d_area_exited(area):
	if area.is_in_group("player_trigger"):
		is_colliding = false
