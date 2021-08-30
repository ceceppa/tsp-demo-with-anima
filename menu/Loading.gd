extends Control

signal animation_completed
signal loading_animation_completed

func _ready():
	hide()

func loading() -> void:
	var anima := Anima.begin(self)
	anima.then({ node = $LoadingLeft, property = "x", from = - $LoadingLeft.rect_size.x, to = 0, easing = Anima.EASING.EASE_IN_CIRC, duration = Settings.ANIMATION_SPEEDS.NORMAL })
	anima.with({ node = $LoadingRight, property = "x", from = $LoadingRight.rect_size.x, to = 0, easing = Anima.EASING.EASE_IN_CIRC, duration = Settings.ANIMATION_SPEEDS.NORMAL })
	anima.with({ group = $Loading, property = "text_offset:y", from = 20, to = 0, delay = Settings.ANIMATION_SPEEDS.FAST, duration = Settings.ANIMATION_SPEEDS.NORMAL, easing = Anima.EASING.EASE_OUT_BACK })

	anima.set_visibility_strategy(Anima.VISIBILITY.TRANSPARENT_ONLY)
	
	.show()

	anima.play()

	yield(anima, 'animation_completed')

	emit_signal('animation_completed')

func set_progress(value: float) -> void:
	$Progress.animate({ property = "rect:w", to = value, duration = Settings.ANIMATION_SPEEDS.FAST })

func set_progress_completed() -> void:
	var anima = $Progress.animate({ property = "rect:w", to = 100, duration = Settings.ANIMATION_SPEEDS.FAST })

	anima.then({ property = "position:y", to = 150, relative = true, duration = Settings.ANIMATION_SPEEDS.NORMAL, easing = Anima.EASING.EASE_OUT_SINE })
	anima.then({ property = "position:y", to = 0, duration = Settings.ANIMATION_SPEEDS.FAST })
	anima.with({ property = "anchor_top", to = 0, duration = Settings.ANIMATION_SPEEDS.FAST })
	anima.with({ property = "rect:h", to = 100, relative = true, duration = Settings.ANIMATION_SPEEDS.FAST })

	anima.play()

	yield(anima, 'animation_completed')

	emit_signal('loading_animation_completed')
