extends Node2D
class_name Main

@export_category("Node")

@export var scene_manager : SceneManager
@export var game_loop : GameLoop

signal main_menu_visible(visible : bool)

enum STATE {NULL, MAIN_MENU, NEW_GAME, GAME}
signal state_changed(old_state, new_state)
var state : STATE = STATE.NULL :
	set(new_state):
		if state!= new_state:
			var old_state = state
			state = new_state
			state_changed.emit(old_state, state)

func _ready() -> void:
	state_changed.connect(_on_state_changed)
	scene_manager.setup(game_loop)
	call_deferred("ready_finish")
func ready_finish() -> void:
	state = STATE.MAIN_MENU

func _on_state_changed(old_state, new_state) -> void:
	match old_state :
		STATE.NULL : pass
		STATE.MAIN_MENU: main_menu_visible.emit(false)
		STATE.NEW_GAME: pass
		STATE.GAME:pass#game_scenes.hide()
	match new_state:
		STATE.MAIN_MENU: main_menu_visible.emit(true)
		STATE.NEW_GAME:setup_new_game()
		STATE.GAME:pass#game_scenes.show()

func setup_new_game()-> void:
	game_loop.game_state = GameLoop.GAME_STATE.INIT
	game_loop.create_new_game()


func _on_main_menu_game_started() -> void:
	state = STATE.NEW_GAME
