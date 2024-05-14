class_name Weapon
extends Node3D

@export var attack_speed: float = .4
@export var attack_damage: float = 34
@export var knockback_horizontal: float = 80 

@onready var animation_player = $AnimationPlayer
@onready var collision_shape = $Hitbox/CollisionShape3D

var hurtboxes_being_attacked: Array[HurtboxComponent]

func _ready():
	animation_player.speed_scale = attack_speed

func _input(event):
	if !animation_player.is_playing():
		if event.is_action_pressed("attack"):
			animation_player.play("attack")

func _on_hitbox_area_entered(area):
	if area is HurtboxComponent and not area.is_player:
		hurtboxes_being_attacked.push_back(area)

func _on_hitbox_area_exited(area):
	if area is HurtboxComponent and hurtboxes_being_attacked.has(area):
		hurtboxes_being_attacked.erase(area)

func _on_animation_player_animation_started(anim_name):
	if anim_name == "attack" and not hurtboxes_being_attacked.is_empty():
		var attack = Attack.new()
		var knockback = Knockback.new()
		knockback.horizontal = knockback_horizontal
		knockback.vertical = 100
		attack.knockback = knockback
		attack.attack_damage = attack_damage
		attack.attack_position = global_position
		for hurtbox in hurtboxes_being_attacked:
			hurtbox.damage(attack)
