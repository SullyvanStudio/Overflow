extends RefCounted
class_name FileAttenteRessource

var ressource : Ressource_base
var file : Array[ActionInstance] = []
var en_cours : Array[ActionInstance] = []
var unites : Array[UniteRessource] = []
var unites_libres : Array[UniteRessource] = []

func _init(_ressource : Ressource_base) -> void:
	ressource = _ressource
	for i in _ressource.quantite:
		var u := UniteRessource.new(_ressource, i + 1)
		unites.append(u)
		unites_libres.append(u)

func ajouter_action(instance : ActionInstance) -> void:
	file.append(instance)
	Signalbus.action_mise_en_file.emit(instance)  # une seule instance, pas tout le tableau

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
	return unites_libres.size()

func avancer_tour(tour_actuel : int) -> void:
	var toujours_en_cours : Array[ActionInstance] = []
	for instance in en_cours:
		instance.avancer_tour(tour_actuel)
		if instance.etat != ActionInstance.ETAT.TERMINEE:
			toujours_en_cours.append(instance)
		else:
			unites_libres.append(instance.unite_assignee)  # libère l'unité
	en_cours = toujours_en_cours

	while places_disponibles() > 0 and not file.is_empty():
		var instance : ActionInstance = file.pop_front()
		var unite : UniteRessource = unites_libres.pop_front()
		instance.demarrer(tour_actuel, unite)
		en_cours.append(instance)
