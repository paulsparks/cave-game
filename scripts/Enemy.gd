class_name Enemy
extends SpriteCharacterBody3D

@export var speed = 10
@export var playerPath = NodePath()

@onready var sprite_3d = $Pivot/EnemySprite
@onready var animation_player: AnimationPlayer = $Pivot/AnimationPlayer
@onready var player = get_node(playerPath)
@onready var attack_trigger_shape = $EnemyAttackTrigger/CollisionShape3D
@onready var collision_shape = $EnemyCollisions

var target_velocity = Vector3.ZERO
var distance = Vector3.ZERO
var is_colliding: bool = false

func _physics_process(_delta):
	movement_logic()
	
func movement_logic():
	var direction = Vector3.ZERO

	distance = (player.global_position - global_position)
	
	if distance != Vector3.ZERO:
		direction = distance.normalized()
		
	if direction.x > 0:
		flip_entities([attack_trigger_shape, collision_shape], [sprite_3d], false)
	else:
		flip_entities([attack_trigger_shape, collision_shape], [sprite_3d], true)

	if !is_colliding:
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	else:
		target_velocity = Vector3.ZERO
		
	if is_colliding:
		animation_player.play("attack")
	else:
		animation_player.play("walk")

	velocity = target_velocity
	move_and_slide()

func _on_area_3d_area_entered(area):
	if area.is_in_group("player_trigger"):
		is_colliding = true

func _on_area_3d_area_exited(area):
	if area.is_in_group("player_trigger"):
		is_colliding = false
