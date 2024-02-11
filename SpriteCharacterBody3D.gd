class_name SpriteCharacterBody3D
extends CharacterBody3D

var _original_node_positions: Array[Vector3]
var _flipped_node_positions: Array[Vector3]
var _flippable_nodes_have_been_set: bool

func flip_player(nodes_to_flip: Array[Node3D], sprites: Array[Sprite3D], value: bool):
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
	
	for sprite in sprites:
		sprite.set_flip_h(value)
