extends MeshInstance3D

@export var display_debug_mesh: bool = true

var tracked_collision_shape: CollisionShape3D

func _ready():
	tracked_collision_shape = get_parent()
	visible = false
	mesh.size = tracked_collision_shape.shape.size

func _process(_delta):
	if display_debug_mesh:
		visible = not tracked_collision_shape.disabled
