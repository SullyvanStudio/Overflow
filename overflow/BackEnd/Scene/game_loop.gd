extends Node2D
class_name GameLoop

signal game_time_changed(time : GAME_TIME)
enum GAME_TIME {ARRETE, NORMAL, RAPIDE, TRIAGE}
var game_time : GAME_TIME = GAME_TIME.NORMAL:
	set(new_value):
		if new_value != game_time:
			game_time = new_value
			game_time_changed.emit(game_time)
const TIME : Dictionary[GAME_TIME, float] = {
	GAME_TIME.ARRETE : 0.0,
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

signal triage_demande(liste_patient : Array[PatientData], duree : float)
signal patient_choisi(patient : PatientData)
signal service_pret(gestionaire_soin : GestionnaireFilesAttente)

var patients_manager : PatientsManager = null
var gestionnaire_soins : GestionnaireFilesAttente = null
var score_total : float = 0.0
var nombre_choix : int = 0

var tableau_service : TableauService = null
var current_scene = null

func _ready() -> void:
	Signalbus.patient_picked.connect(_on_patient_picked)
	Signalbus.nouveau_tour.connect(_on_temps_ecoule)
	Signalbus.game_speed.connect(_on_game_speed)
	game_time_changed.connect(_on_game_time_changed)
	game_state_changed.connect(_on_game_state_changed)

func create_new_game() -> void:
	
	patients_manager = PatientsManager.new()
	gestionnaire_soins = GestionnaireFilesAttente.new()
	
	patients_manager.choix_evalue.connect(_on_choix_evalue)
	patients_manager.patient_parti.connect(_on_patient_parti)
	# plus de mutation d'état ici — juste du setup
	call_deferred("_finish_init")

func _finish_init() -> void:
	service_pret.emit(gestionnaire_soins)
	setup_timer()
	game_state = GAME_STATE.RUN


#region TIMER
func setup_timer() -> void:
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start(TIME[GAME_TIME.NORMAL])

func _on_game_time_changed(value : GAME_TIME) -> void:
	if value == GAME_TIME.ARRETE:
			game_state = GAME_STATE.PAUSED
	update_timer()

func update_timer() -> void:
	timer.paused = (game_time == GAME_TIME.ARRETE)
	if game_time != GAME_TIME.ARRETE:
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
			print("GameLoop State : Init")
			create_new_game()
		GAME_STATE.RUN :
			print("GameLoop State : Run")
			update_timer()
		GAME_STATE.PAUSED :
			print("GameLoop State : Paused")
			# attention , la pause doit être faite à partir du game_time
			update_timer()
		_ : 
			printerr("GameLoop State : error")


func _on_patient_parti(patient : PatientData) -> void:
	print("Le patient (%s) est parti, impatience atteinte." % patient.get_pathologie_string())
	# Pénalité au score global à appliquer ici

func _on_patient_picked(_patient)-> void:
	patients_manager.current_patient = _patient
	patient_choisi.emit(_patient)

func _on_game_speed(speed : GAME_TIME)-> void:
	if game_time != speed:
		game_time = speed

func _on_choix_evalue(resultat : Dictionary) -> void:
	score_total += resultat.performance
	nombre_choix += 1
	print("Choix évalué : %d/%d pts -> %.0f%% (%s)" % [
		resultat.score_choisi, resultat.score_max,
		resultat.performance, resultat.qualification
	])
	print("Score moyen du joueur : %.0f%%" % (score_total / nombre_choix))
