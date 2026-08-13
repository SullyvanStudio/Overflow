@tool
extends EditorScript

const OUTPUT_DIR := "res://BackEnd/Ressources/Symptomes/"
const TEXTURE_DIR := "res://Ressources/Pictogramme_symptomes/"
const CONSTANTES_DIR := "res://BackEnd/Ressources/Constantes/"

func _run() -> void:
	var data : Array= get_data()
	for entry in data:
		var symp := Symptome_base.new()
		symp.nom = entry.nom
		symp.zone_atteinte = entry.zone
		symp.have_indicateur = entry.get("indicateur", true)

		if entry.has("texture"):
			symp.texture = load(TEXTURE_DIR + entry.texture) as Texture2D

		if entry.has("constante"):
			symp.constante_associee = load(CONSTANTES_DIR + entry.constante) as Constante_base

		var path :String = OUTPUT_DIR + entry.fichier + ".tres"
		var err := ResourceSaver.save(symp, path)
		if err == OK:
			print("Créé : ", path)
		else:
			push_error("Échec sauvegarde : %s (code %d)" % [path, err])

	print("Terminé. %d symptômes générés." % data.size())


func get_data() -> Array:
	return [
		{
			"fichier": "fievre",
			"nom": "Fièvre",
			"zone": "abdomen",
			"texture": "pictogramme_fievre.png",
			"constante": "temperature.tres",
			"indicateur": false,
		},
		{
			"fichier": "toux",
			"nom": "Toux",
			"zone": "poitrine",
			"texture": "pictogramme_toux.png",
			"indicateur": true,
		},
		{
			"fichier": "douleur_poitrine",
			"nom": "Douleur Poitrine",
			"zone": "poitrine",
			"texture": "pictogramme_douleur_poitrine.png",
			"indicateur": true,}
		# ... ajoutez une entrée par symptôme
	]
