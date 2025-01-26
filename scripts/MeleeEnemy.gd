class_name MeleeEnemy
extends CharacterBody3D

@export var damage_per_hit = 20
@export var xp_value = 200
@export var animation_player: AnimationPlayer
@export var max_gravity_speed: float = 10
@export var enable_knockback = false
@export var heaviness: float = 0.13


@onready var timer = $Timer
@onready var navigation_movement_component = $NavigationMovementComponent
var is_nav_enabled = true
var gravity_speed: float = 1.3
var knockback_velocity: Vector3 = Vector3.ZERO

var hurtbox_this_is_attacking: HurtboxComponent
var is_attacking: bool
var target_velocity: Vector3 = Vector3.ZERO
var multiplier = heaviness

func _exit_tree():
	Globals.increment_xp(xp_value)

func _physics_process(_delta):
	handle_melee_attacks()
	move_enemy()

func handle_melee_attacks():
	is_attacking = hurtbox_this_is_attacking != null
	
	if not is_attacking:
		navigation_movement_component.target_velocity.x = navigation_movement_component.direction_to_player.x * navigation_movement_component.speed
		navigation_movement_component.target_velocity.z = navigation_movement_component.direction_to_player.z * navigation_movement_component.speed
	else:
		navigation_movement_component.target_velocity = Vector3.ZERO

func _on_hitbox_area_entered(area):
	if area is HurtboxComponent and area.is_player:
		animation_player.play("attack")
		hurtbox_this_is_attacking = area
		timer.start(animation_player.current_animation_length)

func _on_hitbox_area_exited(area):
	if area == hurtbox_this_is_attacking:
		timer.stop()
		hurtbox_this_is_attacking = null

func _on_timer_timeout():
	var attack = Attack.new()
	attack.attack_damage = damage_per_hit
	
	hurtbox_this_is_attacking.damage(attack)

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if is_nav_enabled:
		target_velocity = safe_velocity
	
func move_enemy():
	if is_on_floor():
		target_velocity.y = 0
	else:
		target_velocity.y = clamp(target_velocity.y - gravity_speed, -max_gravity_speed, max_gravity_speed)
	velocity = target_velocity
	velocity += knockback_velocity
	
	if knockback_velocity != Vector3.ZERO:
		knockback_velocity *= multiplier
		multiplier = clamp(multiplier - (0.005), 0, INF)
	else:
		multiplier = heaviness
		
	move_and_slide()

func knockback(attack: Attack):

	var knockback_speed: Vector3 = Vector3(attack.knockback_horizontal, attack.knockback_vertical, attack.knockback_horizontal)
	var knockback_direction: Vector3 = attack.attack_position.direction_to(global_position)
	knockback_direction.y = 1
	knockback_velocity = knockback_direction * knockback_speed
	
