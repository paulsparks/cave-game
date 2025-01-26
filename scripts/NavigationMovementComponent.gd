class_name NavigationMovementComponent
extends Node

@export var agent: NavigationAgent3D
@export var enemy: CharacterBody3D
@export var speed = 1.4


var targeted_player: Player
var target_velocity = Vector3.ZERO
var direction_to_player = Vector3.ZERO


func _ready():
	targeted_player = enemy.get_parent().get_node("Player")
	set_physics_process(false)
	call_deferred("enemy_setup")
	
func enemy_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	set_physics_process(true)
	if is_instance_valid(targeted_player):
		agent.set_target_position(targeted_player.global_position)

func _physics_process(delta):
	handle_movement(delta)

func handle_movement(_delta):
	# Stop moving and ignore the rest of the movement function if targeted player is dead
	if not is_instance_valid(targeted_player):
		agent.set_velocity(Vector3.ZERO)
		return
	
	direction_to_player = (agent.get_next_path_position() - enemy.global_position).normalized()
	agent.set_velocity(target_velocity)
	
	# It's computationally expensive and causes stutters when updating target navigation
	# position every frame. Instead, we update target position when player strays from
	# previous target position by 0.4 meters.
	# To put it simply: we update the enemy's desired path to
	# the player every time the player moves more than 0.4 meters.
	var player_distance_from_agent_target = (agent.get_target_position() - targeted_player.global_position).abs()
	if player_distance_from_agent_target.x > 0.4 or player_distance_from_agent_target.z > 0.4:
		agent.set_target_position(targeted_player.global_position)
