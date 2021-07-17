tool
class_name AnimaTriangle
extends "res://addons/anima/shapes/Base.gd"

export (Vector2) var point1 setget set_point1
export (Vector2) var point2 setget set_point2
export (Vector2) var point3 setget set_point3
export (Anima.VALUES_IN) var values_in setget set_values_in
export (Color) var color setget set_color
export (bool) var is_filled = true setget set_is_filled
export (float) var border_width = 1.0 setget set_border_width
export (Color) var border_color = Color.black setget set_border_color
export (Vector2) var border_offset = Vector2.ZERO setget set_border_offset
export (bool) var centered setget set_is_centered
export (bool) var is_full_size setget set_is_full_size
export (int) var border_radius = 0 setget set_border_radius

var _anima: AnimaNode

func _ready():
	_anima = Anima.begin(self)

func _draw() -> void:
	var p1: Vector2 = _maybe_to_percentage(point1)
	var p2: Vector2 = _maybe_to_percentage(point2)
	var p3: Vector2 = _maybe_to_percentage(point3)

	var points: PoolVector2Array
	
	points.push_back(p1)
	points.push_back(p2)
	points.push_back(p3)

	if is_filled:
		draw_polygon(points, [color], [], null, null, true)

	if border_width > 0:
		draw_polyline(points, border_color, border_width, true)

func _maybe_to_percentage(position: Vector2) -> Vector2:
	if values_in == Anima.VALUES_IN.PIXELS:
		return position

	position.x = rect_size.x * (position.x / 100)
	position.y = rect_size.y * (position.y / 100)

	return position

func animate(data: Dictionary, auto_play := true) -> AnimaNode:
	data.node = self

	_anima.clear()
	_anima.then(data)

	if auto_play:
		_anima.play()

	return _anima

func get_anima_node() -> AnimaNode:
	return _anima

func set_point1(point: Vector2) -> void:
	point1 = point

	update()

func set_point2(point: Vector2) -> void:
	point2 = point

	update()

func set_point3(point: Vector2) -> void:
	point3 = point

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
	border_color = color

	update()

func set_border_offset(offset: Vector2) -> void:
	border_offset = offset

	update()

func set_is_centered(new_is_centered: bool) -> void:
	centered = new_is_centered

	update()

func set_is_full_size(new_full_size: bool) -> void:
	is_full_size = new_full_size

	update()

func set_border_radius(radius: int) -> void:
	border_radius = radius

	update()
