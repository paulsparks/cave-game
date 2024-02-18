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
	var sprite: Sprite3D = get_parent().get_children().filter(func(child): return child is Sprite3D)[0]
	var tween = _animate_hit(sprite)
	
	health -= attack.attack_damage
	
	if health <= 0:
		tween.stop()
		get_parent().queue_free()
	
	_draw_debug_health()

func _draw_debug_health():
	if debug_health_label:
		debug_health_label.text = "Health: %s" % health

func _animate_hit(sprite: Sprite3D) -> Tween:
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(sprite, "material_overlay:albedo_color:a", 0.3, .1)
	tween.tween_property(sprite, "material_overlay:albedo_color:a", 0.0, .1)
	return tween
