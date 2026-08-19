@tool
extends EditorScript

const OUTPUT_DIR := "res://BackEnd/Ressources/Pathologies/"
const SYMPTOMES_DIR := "res://BackEnd/Ressources/Symptomes/"
const CONSTANTES_DIR := "res://BackEnd/Ressources/Constantes/"

func _run() -> void:
	var data := get_data()
	for entry in data:
		var patho := Pathologie_base.new()
		patho.nom = entry.nom
		patho.gravite_intrinseque = entry.gravite

		var symptomes : Array[Symptome_base] = []
		for s in entry.symptomes:
			symptomes.append(load(SYMPTOMES_DIR + s) as Symptome_base)
		patho.symptomes_array = symptomes

		var ranges : Array[PathologieConstanteRange] = []
		for r in entry.get("constantes_perturbees", []):
			var range_res := PathologieConstanteRange.new()
			range_res.constante = load(CONSTANTES_DIR + r.constante) as Constante_base
			range_res.valeur_min = r.min
			range_res.valeur_max = r.max
			ranges.append(range_res)
		patho.constantes_perturbees = ranges

		verifier_tension_coherente(entry.nom, entry.get("constantes_perturbees", []))

		var path : String = OUTPUT_DIR + entry.fichier + ".tres"
		var err := ResourceSaver.save(patho, path)
		if err == OK:
			print("Créé : ", path)
		else:
			push_error("Échec sauvegarde : %s (code %d)" % [path, err])

	print("Terminé. %d pathologies générées." % data.size())


## Avertit si systolique est perturbée sans diastolique (ou l'inverse) —
## une tension incohérente (ex: 180/60) sans intention explicite est un piège classique.
func verifier_tension_coherente(nom_pathologie : String, ranges : Array) -> void:
	var noms_constantes : Array = []
	for r in ranges:
		noms_constantes.append(r.constante)

	var a_systolique := noms_constantes.has("tension_systolique.tres")
	var a_diastolique := noms_constantes.has("tension_diastolique.tres")

	if a_systolique and not a_diastolique:
		push_warning("%s : tension systolique perturbée sans diastolique définie." % nom_pathologie)
	elif a_diastolique and not a_systolique:
		push_warning("%s : tension diastolique perturbée sans systolique définie." % nom_pathologie)


func get_data() -> Array:
	return [
		{
			"fichier": "pneumopathie",
			"nom": "Pneumopathie",
			"gravite": 40,
			"symptomes": ["toux.tres", "douleur_poitrine.tres", "fievre.tres"],
			"constantes_perturbees": [
				{"constante": "temperature.tres", "min": 38.0, "max": 40.9},
				{"constante": "saturation.tres", "min": 85.0, "max": 93.0},
			]
		},
		{
			"fichier": "embolie_pulmonaire",
			"nom": "Embolie Pulmonaire",
			"gravite": 60,
			"symptomes": ["douleur_poitrine.tres"],
			"constantes_perturbees": [
				{"constante": "saturation.tres", "min": 80.0, "max": 93.0},
				{"constante": "douleur.tres", "min": 1.0, "max": 5.0},
				{"constante": "pouls.tres", "min": 100, "max": 180},
				{"constante": "frequence_respiratoire.tres", "min": 13, "max": 18},
				{"constante": "tension_systolique.tres", "min": 85.0, "max": 100.0},
				{"constante": "tension_diastolique.tres", "min": 50.0, "max": 65.0},
			]
		},
		# ... ajoutez une entrée par pathologie
	]
