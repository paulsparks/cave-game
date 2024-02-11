class_name LivingEntity
extends CharacterBody3D
## A CharacterBody3D, but with some custom functionality needed for our game.

var _original_node_positions: Array[Vector3]
var _flipped_node_positions: Array[Vector3]
var _flippable_nodes_have_been_set: bool

## The entity's health.
@export var health: float = 100
## If true, the entity will have a health bar, as long as they are provided
## with a Label3D in the "debug_health" group.
@export var display_debug_health: bool

## Will emit when the entity dies.
signal is_dead

func _ready():
	_draw_debug_health()

func _draw_debug_health():
	if display_debug_health:
		var labels = get_children().filter(func(x): return x.is_in_group("debug_health"))
		if not labels.is_empty():
			labels[0].text = "Health: %s" % health

## Deal a specified amount of damage to the entity. Once the entity's health
## has reached 0, the entity will be deleted from the scene, and will emit
## the is_dead signal.
func take_damage(amount):
	health -= amount
	
	if health <= 0:
		is_dead.emit()
		queue_free()
	
	_draw_debug_health()

## Given one or more sprites and nodes, set whether or not the group of sprites
## and nodes are flipped. This means flipping the sprites horizontally and
## inverting the nodes about the x-axis. This comes in handy when you need
## to turn a character while considering the character's hitboxes and triggers.
func flip_entity(nodes_to_flip: Array[Node3D], sprites: Array[Sprite3D], value: bool):
	flip_nodes(nodes_to_flip, value)
	flip_sprites(sprites, value)

## Set the horizontal flip status of a group of Sprite3Ds.
func flip_sprites(sprites: Array[Sprite3D], value: bool):
	for sprite in sprites:
		sprite.set_flip_h(value)

## Set whether or not a group of nodes have inverted x-axis positions.
func flip_nodes(nodes_to_flip: Array[Node3D], value: bool):
	if !_flippable_nodes_have_been_set:
		_original_node_positions.assign(nodes_to_flip.map(func(x: Node3D): return x.position))
		_flipped_node_positions.assign(nodes_to_flip.map(func(x: Node3D): return x.position * Vector3(-1, 1, 1)))
	
	_flippable_nodes_have_been_set = true
	
	match value:
		true:
			for i in range(nodes_to_flip.size()):
				nodes_to_flip[i].position = _flipped_node_positions[i]
		false:
			for i in range(nodes_to_flip.size()):
				nodes_to_flip[i].position = _original_node_positions[i]
