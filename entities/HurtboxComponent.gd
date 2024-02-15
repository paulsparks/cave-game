extends Area3D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var is_player: bool

func damage(attack):
	if health_component:
		health_component.damage(attack)
