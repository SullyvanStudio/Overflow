@tool
extends EditorScript

const OUTPUT_DIR := "res://BackEnd/Ressources/Constantes/"
const TEXTURE_DIR := "res://FrontEnd/Ressources/Images/icone/"

func _run() -> void:
	var data : Array = get_data()
	for entry in data:
		var constante := Constante_base.new()
		constante.nom = entry.nom
		constante.unite = entry.unite
		constante.valeur_normale_min = entry.normale_min
		constante.valeur_normale_max = entry.normale_max
		constante.decimales = entry.get("decimales", 0)
		constante.ordre_affichage = entry.get("ordre_affichage", 0)
		constante.texture = load(TEXTURE_DIR + entry.fichier + ".png") as Texture2D

		var paliers : Array[PalierConstante] = []
		for p in entry.paliers:
			var palier := PalierConstante.new()
			palier.nom = p.nom
			palier.valeur_min = p.min
			palier.valeur_max = p.max
			palier.gravite = p.gravite
			paliers.append(palier)
		constante.paliers = paliers

		var path : String = OUTPUT_DIR + entry.fichier + ".tres"
		var err := ResourceSaver.save(constante, path)
		if err == OK:
			print("Créé : ", path)
		else:
			push_error("Échec sauvegarde : %s (code %d)" % [path, err])

	print("Terminé. %d constantes générées." % data.size())


func get_data() -> Array:
	return [
		{
			"fichier": "temperature", "nom": "Température", "unite": "°C",
			"normale_min": 36.1, "normale_max": 37.5,
			"decimales": 1, "ordre_affichage": 0,
			"paliers": [
				{"nom": "Hypothermie sévère", "min": 28.0, "max": 32.0, "gravite": "critique"},
				{"nom": "Hypothermie légère", "min": 32.0, "max": 36.0, "gravite": "leger"},
				{"nom": "Normal", "min": 36.1, "max": 37.5, "gravite": "normal"},
				{"nom": "Hyperthermie modérée", "min": 38.0, "max": 39.0, "gravite": "modere"},
				{"nom": "Hyperthermie forte", "min": 39.0, "max": 40.9, "gravite": "severe"},
			]
		},
		{
			"fichier": "pouls", "nom": "Pouls", "unite": "bpm",
			"normale_min": 60.0, "normale_max": 100.0,
			"decimales": 0, "ordre_affichage": 1,
			"paliers": [
				{"nom": "Bradycardie sévère", "min": 20.0, "max": 40.0, "gravite": "critique"},
				{"nom": "Bradycardie légère", "min": 40.0, "max": 59.0, "gravite": "leger"},
				{"nom": "Normal", "min": 60.0, "max": 100.0, "gravite": "normal"},
				{"nom": "Tachycardie modérée", "min": 101.0, "max": 120.0, "gravite": "modere"},
				{"nom": "Tachycardie sévère", "min": 121.0, "max": 180.0, "gravite": "severe"},
			]
		},
		{
			"fichier": "tension_systolique", "nom": "Tension systolique", "unite": "mmHg",
			"normale_min": 100.0, "normale_max": 139.0,
			"decimales": 0, "ordre_affichage": 2,
			"paliers": [
				{"nom": "Hypotension sévère", "min": 50.0, "max": 69.0, "gravite": "critique"},
				{"nom": "Hypotension légère", "min": 70.0, "max": 99.0, "gravite": "leger"},
				{"nom": "Normal", "min": 100.0, "max": 139.0, "gravite": "normal"},
				{"nom": "HTA modérée", "min": 140.0, "max": 179.0, "gravite": "modere"},
				{"nom": "HTA sévère", "min": 180.0, "max": 260.0, "gravite": "severe"},
			]
		},
		{
			"fichier": "tension_diastolique", "nom": "Tension diastolique", "unite": "mmHg",
			"normale_min": 60.0, "normale_max": 89.0,
			"decimales": 0, "ordre_affichage": 3,
			"paliers": [
				{"nom": "Hypotension sévère", "min": 30.0, "max": 39.0, "gravite": "critique"},
				{"nom": "Hypotension légère", "min": 40.0, "max": 59.0, "gravite": "leger"},
				{"nom": "Normal", "min": 60.0, "max": 89.0, "gravite": "normal"},
				{"nom": "HTA modérée", "min": 90.0, "max": 109.0, "gravite": "modere"},
				{"nom": "HTA sévère", "min": 110.0, "max": 150.0, "gravite": "severe"},
			]
		},
		{
			"fichier": "frequence_respiratoire", "nom": "Fréquence respiratoire", "unite": "/min",
			"normale_min": 12.0, "normale_max": 20.0,
			"decimales": 0, "ordre_affichage": 4,
			"paliers": [
				{"nom": "Bradypnée sévère", "min": 4.0, "max": 8.0, "gravite": "critique"},
				{"nom": "Bradypnée légère", "min": 9.0, "max": 11.0, "gravite": "leger"},
				{"nom": "Normal", "min": 12.0, "max": 20.0, "gravite": "normal"},
				{"nom": "Tachypnée modérée", "min": 21.0, "max": 30.0, "gravite": "modere"},
				{"nom": "Tachypnée sévère", "min": 31.0, "max": 45.0, "gravite": "severe"},
			]
		},
		{
			"fichier": "saturation", "nom": "Saturation", "unite": "%",
			"normale_min": 95.0, "normale_max": 100.0,
			"decimales": 0, "ordre_affichage": 5,
			"paliers": [
				{"nom": "Désaturation critique", "min": 70.0, "max": 84.0, "gravite": "critique"},
				{"nom": "Désaturation sévère", "min": 85.0, "max": 91.0, "gravite": "severe"},
				{"nom": "Désaturation modérée", "min": 92.0, "max": 94.0, "gravite": "modere"},
				{"nom": "Normal", "min": 95.0, "max": 100.0, "gravite": "normal"},
			]
		},
		{
			"fichier": "glycemie", "nom": "Glycémie", "unite": "g/L",
			"normale_min": 0.7, "normale_max": 1.1,
			"decimales": 1, "ordre_affichage": 6,
			"paliers": [
				{"nom": "Hypoglycémie sévère", "min": 0.2, "max": 0.4, "gravite": "critique"},
				{"nom": "Hypoglycémie légère", "min": 0.5, "max": 0.69, "gravite": "leger"},
				{"nom": "Normal", "min": 0.7, "max": 1.1, "gravite": "normal"},
				{"nom": "Hyperglycémie modérée", "min": 1.11, "max": 2.5, "gravite": "modere"},
				{"nom": "Hyperglycémie sévère", "min": 2.51, "max": 6.0, "gravite": "severe"},
			]
		},
		{
			"fichier": "douleur", "nom": "Douleur", "unite": "/10",
			"normale_min": 0.0, "normale_max": 2.0,
			"decimales": 0, "ordre_affichage": 7,
			"paliers": [
				{"nom": "Absente", "min": 0.0, "max": 2.0, "gravite": "normal"},
				{"nom": "Légère", "min": 3.0, "max": 4.0, "gravite": "leger"},
				{"nom": "Modérée", "min": 5.0, "max": 6.0, "gravite": "modere"},
				{"nom": "Sévère", "min": 7.0, "max": 8.0, "gravite": "severe"},
				{"nom": "Critique", "min": 9.0, "max": 10.0, "gravite": "critique"},
			]
		},
	]
