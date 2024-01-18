class_name Game
extends Node3D
## Use this class to handle initialization and scene management.

static var instance:Game
static var ui:UI

func _ready():
	if !instance:
		instance = self
		ui = $UI
	else:
		push_warning(
			"Multiple Game instances detected?? Removing instance %s"
			% name
			)
		queue_free()

static func fade_black(time:float = -1.0):
	if time < 0:
		time = UI.default_fade_time
	ui.fade_black(time)
