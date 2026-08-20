@tool
extends EditorScript

const OUTPUT_DIR := "res://BackEnd/Ressources/RessourcesSoin/"

func _run() -> void:
	var data := [
		{"fichier": "medecin", "nom": "Médecin", "quantite": 1},
		{"fichier": "ide", "nom": "IDE", "quantite": 2},
	]
	for entry in data:
		var res := Ressource_base.new()
		res.nom = entry.nom
		res.quantite = entry.quantite
		var path : String = OUTPUT_DIR + entry.fichier + ".tres"
		var err := ResourceSaver.save(res, path)
		print("Créé : ", path) if err == OK else push_error("Échec : %s" % path)
