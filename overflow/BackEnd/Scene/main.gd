extends Node2D
class_name Main

@export_category("Node")
@export var normal_layer : CanvasLayer
@export var main_menu : MainMenu
@export var gameloop : GameLoop
@export var game_scenes : Control


enum STATE {MAIN_MENU, NEW_GAME, GAME}
signal state_changed(old_state, new_state)
var state : STATE = STATE.MAIN_MENU :
	set(new_state):
		if state!= new_state:
			var old_state = state
			state = new_state
			state_changed.emit(old_state, state)


func _ready() -> void:
	var __ = main_menu.game_started.connect(_game_started_asked)
	__ = state_changed.connect(_on_state_changed)
	setup_game_loop()

func _on_state_changed(old_state, new_state) -> void:
	match old_state :
		STATE.MAIN_MENU:
			main_menu.hide()
		STATE.NEW_GAME:
			pass
		STATE.GAME:
			game_scenes.hide()
	match new_state:
		STATE.MAIN_MENU:
			main_menu.show()
		STATE.NEW_GAME:
			gameloop.game_state = gameloop.GAME_STATE.INIT
		STATE.GAME:
			game_scenes.show()

func setup_game_loop() -> void:
	gameloop.parent_scene = game_scenes

func _game_started_asked() -> void:
	state = STATE.NEW_GAME
	gameloop.game_state = GameLoop.GAME_STATE.INIT



func _on_game_loop_game_state_changed(_state: GameLoop.GAME_STATE) -> void:
	match _state :
		GameLoop.GAME_STATE.NULL :
			print("pas de partie en cours")
		GameLoop.GAME_STATE.INIT :
			state = STATE.NEW_GAME
			print("initialisation gameloop")
		GameLoop.GAME_STATE.PAUSED :
			print("gameloop paused")
		GameLoop.GAME_STATE.RUN :
			state = STATE.GAME
			print("gameloop RUN")
