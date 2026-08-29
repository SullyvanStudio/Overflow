extends RefCounted
class_name DifferentialDiagnosis

## Calcule un diagnostic différentiel à partir des symptômes observés ET des examens
## effectivement prescrits chez un patient. Ne dépend d'aucun node de scène : testable
## en isolation, comme DiagnosticContext.
##
## Logique en paliers (les examens priment sur les symptômes, comme en clinique réelle) :
##   1. EXCLUSION PAR SYMPTÔME : un symptome_ecartant présent -> score = 0.0
##   2. EXAMEN DISCRIMINANT : pour chaque candidate, si un examen discriminant a été
##      rendu -> soit il CONFIRME (le résultat révélé == cette candidate, score boosté
##      au-dessus de 1.0), soit il EXCLUT (résultat révélé != cette candidate, score = 0.0).
##      Le MÊME examen peut confirmer une candidate et en exclure une autre : un
##      angioscanner qui révèle une embolie pulmonaire confirme l'EP et exclut, dans le
##      même appel, une dissection aortique qui aurait aussi l'angioscanner en discriminant.
##   3. BASE : aucun examen discriminant rendu -> score de Dice classique sur les
##      symptômes (0-1).
##
## Formule Dice : score = 2 * |intersection| / (|symptomes_patient| + |symptomes_pathologie|)
## Symétrique entre "la pathologie explique le patient" et "le patient colle à la pathologie" ;
## évite qu'une pathologie à 1 seul symptôme décroche un score de 1.0 trivial.

const NB_CANDIDATS_DEFAUT := 4
const BONUS_CONFIRMATION := 1.0  # garantit qu'un candidat confirmé par examen passe
								   # toujours devant un candidat non confirmé

var symptomes_patient : Array[Symptome_base] = []
var resultats_examens : Dictionary = {}  # ActionSoin_base -> Pathologie_base | null,
										  # UNIQUEMENT les examens prescrits et rendus
var resultats : Array[Dictionary] = []   # [{ pathologie, score, raison }], trié score décroissant

func _init(patient : PatientData, pathologies_candidates : Array[Pathologie_base], _resultats_examens : Dictionary = {}) -> void:
	symptomes_patient = patient.get_symptomes_array()
	resultats_examens = _resultats_examens
	calculer(pathologies_candidates)

func calculer(pathologies_candidates : Array[Pathologie_base]) -> void:
	resultats.clear()
	for pathologie in pathologies_candidates:
		resultats.append(evaluer_pathologie(pathologie))
	resultats.sort_custom(func(a, b): return a.score > b.score)

func evaluer_pathologie(pathologie : Pathologie_base) -> Dictionary:
	if a_symptome_ecartant(pathologie):
		return {"pathologie": pathologie, "score": 0.0, "raison": "exclu_symptome"}

	var verdict := verdict_par_examen(pathologie)
	if verdict == "exclu":
		return {"pathologie": pathologie, "score": 0.0, "raison": "exclu_examen"}

	var score_dice := calculer_score_dice(pathologie)

	if verdict == "confirme":
		return {"pathologie": pathologie, "score": BONUS_CONFIRMATION + score_dice, "raison": "confirme_examen"}

	return {"pathologie": pathologie, "score": score_dice, "raison": "calcule"}

## Compare, pour chaque examen discriminant de cette pathologie et effectivement rendu,
## le résultat réel du patient à cette pathologie candidate précise.
func verdict_par_examen(pathologie : Pathologie_base) -> String:
	var a_ete_discriminant := false
	for action in pathologie.examens_discriminants:
		if not resultats_examens.has(action):
			continue  # pas prescrit / pas encore rendu : aucune information
		a_ete_discriminant = true
		if resultats_examens[action] == pathologie:
			return "confirme"
	if a_ete_discriminant:
		return "exclu"
	return "neutre"

func calculer_score_dice(pathologie : Pathologie_base) -> float:
	var intersection := compter_intersection(symptomes_patient, pathologie.symptomes_array)
	var total := symptomes_patient.size() + pathologie.symptomes_array.size()
	if total == 0:
		return 0.0
	return (2.0 * intersection) / float(total)

func a_symptome_ecartant(pathologie : Pathologie_base) -> bool:
	for symp in symptomes_patient:
		if symp in pathologie.symptomes_ecartants:
			return true
	return false

func compter_intersection(a : Array[Symptome_base], b : Array[Symptome_base]) -> int:
	var count := 0
	for symp in a:
		if symp in b:
			count += 1
	return count

## Retourne les N meilleures candidates (hors exclues), triées par score décroissant.
func get_top_candidats(n : int = NB_CANDIDATS_DEFAUT) -> Array[Dictionary]:
	var valides : Array[Dictionary] = []
	for r in resultats:
		if not r.raison.begins_with("exclu") and r.score > 0.0:
			valides.append(r)
	return valides.slice(0, n)

func get_score_pour(pathologie : Pathologie_base) -> float:
	for r in resultats:
		if r.pathologie == pathologie:
			return r.score
	return 0.0
