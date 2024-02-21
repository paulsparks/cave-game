extends Node3D

@export var mob_scene: PackedScene
@export var spawn_time: int = 5
@export var max_mobs: int = 3

@onready var timer = $Timer
@onready var spawn_location = $SpawnLocation
@onready var sprite = $Vase

var mobs_on_map: Array[CharacterBody3D]

func _ready():
	timer.set_wait_time(spawn_time)
	sprite.material_overlay = sprite.material_overlay.duplicate()

func _on_timer_timeout():
	mobs_on_map = mobs_on_map.filter(func(mob): return is_instance_valid(mob))
	
	if mobs_on_map.size() < max_mobs:
		var mob: CharacterBody3D = mob_scene.instantiate()
		
		var mob_sprite = mob.get_node("EnemySprite")

		mob.set_position(spawn_location.global_position)
		
		mob_sprite.material_overlay = mob_sprite.material_overlay.duplicate()
		
		get_parent().add_child(mob)
		mobs_on_map.push_back(mob)
