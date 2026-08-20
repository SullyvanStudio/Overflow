extends RefCounted
class_name FileAttenteRessource

var ressource : Ressource_base
var file : Array[ActionInstance] = []
var en_cours : Array[ActionInstance] = []

func _init(_ressource : Ressource_base) -> void:
	ressource = _ressource

func ajouter_action(instance : ActionInstance) -> void:
	file.append(instance)

## Réordonne une action en attente. Le drag-and-drop ne pourra JAMAIS
## toucher une action déjà démarrée ou terminée.
func deplacer(instance : ActionInstance, nouvel_index : int) -> void:
	if instance.etat != ActionInstance.ETAT.EN_ATTENTE:
		push_warning("Impossible de réordonner une action déjà démarrée ou terminée.")
		return
	if not file.has(instance):
		return
	file.erase(instance)
	file.insert(clampi(nouvel_index, 0, file.size()), instance)

func places_disponibles() -> int:
	return ressource.quantite - en_cours.size()

func avancer_tour(tour_actuel : int) -> void:
	var toujours_en_cours : Array[ActionInstance] = []
	for instance in en_cours:
		instance.avancer_tour(tour_actuel)
		if instance.etat != ActionInstance.ETAT.TERMINEE:
			toujours_en_cours.append(instance)
	en_cours = toujours_en_cours

	while places_disponibles() > 0 and not file.is_empty():
		var instance : ActionInstance = file.pop_front()
		instance.demarrer(tour_actuel)
		en_cours.append(instance)
