class_name Weapon
extends Node3D

@export var animation_speed_scale: float = .3

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.speed_scale = animation_speed_scale

func _input(event):
	if event.is_action_pressed("attack"):
		animation_player.play("attack")
		animation_player.queue("RESET")
