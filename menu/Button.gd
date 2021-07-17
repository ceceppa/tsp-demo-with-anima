extends Button

onready var _rectangle = $AnimaRectangle
onready var _label = $AnimaRectangle.get_node("Label")

onready var _border_color = _rectangle.border_color

const Colors = {
	NORMAL = Color.black,
	PRESSED = Color('#747400'),
	HOVERED = Color.white
}

const LabelColors = {
	NORMAL = Color.white,
	PRESSED = Color.white,
	HOVERED = Color.black
}

const Statuses := {
	NORMAL = 'NORMAL',
	PRESSED = 'PRESSED',
	HOVERED = 'HOVERED'
}

var _status = Statuses.NORMAL

func _ready():
	text = ' ' + text.strip_edges() + ' '
	_label.text = text

	if pressed:
		_status = Statuses.PRESSED

	_label.modulate = LabelColors[_status]
	_rectangle.color = Colors[_status]

func _on_High_focus_entered():
	var border_color: Color = Colors.HOVERED
	var final_color: Color = Colors.HOVERED
	var label_color: Color = LabelColors.HOVERED

	if pressed:
		final_color = Colors.PRESSED
		border_color = Colors.HOVERED
		label_color = LabelColors.PRESSED

	var anima = _rectangle.animate({ property = "color", to = final_color, duration = Settings.ANIMATION_SPEEDS.NORMAL })
	anima.with({ property = "border_offset", to = Vector2(8, 8), easing = Anima.EASING.EASE_OUT_BACK, duration = Settings.ANIMATION_SPEEDS.NORMAL })
	anima.with({ property = "border_color", to = border_color, duration = Settings.ANIMATION_SPEEDS.NORMAL })

	_label.modulate = label_color

func _on_High_focus_exited():
	var final_color: Color = Colors[_status]
	var final_label_color: Color = LabelColors[_status]

	var anima = _rectangle.animate({ property = "color", to = final_color, duration = Settings.ANIMATION_SPEEDS.FAST })
	anima.with({ node = _rectangle, property = "border_offset", to = Vector2(0, 0), duration = Settings.ANIMATION_SPEEDS.FAST })
	anima.with({ node = _rectangle, property = "border_color", to = Color.white, duration = Settings.ANIMATION_SPEEDS.FAST })

	_label.modulate = final_label_color

func _on_Button_toggled(button_pressed):
	if button_pressed:
		_status = Statuses.PRESSED
	else:
		_status = Statuses.NORMAL

	var final_color: Color = Colors[_status]
	var final_label_color: Color = LabelColors[_status]

	var anima: AnimaNode = _rectangle.animate({ property = "color", to = final_color, duration = Settings.ANIMATION_SPEEDS.FAST })

	if button_pressed:
		anima.with({ animation = "pulse", duration = Settings.ANIMATION_SPEEDS.NORMAL })

	_label.modulate = final_label_color

func _on_Button_pressed():
	if toggle_mode:
		return

	var anima = Anima.begin(self)
	anima.with({ node = self, animation = "pulse", duration = Settings.ANIMATION_SPEEDS.NORMAL  })

	anima.play()

