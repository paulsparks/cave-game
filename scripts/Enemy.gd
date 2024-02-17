class_name Enemy
extends CharacterBody3D

@export var speed = 10
@export var player: CharacterBody3D
@export var damage_per_hit = 20
@export var animation_player: AnimationPlayer

@onready var sprite_3d = $Pivot/EnemySprite
@onready var attack_trigger_shape = $Hitbox/CollisionShape3D
@onready var collision_shape = $EnemyCollisions
@onready var timer = $Timer
@onready var hurtbox_shape = $HurtboxComponent/CollisionShape3D
@onready var agent: NavigationAgent3D = $NavigationAgent3D

var target_velocity = Vector3.ZERO
var distance = Vector3.ZERO
var hurtbox_being_attacked: HurtboxComponent
var entity_interface: EntityInterface = EntityInterface.new()

func _ready():
	set_physics_process(false)
	call_deferred("enemy_setup")
	
func enemy_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	set_physics_process(true)
	agent.set_target_position(player.global_position)

func _physics_process(_delta):
	movement_logic()

func movement_logic():
	if is_instance_valid(player):
		var direction = Vector3.ZERO
		var is_colliding = hurtbox_being_attacked != null
		
		distance = (agent.get_next_path_position() - global_position)
		
		if distance != Vector3.ZERO:
			direction = distance.normalized()
			
		if direction.x > 0:
			entity_interface.flip_entity([attack_trigger_shape, collision_shape, hurtbox_shape], [sprite_3d], false)
		else:
			entity_interface.flip_entity([attack_trigger_shape, collision_shape, hurtbox_shape], [sprite_3d], true)

		if !is_colliding:
			target_velocity.x = direction.x * speed
			target_velocity.z = direction.z * speed
		else:
			target_velocity = Vector3.ZERO
			
		if not is_colliding:
			animation_player.play("walk")

		agent.set_velocity(target_velocity)
		
		# It's computationally expensive and causes stutters when updating target navigation
		# position every frame. Instead, we update target position when player strays from
		# previous target position by 3 units.
		# To put it simply: we update the enemy's desired path to
		# the player every time the player moves more than 3 meters.
		var player_distance_from_target = (agent.get_target_position() - player.global_position).abs()
		if player_distance_from_target.x > 3 or player_distance_from_target.z > 3:
			agent.set_target_position(player.global_position)
	else:
		animation_player.play("RESET")

func _on_hitbox_area_entered(area):
	if area is HurtboxComponent and area.is_player:
		animation_player.play("attack")
		hurtbox_being_attacked = area
		timer.start(animation_player.current_animation_length)

func _on_hitbox_area_exited(area):
	if area == hurtbox_being_attacked:
		timer.stop()
		hurtbox_being_attacked = null

func _on_timer_timeout():
	var attack = Attack.new()
	attack.attack_damage = damage_per_hit
	
	hurtbox_being_attacked.damage(attack)

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()
