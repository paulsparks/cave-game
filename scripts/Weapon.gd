class_name Weapon
extends Node3D

@export var attack_speed: float = .3
@export var weapon_damage: float = 34

@onready var animation_player = $AnimationPlayer
@onready var collision_shape = $AttackCollider/CollisionShape3D

func _attack_and_reset():
	animation_player.play("attack")
	animation_player.queue("RESET")

func _ready():
	animation_player.speed_scale = attack_speed

func _input(event):
	if !animation_player.is_playing():
		if event.is_action_pressed("attack"):
			_attack_and_reset()

func _process(_delta):
	if animation_player.is_playing():
		collision_shape.set_disabled(false)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "RESET":
		collision_shape.set_disabled(true)
