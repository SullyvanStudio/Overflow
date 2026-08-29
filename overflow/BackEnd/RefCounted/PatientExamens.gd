extends RefCounted
class_name PatientExamens

## Résultats d'examens diagnostiques pré-calculés pour un patient, générés une fois à la
## création (comme PatientConstantes). Cette classe ne gère PAS la visibilité : elle stocke
## le résultat médical "vrai" de chaque examen. C'est au système de prescription
## (GestionnaireFilesAttente / ActionInstance) de ne révéler que les résultats des examens
## effectivement prescrits et dont le délai (delai_resultat_tours) est écoulé.
##
## Un résultat n'est PAS un booléen normal/anormal : c'est soit null (rien de spécifique
## trouvé), soit la Pathologie_base précise que l'examen a révélée. Ça permet à un même
## examen (angioscanner) de distinguer plusieurs candidats qui présentent les mêmes
## symptômes mais ont des signatures d'examen différentes (embolie pulmonaire vs
## dissection aortique, par exemple).
##
## /!\ Dépend d'un champ `est_examen_diagnostique : bool` sur ActionSoin_base, qui n'existe
## pas encore -- sans lui, on générerait des "résultats" pour des soins thérapeutiques
## (antalgique, oxygénothérapie) qui n'ont aucun sens clinique.

var resultats : Dictionary = {}  # ActionSoin_base -> Pathologie_base | null

func generer(pathologie_reelle : Pathologie_base, toutes_les_actions : Array[ActionSoin_base]) -> void:
	resultats.clear()
	for action in toutes_les_actions:
		if not action.est_examen_diagnostique:
			continue
		if action in pathologie_reelle.examens_discriminants:
			resultats[action] = pathologie_reelle
		else:
			resultats[action] = null

func get_resultat(action : ActionSoin_base) -> Variant:
	return resultats.get(action, null)
