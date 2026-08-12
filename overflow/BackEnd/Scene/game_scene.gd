extends Node2D
class_name GameScene

@export_category("Node")
@export var normal_layer : CanvasLayer
@export var main_menu : MainMenu
@export_category("Scene")
@export var scene_triage : PackedScene
@export_category("Variables")
@export var duree_choix_tri : int = 10

var patients_manager : PatientsManager = null

func _ready() -> void:
	var __ = main_menu.game_started.connect(_game_started_asked)
	__ = Signalbus.connect("patient_picked", _on_patient_picked)

func _game_started_asked() -> void:
	main_menu.hide()
	create_new_game()

func create_new_game() -> void:
	patients_manager = PatientsManager.new()
	var game_scene = scene_triage.instantiate()
	game_scene.time = duree_choix_tri
	game_scene.liste_patients = patients_manager.patients_list
	normal_layer.add_child(game_scene)
	
	

func _on_patient_picked(_patient)-> void:
	patients_manager.current_patient = _patient
