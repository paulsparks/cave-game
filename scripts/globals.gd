extends Node

# set in Player.gd
var player: Player

var player_xp = 0
# set in TempXPLabel.gd
var xp_label: Label
var level = 1

func increment_xp(xp_value):
	player_xp += xp_value
	handle_leveling()
	xp_label.text = "XP: %s\nLevel: %s" % [str(player_xp), level]

func handle_leveling():
	var threshold = level * 1000
	if player_xp >= threshold:
		level += 1
		player_xp -= threshold
		player.weapon.attack_damage = ceil(player.weapon.attack_damage * 1.2)
