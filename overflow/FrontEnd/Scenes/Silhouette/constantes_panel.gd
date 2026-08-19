extends Control

@export var constantes_etiquette_scene : PackedScene
@export var grid_container : GridContainer


var constantes_etiquette_array: Array = []
var patient_constantes : PatientConstantes:
	set(value):
		if value != patient_constantes:
			patient_constantes = value
			constante_changed()

func constante_changed() -> void:
	var constantes_triees := PathologieLoader.constantes.duplicate()
	constantes_triees.sort_custom(func(a, b): return a.ordre_affichage < b.ordre_affichage)
	for constante in constantes_triees:
		var valeur = patient_constantes.get_valeur(constante)
		creer_constante(constante, valeur)

func creer_constante(constante, valeur) -> void:
	var constante_node = constantes_etiquette_scene.instantiate()
	var format_string : String = "%%.%df %%s" % constante.decimales
	constante_node.label.text = format_string % [valeur, constante.unite]
	constante_node.texture.texture = constante.texture
	grid_container.add_child(constante_node)
