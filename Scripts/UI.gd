class_name UI
extends CanvasLayer

# How long fading should take by default, in seconds
const default_fade_time:float = 0.6

@onready var animator = $UiAnimation
var is_fading:bool = false

func fade_black(time:float):
	if is_fading:
		push_warning("A fade is already in progress.")
		return
	else:
		is_fading = true
		# Convert time in seconds to speed scale
		animator.speed_scale = 1.0 / time
		animator.play("fade_black")
		await(animator.animation_finished)
		is_fading = false

func fade_clear(time:float):
	if is_fading:
		push_warning("A fade is already in progress.")
		return
	else:
		is_fading = true
		# Convert time in seconds to speed scale
		animator.speed_scale = time
		animator.play("fade_clear")
		await(animator.animation_finished)
		is_fading = false

