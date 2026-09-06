extends Node2D
class_name GameLoop


@export_category("Scene")
@export var scene_triage : PackedScene
@export var scene_patient_resume : PackedScene
@export var scene_tableau_service : PackedScene
@export_category("Variables")

var parent_scene : Control

signal game_time_changed(time : GAME_TIME)
enum GAME_TIME {PAUSED, NORMAL, RAPIDE, TRIAGE}
var game_time : GAME_TIME = GAME_TIME.NORMAL:
	set(new_value):
		if new_value != game_time:
			game_time = new_value
			game_time_changed.emit(game_time)
const TIME : Dictionary[GAME_TIME, float] = {
	GAME_TIME.PAUSED : 0.0,
	GAME_TIME.NORMAL : 3.0,
	GAME_TIME.RAPIDE : 2.0,
	GAME_TIME.TRIAGE : 10.0
	}
var timer : Timer

signal game_state_changed(state : GAME_STATE)
enum GAME_STATE {NULL, INIT, PAUSED, RUN}
var game_state : GAME_STATE = GAME_STATE.NULL:
	set(new_state):
		if new_state != game_state:
			game_state = new_state
			game_state_changed.emit(game_state)

var patients_manager : PatientsManager = null
var gestionnaire_soins : GestionnaireFilesAttente = null
var score_total : float = 0.0
var nombre_choix : int = 0

var tableau_service : TableauService = null
var current_scene = null

func _ready() -> void:
	var __ = Signalbus.connect("patient_picked", _on_patient_picked)
	__ = Signalbus.connect("nouveau_tour", _on_temps_ecoule)
	game_time_changed.connect(_on_game_time_changed)
	game_state_changed.connect(_on_game_state_changed)

func create_new_game() -> void:
	setup_tableau_service()
	setup_timer()
	patients_manager = PatientsManager.new()
	gestionnaire_soins = GestionnaireFilesAttente.new()
	var __ = patients_manager.choix_evalue.connect(_on_choix_evalue)
	__ = patients_manager.patient_parti.connect(_on_patient_parti)
	# plus de mutation d'état ici — juste du setup
	call_deferred("_finish_init")

func _finish_init() -> void:
	Signalbus.gestionnaire_soins_pret.emit(gestionnaire_soins)
	game_state = GAME_STATE.RUN

func setup_tableau_service() -> void:
	tableau_service = scene_tableau_service.instantiate()
	parent_scene.add_child(tableau_service)

#region TIMER
func setup_timer() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start(TIME[GAME_TIME.NORMAL])

func _on_game_time_changed(value : GAME_TIME) -> void:
	if value == GAME_TIME.PAUSED:
			game_state = GAME_STATE.PAUSED
	update_timer()

func update_timer() -> void:
	timer.paused = (game_time == GAME_TIME.PAUSED)
	if game_time != GAME_TIME.PAUSED:
		timer.wait_time = TIME[game_time]

func _on_timer_timeout() -> void:
	Signalbus.tour += 1

func _on_temps_ecoule() -> void:
	patients_manager.nouveau_tour()
	gestionnaire_soins.nouveau_tour()
	# À vous d'ajouter ici la logique de relance du tour suivant
	# (nouvelle barre de progression, nouveaux patients, etc.)
#endregion

func _on_game_state_changed(_state : GAME_STATE):
	match game_state:
		GAME_STATE.INIT :
			create_new_game()
		GAME_STATE.RUN :
			update_timer()
			add()
		GAME_STATE.PAUSED :
			update_timer()

func add() -> void:
	current_scene = scene_triage.instantiate()
	current_scene.time = TIME[GAME_TIME.TRIAGE]
	current_scene.liste_patients = patients_manager.patients_triage_list
	var __ = current_scene.temps_ecoule.connect(_on_temps_ecoule)
	parent_scene.add_child(current_scene)

func _on_patient_parti(patient : PatientData) -> void:
	print("Le patient (%s) est parti, impatience atteinte." % patient.get_pathologie_string())
	# Pénalité au score global à appliquer ici

func _on_patient_picked(_patient)-> void:
	patients_manager.current_patient = _patient
	if current_scene :
		current_scene.queue_free()
	current_scene = scene_patient_resume.instantiate()
	parent_scene.add_child(current_scene)
	current_scene.patient = _patient
	
func _on_choix_evalue(resultat : Dictionary) -> void:
	score_total += resultat.performance
	nombre_choix += 1
	print("Choix évalué : %d/%d pts -> %.0f%% (%s)" % [
		resultat.score_choisi, resultat.score_max,
		resultat.performance, resultat.qualification
	])
	print("Score moyen du joueur : %.0f%%" % (score_total / nombre_choix))
