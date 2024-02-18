extends Camera3D

@export var player_path = NodePath() # Allows choosing the thing to follow in the inspector, aka the player.
@export var acceleration_speed: Vector3 = Vector3(2, 40, 4) # How quickly the camera will exponentially speed up to the maximum speed defined below. Higher is faster.
@export var max_speed: Vector3 = Vector3(60, 60, 60) # Camera's maximum speed in x, y, and z directions. In other words, the maximum speed the camera will hit when "catching up" to the player.
@export var targeted_distance_from_player: Vector3 = Vector3(0, 13.5, 40) # Camera's distance from the player in Vector3(x, y, z) format. It's in meters I guess.

@export var fixed_rotation: Vector3 = Vector3(-0.25, 0, 0) # The fixed rotation for the x and z planes. Any inputted y is ignored.
@export var max_rotation: float = 0.025 # Maximum y rotation in radians, in both negative and positive directions.
@export var rotation_lag: float = 0.2 # MUST be between 0 and 1. Weird things will happen if ignored. Lower number means less lag.
var current_rotation : Vector3 = Vector3.ZERO # Needs to be initialized out of _process, or bad things happen.

@onready var player = get_node(player_path) # Fetches the player node. "Importing it" if you will.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(player):
		# This moves the camera to be in line with the player as specified by targeted_distance_from_player, adding the natural lag along the way.
		var actual_distance_from_player = global_transform.origin - player.global_transform.origin
		var accel = acceleration_speed * (targeted_distance_from_player - actual_distance_from_player)
		accel = accel.clamp(-max_speed, max_speed)
		global_transform.origin += accel * delta
		
		# This ever so slightly rotates the camera toward the player while it is not directly in line with the player on the x axis.
		var target_direction = player.global_transform.origin - global_transform.origin
		var target_rotation = Basis.looking_at(target_direction, Vector3(0, 1, 0)).get_euler()
		
		target_rotation.y = clamp(target_rotation.y, -max_rotation, max_rotation)
		target_rotation.x = fixed_rotation.x
		target_rotation.z = fixed_rotation.z
		
		current_rotation = current_rotation.lerp(target_rotation, 1.0 - pow(rotation_lag, delta))
		global_transform.basis = Basis.from_euler(current_rotation)
