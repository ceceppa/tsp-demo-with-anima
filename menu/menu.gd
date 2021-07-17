extends Node

var res_loader: ResourceInteractiveLoader = null
var loading_thread: Thread = null

signal replace_main_scene
#warning-ignore:unused_signal
signal quit # Useless, but needed as there is no clean way to check if a node exposes a signal

onready var ui = $UI
onready var main = ui.get_node(@"Main")

onready var loading = ui.get_node(@"Loading")
onready var loading_progress = loading.get_node(@"Progress")
onready var loading_done_timer = loading.get_node(@"DoneTimer")

func _ready():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, Vector2(1920, 1080))
	var sound_effects = $BackgroundCache/RedRobot/SoundEffects
	for child in sound_effects.get_children():
		child.unit_db = -200

func interactive_load(loader):
	while true:
		var status = loader.poll()
		if status == OK:
			loading_progress.value = (loader.get_stage() * 100) / loader.get_stage_count()
			continue
		elif status == ERR_FILE_EOF:
			loading_progress.value = 100
			loading_done_timer.start()
			break
		else:
			print("Error while loading level: " + str(status))
			main.show()
			loading.hide()
			break


func loading_done(loader):
	loading_thread.wait_to_finish()
	emit_signal("replace_main_scene", loader.get_resource())
	res_loader = null
	# Weirdly, "res_loader = null" is needed as otherwise
	# loading the resource again is not possible.


func _on_play_pressed():
	Settings.game_state = Settings.GameState.LOADING
	loading.show()
	var path = "res://level/level.tscn"
	if ResourceLoader.has_cached(path):
		emit_signal("replace_main_scene", ResourceLoader.load(path))
	else:
		res_loader = ResourceLoader.load_interactive(path)
		loading_thread = Thread.new()
		#warning-ignore:return_value_discarded
		loading_thread.start(self, "interactive_load", res_loader)

func _on_quit_pressed():
	get_tree().quit()

func _on_UI_loading_completed():
	loading_done(res_loader)
