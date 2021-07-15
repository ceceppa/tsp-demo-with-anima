tool
extends "res://addons/anima/shapes/Rectangle.gd"

signal clicked

export (String) var label = "Menu Item" setget set_label

onready var _label = $MarginContainer/Label

var _is_mouse_inside := false
var _can_animate := false
var _anima_initial_animation: AnimaNode

func _ready():
	_safe_set_label()

	_anima_initial_animation = Anima.begin(self, 'initial')

	_anima_initial_animation.with({ group = _label, property = "text_offset:x", from = -20, to = 20, relative = true, duration = Settings.MENU_ANIMATION_SPEED, items_delay = 0.01 })
	_anima_initial_animation.with({ group = _label, property = "opacity", from = 0, to = 1, duration = Settings.MENU_ANIMATION_SPEED })
	_anima_initial_animation.set_visibility_strategy(Anima.VISIBILITY.TRANSPARENT_ONLY)

	_anima_initial_animation.connect("animation_completed", self, '_on_initial_animation_completed')

func get_initial_animation() -> AnimaNode:
	return _anima_initial_animation

func _on_focus() -> void:
	if not _can_animate:
		return

	animate({ property = "rect:size:x", to = 100, duration = Settings.MENU_ANIMATION_SPEED })
	_anima.with({ group = _label, property = "modulate", to = Color.black, duration = Settings.MENU_ANIMATION_SPEED, items_delay = 0.0 })

	_is_mouse_inside = true

func _on_focus_leave():
	if not _can_animate:
		return

	self.animate({ property = "rect:size:x", to = 0, duration = Settings.MENU_ANIMATION_SPEED })
	_anima.with({ group = _label, property = "modulate", to = Color.white, duration = Settings.MENU_ANIMATION_SPEED, items_delay = 0.0 })

	_is_mouse_inside = false

func set_label(new_label: String) -> void:
	label = new_label

	_safe_set_label()
	
func _safe_set_label() -> void:
	if not _label:
		return

	_label.set_label(label)

func _on_MenuItem_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("clicked")

func _on_initial_animation_completed() -> void:
	_can_animate = true
