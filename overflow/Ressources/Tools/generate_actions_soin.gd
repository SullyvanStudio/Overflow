@tool
extends EditorScript

const OUTPUT_DIR := "res://BackEnd/Ressources/ActionsSoin/"
const RESSOURCES_DIR := "res://BackEnd/Ressources/RessourcesSoin/"

func _run() -> void:
	var data := [
		{
			"fichier": "examen_clinique", "nom": "Examen clinique",
			"ressource": "medecin.tres", "duree": 2, "pause": false, "est_prescriptible" :true
		},
		{
			"fichier": "interpretation_ecg", "nom": "Interprétation ECG",
			"ressource": "medecin.tres", "duree": 2, "pause": false, "est_prescriptible" :false
		},
		{
			"fichier": "ecg", "nom": "ECG",
			"ressource": "ide.tres", "duree": 1, "pause": true,
			"action_suivante": "interpretation_ecg", "est_prescriptible" :true
		},
	]
	for entry in data:
		var action := ActionSoin_base.new()
		action.nom = entry.nom
		action.ressource_requise = load(RESSOURCES_DIR + entry.ressource) as Ressource_base
		action.duree_tours = entry.duree
		action.necessite_pause = entry.pause
		action.est_prescriptible = entry.est_prescriptible

		if entry.has("action_suivante"):
			var chemin : String = OUTPUT_DIR + entry.action_suivante + ".tres"
			action.action_suivante_auto = load(chemin) as ActionSoin_base
			if action.action_suivante_auto == null:
				push_error("Action suivante introuvable : %s (doit être générée AVANT dans get_data())" % chemin)

		var path : String = OUTPUT_DIR + entry.fichier + ".tres"
		var err := ResourceSaver.save(action, path)
		print("Créé : ", path) if err == OK else push_error("Échec : %s" % path)
