extends TextureRect

signal play
signal quit
signal loading_completed
signal loading_animation_completed

var _viewport: Viewport

var _selected_index := 0

onready var _menu_items = get_node("Main/MenuBG/MenuItems")
onready var _play_button = _menu_items.get_node("PlayButton")
onready var _settings_button = _menu_items.get_node("SettingsButton")
onready var _quit_button = _menu_items.get_node("QuitButton")

onready var _selected_menu_item = $Main/MenuBG/MenuItems/PlayButton

func _ready():
	_init_menu()

	_viewport = get_parent().find_node('Viewport')
	
	var bg: AnimaNode = $Main/MenuBG.animate({ property = "rect:size:y", to = 100, duration = 0.3, delay = 0.3 }, false)

	$AnimaPlayer.then(bg)
	$AnimaPlayer.then($Main/MenuBG/TPSDemoLabel.get_anima_node())
	$AnimaPlayer.then(_play_button.get_initial_animation())
	$AnimaPlayer.with(_settings_button.get_initial_animation(), 0.1)
	$AnimaPlayer.with(_quit_button.get_initial_animation(), 0.2)

	$AnimaPlayer.play_with_delay(0)
	
	yield($AnimaPlayer, 'completed')

	Settings.game_state = Settings.GameState.MENU

	_highlight_selected_menu_item()

func _draw():
	if not _viewport:
		return

	draw_texture(_viewport.get_texture(), Vector2.ZERO)

func _input(event):
	if Settings.game_state != Settings.GameState.MENU:
		return

	if event.is_action_pressed("ui_down"):
		_select_menu_item(1)
	elif event.is_action_pressed("ui_up"):
		_select_menu_item(-1)
	elif event.is_action_pressed("ui_accept"):
		_selected_menu_item.activate()

func _init_menu() -> void:
	var menu_items = get_node("Main/MenuBG/MenuItems")

	for menu_item in menu_items.get_children():
		menu_item.connect('mouse_entered', self, '_on_menu_item_mouse_entered', [menu_item])
		menu_item.connect('mouse_exited', self, '_on_menu_item_mouse_exited')

func _select_menu_item(direction: int) -> void:
	var menu_items = $Main/MenuBG/MenuItems.get_children()
	var max_index: int = menu_items.size() - 1
	_selected_index += direction

	if _selected_index < 0:
		_selected_index = max_index
	elif _selected_index > max_index:
		_selected_index = 0

	_selected_menu_item = menu_items[_selected_index]

	_highlight_selected_menu_item()

func _highlight_selected_menu_item() -> void:
	var menu_items = get_node("Main/MenuBG/MenuItems")
	var is_a_menu_item_selected := false

	for menu_item in menu_items.get_children():
		if menu_item != _selected_menu_item:
			menu_item.release_focus()

	_selected_menu_item.grab_focus()

func _on_menu_item_mouse_entered(menu_item: Node) -> void:
	_selected_menu_item = menu_item

	_highlight_selected_menu_item()

func _on_menu_item_mouse_exited() -> void:
	_select_menu_item(0)

func _on_Play_clicked():
	emit_signal("play")

func _on_Quit_clicked():
	emit_signal("quit")

func _on_Settings_clicked():
	Settings.game_state = Settings.GameState.SETTINGS

	$GameSettings.show_menu(_settings_button)

func _on_Loading_loading_animation_completed():
	emit_signal('loading_completed')
