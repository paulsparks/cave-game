extends CharacterBody3D

@export var speed = 30

@onready var sprite_3d = $Pivot/PlayerSprite
@onready var animation_player: AnimationPlayer = $Pivot/AnimationPlayer
@onready var weapon_sprite: Sprite3D = get_tree().get_first_node_in_group("weapon").find_child("WeaponSprite")

var target_velocity = Vector3.ZERO

func flip_sprites_h(value: bool):
	sprite_3d.set_flip_h(value)
	weapon_sprite.set_flip_h(value)

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
	
	if velocity.x == 0 and velocity.z == 0:
		animation_player.play("RESET")
		animation_player.stop()
	else:
		animation_player.play("walk")
	
	
	move_and_slide()
