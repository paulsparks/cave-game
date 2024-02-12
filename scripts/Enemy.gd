class_name Enemy
extends LivingEntity

@export var speed = 10
@export var player_path = NodePath()
@export var damage_per_hit = 20

@onready var sprite_3d = $Pivot/EnemySprite
@onready var animation_player: AnimationPlayer = $Pivot/AnimationPlayer
@onready var player = get_node(player_path)
@onready var attack_trigger_shape = $EnemyAttackTrigger/CollisionShape3D
@onready var collision_shape = $EnemyCollisions
@onready var timer = $Timer

signal hit_player(enemy: LivingEntity)

var target_velocity = Vector3.ZERO
var distance = Vector3.ZERO
var is_colliding: bool = false

func _physics_process(_delta):
	movement_logic()

func movement_logic():
	if is_instance_valid(player):
		var direction = Vector3.ZERO
		
		distance = (player.global_position - global_position)
		
		if distance != Vector3.ZERO:
			direction = distance.normalized()
			
		if direction.x > 0:
			flip_entity([attack_trigger_shape, collision_shape], [sprite_3d], false)
		else:
			flip_entity([attack_trigger_shape, collision_shape], [sprite_3d], true)

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

func _on_area_3d_area_entered(area):
	if area.is_in_group("player_hitbox"):
		is_colliding = true
		animation_player.play("attack")
		timer.start(animation_player.current_animation_length)
		print(animation_player.current_animation_length)

func _on_area_3d_area_exited(area):
	if area.is_in_group("player_hitbox"):
		is_colliding = false
		timer.stop()

func _on_enemy_hitbox_area_entered(area):
	if area.is_in_group("weapon_hitbox"):
		var weapon: Weapon = area.owner
		take_damage(weapon.weapon_damage)

func _on_timer_timeout():
	hit_player.emit(self)
