extends RefCounted
class_name PatientConstantes

var valeurs : Dictionary = {}  # Constante_base -> float

func generer(pathologie: Pathologie_base, symptomes: Array[Symptome_base], toutes_les_constantes: Array[Constante_base]) -> void:
	for constante in toutes_les_constantes:
		var range_patho := trouver_range_pathologie(constante, pathologie)
		var valeur : float
		if range_patho:
			valeur = randf_range(range_patho.valeur_min, range_patho.valeur_max)
		elif constante_liee_a_symptome(constante, symptomes):
			# Le patient affiche un symptôme lié (ex: fièvre) mais la pathologie
			# n'a pas précisé de plage : on force une valeur anormale légère
			# plutôt qu'une valeur normale incohérente avec le symptôme visible.
			valeur = valeur_palier_anormal_par_defaut(constante)
		else:
			valeur = randf_range(constante.valeur_normale_min, constante.valeur_normale_max)
		valeurs[constante] = valeur

func trouver_range_pathologie(constante: Constante_base, pathologie: Pathologie_base) -> PathologieConstanteRange:
	for r in pathologie.constantes_perturbees:
		if r.constante == constante:
			return r
	return null

func constante_liee_a_symptome(constante: Constante_base, symptomes: Array[Symptome_base]) -> bool:
	for symp in symptomes:
		if symp.constante_associee == constante:
			return true
	return false

func valeur_palier_anormal_par_defaut(constante: Constante_base) -> float:
	for palier in constante.paliers:
		if palier.gravite != "normal":
			return randf_range(palier.valeur_min, palier.valeur_max)
	return randf_range(constante.valeur_normale_min, constante.valeur_normale_max)

func get_valeur(constante: Constante_base) -> float:
	return valeurs.get(constante, 0.0)

func get_palier(constante: Constante_base) -> PalierConstante:
	var p := constante.get_palier(get_valeur(constante))
	return p
