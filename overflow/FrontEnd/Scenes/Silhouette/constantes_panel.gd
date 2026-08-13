extends Control

@export var constantes_etiquette_scene : PackedScene
@export var grid_container : GridContainer


var constantes_etiquette_array: Array = []
var patient_constantes : PatientConstantes:
	set(value):
		if value!= patient_constantes:
			patient_constantes = value
			constante_changed()

func constante_changed() -> void:
	for constante in PathologieLoader.constantes:
		var valeur = patient_constantes.get_valeur(constante)
		var palier = patient_constantes.get_palier(constante)
		var _palier_nom = palier.nom if palier else "hors paliers définis"
		creer_constante(constante, valeur)

func creer_constante(constante, valeur) -> void:
	var constante_node = constantes_etiquette_scene.instantiate()
	var string : String = "%.1f %s" % [valeur, constante.unite]
	constante_node.label.text = string
	constante_node.texture.texture = constante.texture
	grid_container.add_child(constante_node)
