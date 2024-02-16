class_name Enemy
extends CharacterBody3D

@export var speed = 10
@export var player: CharacterBody3D
@export var damage_per_hit = 20
@export var animation_player: AnimationPlayer

@onready var sprite_3d = $Pivot/EnemySprite
@onready var attack_trigger_shape = $Hitbox/CollisionShape3D
@onready var collision_shape = $EnemyCollisions
@onready var timer = $Timer
@onready var hurtbox_shape = $HurtboxComponent/CollisionShape3D

var target_velocity = Vector3.ZERO
var distance = Vector3.ZERO
var hurtbox_being_attacked: HurtboxComponent
var entity_interface: EntityInterface = EntityInterface.new()

func _physics_process(_delta):
	movement_logic()

func movement_logic():
	if is_instance_valid(player):
		var direction = Vector3.ZERO
		var is_colliding = hurtbox_being_attacked != null
		
		distance = (player.global_position - global_position)
		
		if distance != Vector3.ZERO:
			direction = distance.normalized()
			
		if direction.x > 0:
			entity_interface.flip_entity([attack_trigger_shape, collision_shape, hurtbox_shape], [sprite_3d], false)
		else:
			entity_interface.flip_entity([attack_trigger_shape, collision_shape, hurtbox_shape], [sprite_3d], true)

		if !is_colliding:
			target_velocity.x = direction.x * speed
			target_velocity.z = direction.z * speed
		else:
			target_velocity = Vector3.ZERO
			
		if not is_colliding:
			animation_player.play("walk")

		velocity = target_velocity
		move_and_slide()
	else:
		animation_player.play("RESET")

func _on_hitbox_area_entered(area):
	if area is HurtboxComponent and area.is_player:
		animation_player.play("attack")
		hurtbox_being_attacked = area
		timer.start(animation_player.current_animation_length)

func _on_hitbox_area_exited(area):
	if area == hurtbox_being_attacked:
		timer.stop()
		hurtbox_being_attacked = null

func _on_timer_timeout():
	var attack = Attack.new()
	attack.attack_damage = damage_per_hit
	
	hurtbox_being_attacked.damage(attack)
