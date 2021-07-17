tool
extends "res://addons/anima/shapes/Rectangle.gd"

signal clicked

export (String) var label = "Menu Item" setget set_label

onready var _label = $MarginContainer/Label

var _has_focus := false
var _anima_initial_animation: AnimaNode
var _animation_completed := false

func _ready():
	_safe_set_label()

	_anima_initial_animation = Anima.begin(self, 'initial')

	_anima_initial_animation.with({ group = _label, property = "text_offset:x", from = -20, to = 20, relative = true, duration = Settings.ANIMATION_SPEEDS.FAST, items_delay = 0.01 })
	_anima_initial_animation.with({ group = _label, property = "opacity", from = 0, to = 1, duration = Settings.ANIMATION_SPEEDS.FAST })
	_anima_initial_animation.set_visibility_strategy(Anima.VISIBILITY.TRANSPARENT_ONLY)

	_anima_initial_animation.connect("animation_completed", self, '_on_initial_animation_completed')

func get_initial_animation() -> AnimaNode:
	return _anima_initial_animation

func grab_focus() -> void:
	if not _can_animate():
		return

	animate({ property = "rect:size:x", to = 100, duration = Settings.ANIMATION_SPEEDS.FAST })
	_anima.with({ group = _label, property = "modulate", to = Color.black, duration = Settings.ANIMATION_SPEEDS.FAST, items_delay = 0.0 })

	_has_focus = true

func release_focus() -> void:
	if not _can_animate():
		return

	self.animate({ property = "rect:size:x", to = 0, duration = Settings.ANIMATION_SPEEDS.FAST })
	_anima.with({ group = _label, property = "modulate", to = Color.white, duration = Anima.MINIMUM_DURATION, items_delay = 0.0 })

	_has_focus = false

func set_label(new_label: String) -> void:
	label = new_label

	_safe_set_label()

func activate() -> void:
	emit_signal("clicked")

func _safe_set_label() -> void:
	if not _label:
		return

	_label.set_label(label)

func _on_MenuItem_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("clicked")

func _can_animate() -> bool:
	return Settings.game_state == Settings.GameState.MENU and _animation_completed

func _on_initial_animation_completed() -> void:
	_animation_completed = true
