extends Node

var pathologies: Array[Pathologie_base] = []
var constantes : Array[Constante_base] = []
var actions : Array[ActionSoin_base] = []

func _ready():
	randomize()
	load_all_pathologies()
	load_all_constantes()
	load_all_actions()

func load_all_pathologies():
	var dir = DirAccess.open("res://BackEnd/Ressources/Pathologies/")
	
	if dir == null:
		push_error("Dossier pathologie introuvable")
		return
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if !dir.current_is_dir():
			if file_name.ends_with(".tres"):
				var res = load("res://BackEnd/Ressources/Pathologies/" + file_name)
				if res != null:
					pathologies.append(res)
		
		file_name = dir.get_next()
	
	dir.list_dir_end()

func get_random_pathology() -> Pathologie_base:
	if pathologies.is_empty():
		push_error("Aucune pathologie chargée")
		return null
	
	return pathologies[randi() % pathologies.size()]

func load_all_constantes():
	var dir = DirAccess.open("res://BackEnd/Ressources/Constantes/")
	if dir == null:
		push_error("Dossier constantes introuvable")
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir() and file_name.ends_with(".tres"):
			var res = load("res://BackEnd/Ressources/Constantes/" + file_name)
			if res != null:
				constantes.append(res)
		file_name = dir.get_next()
	dir.list_dir_end()

func get_constante_by_name(nom : String) -> Constante_base:
	for c in constantes:
		if c.nom == nom:
			return c
	return null


func load_all_actions() -> void:
	var dir = DirAccess.open("res://BackEnd/Ressources/ActionsSoin/")
	if dir == null:
		push_error("Dossier ActionsSoin introuvable")
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if !dir.current_is_dir() and file_name.ends_with(".tres"):
			var res = load("res://BackEnd/Ressources/ActionsSoin/" + file_name)
			if res != null:
				actions.append(res)
		file_name = dir.get_next()
	dir.list_dir_end()

## Ce que le joueur peut cliquer dans l'UI — exclut les actions auto-chaînées.
func get_actions_prescriptibles() -> Array[ActionSoin_base]:
	return actions.filter(func(a): return a.est_prescriptible)
