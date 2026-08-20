extends RefCounted
class_name ActionInstance

enum ETAT { EN_ATTENTE, EN_COURS, TERMINEE }

var action_template : ActionSoin_base
var patient : PatientData
var etat : ETAT = ETAT.EN_ATTENTE
var tour_debut : int = -1
var tour_fin_prevu : int = -1

signal terminee(instance : ActionInstance)
signal chainage_demande(action_suivante : ActionSoin_base, patient : PatientData)

func _init(_action_template : ActionSoin_base, _patient : PatientData) -> void:
	action_template = _action_template
	patient = _patient

func demarrer(tour_actuel : int) -> void:
	etat = ETAT.EN_COURS
	tour_debut = tour_actuel
	tour_fin_prevu = tour_actuel + action_template.duree_tours

func avancer_tour(tour_actuel : int) -> void:
	if etat == ETAT.EN_COURS and tour_actuel >= tour_fin_prevu:
		etat = ETAT.TERMINEE
		terminee.emit(self)
		if action_template.action_suivante_auto:
			chainage_demande.emit(action_template.action_suivante_auto, patient)
