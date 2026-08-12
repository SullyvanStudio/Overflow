extends Node

var pathologies: Array = []

func _ready():
	randomize()
	load_all_pathologies()

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
