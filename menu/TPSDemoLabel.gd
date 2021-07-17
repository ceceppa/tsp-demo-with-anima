extends Control

var line_size = 40

var _anima: AnimaNode

func _ready():
	_anima = Anima.begin(self)

	_anima.then({ node = $UpperLine, property = "from", from = Vector2(50, 265), to = Vector2(50 - line_size, 265), duration = Settings.ANIMATION_SPEEDS.NORMAL, easing = Anima.EASING.EASE_IN_EXPO })
	_anima.with({ node = $BottomLine, property = "from", from = Vector2(50, -155), to = Vector2(50 - line_size, -155), duration = Settings.ANIMATION_SPEEDS.NORMAL, easing = Anima.EASING.EASE_IN_EXPO })
	_anima.with({ node = $UpperLine, property = "to", from = Vector2(50, 265), to = Vector2(50 + line_size, 265), duration = Settings.ANIMATION_SPEEDS.NORMAL, easing = Anima.EASING.EASE_IN_EXPO })
	_anima.with({ node = $BottomLine, property = "to", from = Vector2(50, -155), to = Vector2(50 + line_size, -155), duration = Settings.ANIMATION_SPEEDS.NORMAL, easing = Anima.EASING.EASE_IN_EXPO })

	_anima.then({ node = $UpperLine, property = "from", to = Vector2(50 - line_size, 120), duration = Settings.ANIMATION_SPEEDS.SLOW, easing = Anima.EASING.EASE_OUT_BACK })
	_anima.with({ node = $UpperLine, property = "to", to = Vector2(50 + line_size, 120), duration = Settings.ANIMATION_SPEEDS.SLOW, easing = Anima.EASING.EASE_OUT_BACK })
	_anima.with({ node = $BottomLine, property = "from", to = Vector2(50 - line_size, -20), duration = Settings.ANIMATION_SPEEDS.SLOW, easing = Anima.EASING.EASE_OUT_BACK })
	_anima.with({ node = $BottomLine, property = "to", to = Vector2(50 + line_size, -20), duration = Settings.ANIMATION_SPEEDS.SLOW, easing = Anima.EASING.EASE_OUT_BACK })
	_anima.with({ 
		group = $AnimaChars,
		property = "opacity",
		from = 0, to = 1,
		animation_type = Anima.GRID.FROM_CENTER,
		duration = Settings.ANIMATION_SPEEDS.SLOW,
		hide_strategy = Anima.VISIBILITY.TRANSPARENT_ONLY,
		delay = Settings.ANIMATION_SPEEDS.NORMAL
	})

func get_anima_node() -> AnimaNode:
	return _anima
