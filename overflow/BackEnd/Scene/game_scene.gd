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
var score_total : float = 0.0
var nombre_choix : int = 0

func _ready() -> void:
	var __ = main_menu.game_started.connect(_game_started_asked)
	__ = Signalbus.connect("patient_picked", _on_patient_picked)

func _game_started_asked() -> void:
	main_menu.hide()
	create_new_game()

func create_new_game() -> void:
	patients_manager = PatientsManager.new()
	var __ = patients_manager.choix_evalue.connect(_on_choix_evalue)
	__ = patients_manager.patient_parti.connect(_on_patient_parti)
	var game_scene = scene_triage.instantiate()
	game_scene.time = duree_choix_tri
	game_scene.liste_patients = patients_manager.patients_list
	__ = game_scene.temps_ecoule.connect(_on_temps_ecoule)
	normal_layer.add_child(game_scene)

func _on_temps_ecoule() -> void:
	patients_manager.nouveau_tour()
	# À vous d'ajouter ici la logique de relance du tour suivant
	# (nouvelle barre de progression, nouveaux patients, etc.)

func _on_patient_parti(patient : PatientData) -> void:
	print("Le patient (%s) est parti, impatience atteinte." % patient.get_pathologie_string())
	# Pénalité au score global à appliquer ici

func _on_patient_picked(_patient)-> void:
	patients_manager.current_patient = _patient
	patients_manager.nouveau_tour()

func _on_choix_evalue(resultat : Dictionary) -> void:
	score_total += resultat.performance
	nombre_choix += 1
	print("Choix évalué : %d/%d pts -> %.0f%% (%s)" % [
		resultat.score_choisi, resultat.score_max,
		resultat.performance, resultat.qualification
	])
	print("Score moyen du joueur : %.0f%%" % (score_total / nombre_choix))
