class_name MeleeEnemy
extends CharacterBody3D

@export var damage_per_hit = 20
@export var animation_player: AnimationPlayer

@onready var timer = $Timer
@onready var navigation_movement_component = $NavigationMovementComponent

var hurtbox_this_is_attacking: HurtboxComponent
var is_attacking: bool

func _physics_process(_delta):
	handle_melee_attacks()

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
	velocity = safe_velocity
	move_and_slide()
