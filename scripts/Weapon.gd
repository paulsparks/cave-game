class_name Weapon
extends Node3D

@export var attack_speed: float = .3
@export var weapon_damage: float = 10

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.speed_scale = attack_speed

func _input(event):
	if event.is_action_pressed("attack"):
		animation_player.play("attack")
		animation_player.queue("RESET")
