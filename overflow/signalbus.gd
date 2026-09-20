extends Node

@warning_ignore_start("unused_signal")
# envoyé par le backend
signal liste_patient_changed(list :Array[PatientData])
signal gestionnaire_soins_pret(gestionnaire : GestionnaireFilesAttente)
signal new_box_instance(box : BoxInstance) # envoyé par boxinstance.gd
signal action_mise_en_file(instance : ActionInstance) #envoyé par file_attente_ressources
signal nouvelle_action_demarree(instance : ActionInstance, unite_designe : UniteRessource) # envoyé par actions_instance

signal nouveau_tour()
var tour : int = 0:
	set(new):
		if tour != new:
			tour = new
			nouveau_tour.emit()


## envoyé par le front
signal patient_picked(patient :PatientData)
signal prescriptions_picked(array_pres : Array[PrescriptionsInstance])
signal game_speed(speed : GameLoop.GAME_TIME)
