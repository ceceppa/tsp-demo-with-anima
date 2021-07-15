extends TextureRect

signal play
signal quit

var _viewport: Viewport

func _ready():
	_viewport = get_parent().find_node('Viewport')
	
	var bg: AnimaNode = $Main/MenuBG.animate({ property = "rect:size:y", to = 100, duration = 0.3, delay = 0.3 }, false)

	$AnimaPlayer.then(bg)
	$AnimaPlayer.then($Main/MenuBG/TPSDemoLabel.get_anima_node())
	$AnimaPlayer.then($Main/MenuBG/VBoxContainer/Play.get_initial_animation())
	$AnimaPlayer.with($Main/MenuBG/VBoxContainer/Settings.get_initial_animation(), 0.1)
	$AnimaPlayer.with($Main/MenuBG/VBoxContainer/Quit.get_initial_animation(), 0.2)

	$AnimaPlayer.play()
	
func _draw():
	if not _viewport:
		return

	draw_texture(_viewport.get_texture(), Vector2.ZERO)

func _on_Play_clicked():
	emit_signal("play")

func _on_Quit_clicked():
	emit_signal("quit")
