tool
class_name AnimaRectangle
extends Control

export (Rect2) var rect setget set_rect
export (Anima.VALUES_IN) var values_in setget set_values_in
export (Color) var color setget set_color
export (bool) var is_filled setget set_is_filled
export (float) var border_width = 1.0 setget set_border_width
export (Color) var border_color = Color.black setget set_border_color
export (bool) var centered setget set_is_centered
export (bool) var is_full_size setget set_is_full_size

var _anima: AnimaNode

func _ready():
	_anima = Anima.begin(self)

func _draw() -> void:
	var rect_to_draw: Rect2 = rect

	if values_in == Anima.VALUES_IN.PERCENTAGE:
		rect_to_draw.size.x = rect_size.x * (rect.size.x / 100)
		rect_to_draw.size.y = rect_size.y * (rect.size.y / 100)
		rect_to_draw.position.x = rect_size.x * (rect.position.x / 100)
		rect_to_draw.position.y = rect_size.y * (rect.position.y / 100)

	if centered:
		rect_to_draw.position.x = (rect_size.x - rect.size.x) / 2
		rect_to_draw.position.y = (rect_size.y - rect.size.y) / 2
	if is_full_size:
		rect = Rect2(Vector2.ZERO, rect_size)

	draw_rect(rect_to_draw, color, is_filled)


func animate(data: Dictionary, auto_play := true) -> AnimaNode:
	data.node = self
	
	if not data.has('property'):
		data.property = 'rect'

	_anima.clear()
	_anima.then(data)

	if auto_play:
		_anima.play()

	return _anima

func get_anima_node() -> AnimaNode:
	return _anima

func set_rect(new_rect: Rect2) -> void:
	rect = new_rect

	update()

func set_values_in(new_values_in: int) -> void:
	values_in = new_values_in

	update()

func set_color(new_color: Color) -> void:
	color = new_color

	update()

func set_is_filled(new_filled: bool) -> void:
	is_filled = new_filled

	update()

func set_border_width(new_width: float) -> void:
	border_width = new_width

	update()

func set_border_color(color: Color) -> void:
	border_color

	update()

func set_is_centered(new_is_centered: bool) -> void:
	centered = new_is_centered

	update()

func set_is_full_size(new_full_size: bool) -> void:
	is_full_size = new_full_size

	update()
