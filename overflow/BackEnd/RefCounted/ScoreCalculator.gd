extends RefCounted
class_name ScoreCalculator

## Points ajoutés selon la gravité du palier de constante atteint
const POINTS_PAR_GRAVITE : Dictionary = {
	"normal": 0,
	"leger": 5,
	"modere": 10,
	"severe": 15,
	"critique": 20,
}

const AGE_TERRAIN_SEUIL_BAS := 5
const AGE_TERRAIN_SEUIL_HAUT := 75
const POINTS_TERRAIN_AGE := 10

static func calculer_score(patient : PatientData) -> int:
	var score := 0
	score += score_pathologie(patient)
	score += score_constantes(patient)
	score += score_terrain(patient)
	return score

static func score_pathologie(patient : PatientData) -> int:
	var pathologie := patient.get_pathologie()
	if pathologie == null:
		return 0
	return pathologie.gravite_intrinseque

static func score_constantes(patient : PatientData) -> int:
	var total :int = 0
	for constante in patient.constantes.valeurs.keys():
		var palier:PalierConstante = patient.get_constantes_context().get_palier(constante)
		if palier:
			total += POINTS_PAR_GRAVITE.get(palier.gravite, 0)
	return total

static func score_terrain(patient : PatientData) -> int:
	var age := patient.get_age()
	if age <= AGE_TERRAIN_SEUIL_BAS or age >= AGE_TERRAIN_SEUIL_HAUT:
		return POINTS_TERRAIN_AGE
	return 0
