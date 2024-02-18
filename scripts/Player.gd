extends CharacterBody3D

@export var speed = 30

@onready var sprite_3d = $PlayerSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon_sprite_3d: Node3D = $StarterSword/WeaponSprite
@onready var weapon_attack_collider_shape: Node3D = $StarterSword/Hitbox/CollisionShape3D

var target_velocity = Vector3.ZERO
var entity_interface: EntityInterface = EntityInterface.new()

func _physics_process(_delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
		entity_interface.flip_entity([weapon_attack_collider_shape], [sprite_3d, weapon_sprite_3d], false)
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		entity_interface.flip_entity([weapon_attack_collider_shape], [sprite_3d, weapon_sprite_3d], true)
	if Input.is_action_pressed("move_down"):
		direction.z += 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	velocity = target_velocity
	
	if velocity.x == 0 and velocity.z == 0:
		animation_player.play("RESET")
		animation_player.stop()
	else:
		animation_player.play("walk")
	
	move_and_slide()
