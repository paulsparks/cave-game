class_name Weapon
extends Node3D

@export var attack_speed: float = .3
@export var weapon_damage: float = 34

@onready var animation_player = $AnimationPlayer
@onready var collision_shape = $AttackCollider/CollisionShape3D

var hitbox_is_colliding: bool
var attack_already_happened: bool
var current_area_collided_with: Area3D

func _ready():
	animation_player.speed_scale = attack_speed

func _input(event):
	if event.is_action_pressed("attack"):
		animation_player.play("attack")
		animation_player.queue("RESET")

func _process(_delta):
	if animation_player.is_playing():
		collision_shape.set_disabled(false)
	else:
		collision_shape.set_disabled(true)
