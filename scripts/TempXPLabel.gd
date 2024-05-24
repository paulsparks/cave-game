extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	text = "XP: 0\nLevel: 1"
	Globals.xp_label = self
