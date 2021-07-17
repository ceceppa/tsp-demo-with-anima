tool
extends Control
class_name AnimaShape

func animate(anima_data: Dictionary, auto_play := true) -> AnimaNode:
	var anima: AnimaNode = Anima.begin(self)

	anima.then(anima_data)

	if auto_play:
		anima.play()

	return anima
