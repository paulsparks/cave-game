extends Area3D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var is_player: bool


func damage(attack: Attack):
	var parent = get_parent()
	
	if health_component and attack.attack_damage:
		health_component.damage(attack.attack_damage)
	
	if parent is MeleeEnemy:
		if (attack.knockback_horizontal + attack.knockback_vertical) > 0 and parent.enable_knockback:
			parent.knockback(attack)
