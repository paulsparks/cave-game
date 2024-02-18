extends Node3D

@export var mob_scene: PackedScene
@export var spawn_time: int = 5
@export var max_mobs: int = 3

@onready var timer = $Timer
@onready var spawn_location = $SpawnLocation

var mobs_on_map: Array[Enemy]

func _ready():
	timer.set_wait_time(spawn_time)

func _on_timer_timeout():
	mobs_on_map = mobs_on_map.filter(func(mob): return is_instance_valid(mob))
	
	if mobs_on_map.size() < max_mobs:
		var mob: Enemy = mob_scene.instantiate()
		
		mob.player = get_node_or_null("../Player")

		mob.set_position(spawn_location.global_position)
		
		get_parent().add_child(mob)
		mobs_on_map.push_back(mob)
