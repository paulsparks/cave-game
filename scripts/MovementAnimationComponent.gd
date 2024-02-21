class_name MovementAnimationComponent
extends Node

@export var animation_player: AnimationPlayer
@export var navigation_movement_component: NavigationMovementComponent

func _physics_process(_delta):
	handle_sprite_flipping()
	handle_animations()

func handle_sprite_flipping():
	if not is_instance_valid(navigation_movement_component.targeted_player):
		return

	var entity_interface: EntityInterface = EntityInterface.new()
	
	var attack_trigger_shape = navigation_movement_component.enemy.get_node("Hitbox")
	var collision_shape = navigation_movement_component.enemy.get_node("EnemyCollisions")
	var hurtbox_shape = navigation_movement_component.enemy.get_node("HurtboxComponent")
	var sprite_3d = navigation_movement_component.enemy.get_node("EnemySprite")
	
	if navigation_movement_component.direction_to_player.x > 0:
		entity_interface.flip_entity([attack_trigger_shape, collision_shape, hurtbox_shape], [sprite_3d], false)
	else:
		entity_interface.flip_entity([attack_trigger_shape, collision_shape, hurtbox_shape], [sprite_3d], true)

func handle_animations():
	if not is_instance_valid(navigation_movement_component.targeted_player):
		animation_player.play("RESET")
		return
	
	# This will change in the future for more complicated movement
	if not navigation_movement_component.enemy.is_attacking:
		animation_player.play("walk")
