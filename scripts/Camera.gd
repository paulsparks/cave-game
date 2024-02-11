extends Camera3D

@export var player_path = NodePath()
@export var acceleration_speed = 4
@export var maxSpeed = 60
@export var distance_from_player: float = 35

@onready var player = get_node(player_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance = global_transform.origin.z - player.global_transform.origin.z
	var accel = acceleration_speed * (distance_from_player - distance)
	accel = clamp(accel, -maxSpeed, maxSpeed)
	global_transform.origin.z += accel * delta
	
