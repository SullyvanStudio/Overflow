extends RefCounted
class_name TriageEvaluator

## Compare le patient choisi par le joueur au reste du pool (avant suppression)
## et renvoie un Dictionary avec : score_choisi, score_max, performance (0-100), qualification
static func evaluer(patient_choisi : PatientData, pool : Array[PatientData]) -> Dictionary:
	var score_max : int = 0
	for p in pool:
		score_max = max(score_max, p.get_score_gravite())

	var score_choisi : int = patient_choisi.get_score_gravite()
	var performance : float = clampf(100.0 - float(score_max - score_choisi), 0.0, 100.0)

	return {
		"score_choisi": score_choisi,
		"score_max": score_max,
		"performance": performance,
		"qualification": qualifier(performance),
	}

static func qualifier(performance : float) -> String:
	if performance >= 90.0:
		return "Excellent"
	elif performance >= 70.0:
		return "Correct"
	elif performance >= 50.0:
		return "Attention"
	else:
		return "Faute grave"
