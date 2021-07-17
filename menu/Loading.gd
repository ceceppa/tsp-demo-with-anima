extends Control

func _ready():
	hide()

func show() -> void:
	var anima := Anima.begin(self)
	anima.then({ node = $LoadingLeft, property = "x", from = - $LoadingLeft.rect_size.x, to = 0, easing = Anima.EASING.EASE_IN_CIRC, duration = Settings.ANIMATION_SPEEDS.NORMAL })
	anima.with({ node = $LoadingRight, property = "x", from = $LoadingRight.rect_size.x, to = 0, easing = Anima.EASING.EASE_IN_CIRC, duration = Settings.ANIMATION_SPEEDS.NORMAL })
	anima.set_visibility_strategy(Anima.VISIBILITY.TRANSPARENT_ONLY)

	.show()

	anima.play()

	yield(anima, 'animation_completed')

	$Bar.show()
