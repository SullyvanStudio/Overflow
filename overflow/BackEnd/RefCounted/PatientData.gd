extends RefCounted
class_name PatientData


enum TYPE{HOMME, FEMME, ENFANT}
var type: TYPE = TYPE.HOMME
var age : int
enum SEX{MASCULIN, FEMININ}
var sex : SEX
var score_gravite : int = 0
var current_box : BoxInstance


var diagnostic_context : DiagnosticContext
var constantes : PatientConstantes
var patient_examen : PatientExamens
var differential_diagnosis : DifferentialDiagnosis

enum STATE {NULL, TRIAGE, EXAM, ATTENTE}
signal patient_state_changed()
var patient_state : STATE = STATE.NULL :
	set(new_state):
		if new_state != patient_state:
			patient_state = new_state
			patient_state_changed.emit()
var patient_state_string : String = ""

#---------------------------
# Impatience
var tours_attente : int = 0

const IMPATIENCE_BASE_CROISSANCE : float = 1.4
const IMPATIENCE_SEUIL_DEPART : float = 100.0
const IMPATIENCE_POIDS_DOULEUR : float = 1.0  # facteur additionnel max (à douleur=10)
# ---------------------------


func _init(_age : int, _sex : SEX):
	age = _age
	sex = _sex
	if age < 18 :
		type = TYPE.ENFANT
	else :
		match sex:
			SEX.MASCULIN:
				type = TYPE.HOMME
			SEX.FEMININ:
				type = TYPE.FEMME

	diagnostic_context = DiagnosticContext.new()
	constantes = PatientConstantes.new()
	patient_examen = PatientExamens.new()
	patient_examen.generer(get_pathologie(), LoaderNeeded.actions )
	constantes.generer(diagnostic_context.pathologie, diagnostic_context.symptomes_array, LoaderNeeded.constantes)
	score_gravite = ScoreCalculator.calculer_score(self)
	differential_diagnosis = DifferentialDiagnosis.new(self, LoaderNeeded.pathologies)
	patient_state_changed.connect(_on_patient_state_changed)

func _on_patient_state_changed() -> void:
	match patient_state :
		STATE.TRIAGE :
			patient_state_string = "en salle d'attente"
		STATE.EXAM :
			patient_state_string = "en examen"
		STATE.ATTENTE :
			patient_state_string = "en attente"
		_ :
			patient_state_string = "autre"

func get_state_string() -> String:
	return patient_state_string

func get_score_gravite() -> int:
	return score_gravite

func get_diagnostic_context() -> DiagnosticContext:
	return diagnostic_context

func get_constantes_context() -> PatientConstantes:
	return constantes

func get_pathologie() -> Pathologie_base:
	return diagnostic_context.pathologie

func get_differential_pathologies() -> Array:
	return differential_diagnosis.get_top_candidats()

func get_differential_diagnosis() -> DifferentialDiagnosis:
	return differential_diagnosis

func get_pathologie_string() -> String:
	return get_pathologie().nom

func get_symptomes_array() -> Array[Symptome_base]:
	return get_diagnostic_context().symptomes_array

func get_symptomes_array_string() -> Array[String]:
	var array : Array = get_symptomes_array().duplicate()
	var array_string : Array = []
	for symp in array:
		array_string.append(symp.nom)
	return array_string

func get_patient_examens() -> PatientExamens:
	return patient_examen

func get_age() -> int : 
	return age

func get_sex() -> SEX :
	return sex

#region --- Impatience ---
## À appeler une fois par tour tant que le patient n'est pas choisi.
func avancer_tour() -> void:
	tours_attente += 1

func get_douleur() -> float:
	var constante_douleur : Constante_base= LoaderNeeded.get_constante_by_name("Douleur")
	if constante_douleur == null:
		return 0.0
	return constantes.get_valeur(constante_douleur)

## La douleur majore la vitesse à laquelle l'impatience grimpe,
## sans jamais plus que doubler l'effet (douleur=10 -> x2).
func get_facteur_douleur() -> float:
	return 1.0 + (get_douleur() / 10.0) * IMPATIENCE_POIDS_DOULEUR

## Croissance exponentielle bornée pour éviter les valeurs qui explosent
## si le patient attend très longtemps (float overflow / valeurs absurdes).
func get_impatience() -> float:
	if tours_attente <= 0:
		return 0.0
	var croissance : float = pow(IMPATIENCE_BASE_CROISSANCE, tours_attente) - 1.0
	return min(croissance * get_facteur_douleur(), IMPATIENCE_SEUIL_DEPART * 2.0)

func veut_partir() -> bool:
	return get_impatience() >= IMPATIENCE_SEUIL_DEPART
#endregion
