extends PanelContainer

func _on_pause_button_pressed() -> void:
	Signalbus.game_speed.emit(GameLoop.GAME_TIME.ARRETE)

func _on_play_button_pressed() -> void:
	Signalbus.game_speed.emit(GameLoop.GAME_TIME.NORMAL)


func _on_rapide_button_pressed() -> void:
	Signalbus.game_speed.emit(GameLoop.GAME_TIME.RAPIDE)
