extends "res://addons/anima/shapes/Rectangle.gd"

onready var settings_menu = get_node(@"VBoxContainer")
onready var settings_actions = settings_menu.get_node(@"Actions")

onready var settings_action_apply = settings_actions.get_node(@"Apply")
onready var settings_action_cancel = settings_actions.get_node(@"Cancel")

onready var gi_menu = settings_menu.get_node(@"GI")
onready var gi_high = gi_menu.get_node(@"High")
onready var gi_low = gi_menu.get_node(@"Low")
onready var gi_disabled = gi_menu.get_node(@"Disabled")

onready var aa_menu = settings_menu.get_node(@"AA")
onready var aa_8x = aa_menu.get_node(@"8X")
onready var aa_4x = aa_menu.get_node(@"4X")
onready var aa_2x = aa_menu.get_node(@"2X")
onready var aa_disabled = aa_menu.get_node(@"Disabled")

onready var ssao_menu = settings_menu.get_node(@"SSAO")
onready var ssao_high = ssao_menu.get_node(@"High")
onready var ssao_low = ssao_menu.get_node(@"Low")
onready var ssao_disabled = ssao_menu.get_node(@"Disabled")

onready var bloom_menu = settings_menu.get_node(@"Bloom")
onready var bloom_high = bloom_menu.get_node(@"High")
onready var bloom_low = bloom_menu.get_node(@"Low")
onready var bloom_disabled = bloom_menu.get_node(@"Disabled")

onready var resolution_menu = settings_menu.get_node(@"Resolution")
onready var resolution_native = resolution_menu.get_node(@"Native")
onready var resolution_1080 = resolution_menu.get_node(@"1080")
onready var resolution_720 = resolution_menu.get_node(@"720")
onready var resolution_540 = resolution_menu.get_node(@"540")

onready var fullscreen_menu = settings_menu.get_node(@"Fullscreen")
onready var fullscreen_yes = fullscreen_menu.get_node(@"Yes")
onready var fullscreen_no = fullscreen_menu.get_node(@"No")

func _ready():
	hide()

func _input(event):
	if Settings.game_state != Settings.GameState.SETTINGS:
		return

	if event.is_action_pressed("ui_cancel"):
		_on_cancel_pressed()

func show_menu(menu_item: Control) -> void:
	var padding := Vector2(48, 48)
	var final_size: Rect2 = Rect2($VBoxContainer.rect_global_position - padding, $VBoxContainer.rect_size + (padding * 2))

	$Rectangle.set_rect(Rect2(menu_item.rect_global_position, menu_item.rect_size))

	var anima = $Rectangle.animate({ to = final_size, duration = Settings.ANIMATION_SPEEDS.FAST }, false)
	anima.also({ property = "border_width", to = 2 })
	anima.also({ property = "color", to = Color.black })
	anima.with({ node = $Overlay, property = "color", to = Color(0, 0, 0, 0.6), duration = Settings.ANIMATION_SPEEDS.FAST })

	anima.with({ 
		group = $VBoxContainer,
		property = "x",
		from = -20,
		to = 20, 
		relative = true,
		duration = Settings.ANIMATION_SPEEDS.NORMAL,
		items_delay = 0.02,
		hide_strategy = Anima.VISIBILITY.TRANSPARENT_ONLY
	})
	anima.also({ 
		property = "opacity",
		from = 0,
		to = 1,
	})

	anima.play()
	
	.show()
	_init_settings()

func _init_settings():
	if Settings.gi_quality == Settings.GIQuality.HIGH:
		gi_high.pressed = true
		gi_high.grab_focus()
	elif Settings.gi_quality == Settings.GIQuality.LOW:
		gi_low.pressed = true
		gi_low.grab_focus()
	elif Settings.gi_quality == Settings.GIQuality.DISABLED:
		gi_disabled.pressed = true
		gi_disabled.grab_focus()

	if Settings.aa_quality == Settings.AAQuality.AA_8X:
		aa_8x.pressed = true
	elif Settings.aa_quality == Settings.AAQuality.AA_4X:
		aa_4x.pressed = true
	elif Settings.aa_quality == Settings.AAQuality.AA_2X:
		aa_2x.pressed = true
	elif Settings.aa_quality == Settings.AAQuality.DISABLED:
		aa_disabled.pressed = true

	if Settings.ssao_quality == Settings.SSAOQuality.HIGH:
		ssao_high.pressed = true
	elif Settings.ssao_quality == Settings.SSAOQuality.LOW:
		ssao_low.pressed = true
	elif Settings.ssao_quality == Settings.SSAOQuality.DISABLED:
		ssao_disabled.pressed = true

	if Settings.bloom_quality == Settings.BloomQuality.HIGH:
		bloom_high.pressed = true
	elif Settings.bloom_quality == Settings.BloomQuality.LOW:
		bloom_low.pressed = true
	elif Settings.bloom_quality == Settings.BloomQuality.DISABLED:
		bloom_disabled.pressed = true

	if Settings.resolution == Settings.Resolution.NATIVE:
		resolution_native.pressed = true
	elif Settings.resolution == Settings.Resolution.RES_1080:
		resolution_1080.pressed = true
	elif Settings.resolution == Settings.Resolution.RES_720:
		resolution_720.pressed = true
	elif Settings.resolution == Settings.Resolution.RES_540:
		resolution_540.pressed = true

	if Settings.fullscreen:
		fullscreen_yes.pressed = true
	else:
		fullscreen_no.pressed = true

func _on_apply_pressed():
	if gi_high.pressed:
		Settings.gi_quality = Settings.GIQuality.HIGH
	elif gi_low.pressed:
		Settings.gi_quality = Settings.GIQuality.LOW
	elif gi_disabled.pressed:
		Settings.gi_quality = Settings.GIQuality.DISABLED

	if aa_8x.pressed:
		Settings.aa_quality = Settings.AAQuality.AA_8X
	elif aa_4x.pressed:
		Settings.aa_quality = Settings.AAQuality.AA_4X
	elif aa_2x.pressed:
		Settings.aa_quality = Settings.AAQuality.AA_2X
	elif aa_disabled.pressed:
		Settings.aa_quality = Settings.AAQuality.DISABLED

	if ssao_high.pressed:
		Settings.ssao_quality = Settings.SSAOQuality.HIGH
	elif ssao_low.pressed:
		Settings.ssao_quality = Settings.SSAOQuality.LOW
	elif ssao_disabled.pressed:
		Settings.ssao_quality = Settings.SSAOQuality.DISABLED

	if bloom_high.pressed:
		Settings.bloom_quality = Settings.BloomQuality.HIGH
	elif bloom_low.pressed:
		Settings.bloom_quality = Settings.BloomQuality.LOW
	elif bloom_disabled.pressed:
		Settings.bloom_quality = Settings.BloomQuality.DISABLED

	if resolution_native.pressed:
		Settings.resolution = Settings.Resolution.NATIVE
	elif resolution_1080.pressed:
		Settings.resolution = Settings.Resolution.RES_1080
	elif resolution_720.pressed:
		Settings.resolution = Settings.Resolution.RES_720
	elif resolution_540.pressed:
		Settings.resolution = Settings.Resolution.RES_540

	Settings.fullscreen = fullscreen_yes.pressed

	# Apply the setting directly
	OS.window_fullscreen = Settings.fullscreen

	Settings.save_settings()

	_on_cancel_pressed()

func _on_cancel_pressed():
	var anima = $Rectangle.get_anima_node()

	anima.play_backwards()

	yield(anima, 'animation_completed')

	Settings.game_state = Settings.GameState.MENU

	hide()
