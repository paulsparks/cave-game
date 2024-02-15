extends Node
class_name HealthComponent

@export var MAX_HEALTH: float = 100
@export var debug_health_label: Label3D

var health: float

func _ready():
	health = MAX_HEALTH
	_draw_debug_health()

## Deal a specified amount of damage to the entity. Once the entity's health
## has reached 0, the entity will be deleted from the scene.
func damage(attack):
	health -= attack.attack_damage
	
	if health <= 0:
		get_parent().queue_free()
	
	_draw_debug_health()

func _draw_debug_health():
	if debug_health_label:
		debug_health_label.text = "Health: %s" % health
