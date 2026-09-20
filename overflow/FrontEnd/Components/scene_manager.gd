extends Control
class_name SceneManager

@export_category("PackedScenes")
@export var main_menu_scene : PackedScene
@export var triage_scene : PackedScene = preload("uid://dvnlbv4rfcf5m")
@export var patient_resume_scene : PackedScene = preload("uid://c2ptbsvckcufn")
@export var tableau_service_scene : PackedScene = preload("uid://ba6n7ntdvbjrl")
@export_category("Nodes")
@export var main : Main
@export var main_menu : MainMenu

@export_category("Layers")
@export var game_layer : CanvasLayer
@export var menu_layer : CanvasLayer


var tableau_service : Control = null
var current_scene : Control = null

func setup(game_loop : GameLoop) -> void:
	main.main_menu_visible.connect(_on_main_menu)
	game_loop.triage_demande.connect(_on_gameloop_triage_demande)
	game_loop.patient_choisi.connect(_on_gameloop_patient_choisi)
	game_loop.service_pret.connect(_on_gameloop_service_pret)

func _on_main_menu(_visible : bool) -> void:
	if _visible : main_menu.show()
	else : main_menu.hide()
	

func _on_gameloop_triage_demande(array_patient : Array[PatientData], duree : float) -> void:
	if current_scene : current_scene.queue_free()
	current_scene = triage_scene.instantiate()
	current_scene.time = duree
	current_scene.liste_patients = array_patient
	
	current_scene.temps_ecoule.connect(func(): Signalbus.nouveau_tour.emit())
	game_layer.add_child(current_scene)

func _on_gameloop_patient_choisi(patient : PatientData) -> void:
	if current_scene : current_scene.queue_free()
	current_scene = patient_resume_scene.instantiate()
	
	current_scene.patient = patient
	game_layer.add_child(current_scene)

func _on_gameloop_service_pret(_gestionnaire : GestionnaireFilesAttente) -> void:
	tableau_service = tableau_service_scene.instantiate()
	
	game_layer.add_child(tableau_service)
