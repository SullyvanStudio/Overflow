extends RefCounted
class_name GestionnaireFilesAttente

var files : Dictionary = {}  # Ressource_base -> FileAttenteRessource
var tour_actuel : int = 0

func _init() -> void:
	var __ = Signalbus.prescriptions_picked.connect(_on_prescriptions_asked)
	for ressource in LoaderNeeded.get_ressources_soins():
		obtenir_file(ressource) 
		
func obtenir_file(ressource : Ressource_base) -> FileAttenteRessource:
	if not files.has(ressource):
		files[ressource] = FileAttenteRessource.new(ressource)
	return files[ressource]

func get_files() -> Dictionary:
	return files

func prescrire(action_template : ActionSoin_base, patient : PatientData) -> ActionInstance:
	var instance := ActionInstance.new(action_template, patient)
	var __ = instance.chainage_demande.connect(_on_chainage_demande)
	__ = instance.terminee.connect(_on_action_terminee)
	obtenir_file(action_template.ressource_requise).ajouter_action(instance)
	return instance

func _on_action_terminee(instance : ActionInstance) -> void:
	var action := instance.action_template
	if not action.est_examen_diagnostique:
		return
	var resultat = instance.patient.get_patient_examens().get_resultat(action)
	instance.patient.get_differential_diagnosis().on_examen_resultat(action, resultat)

func _on_chainage_demande(action_suivante : ActionSoin_base, patient : PatientData) -> void:
	prescrire(action_suivante, patient)

func _on_prescriptions_asked(array : Array)-> void:
	for pres in array :
		prescrire(pres.action, pres.patient)

func nouveau_tour() -> void:
	tour_actuel += 1
	for file in files.values():
		file.avancer_tour(tour_actuel)
