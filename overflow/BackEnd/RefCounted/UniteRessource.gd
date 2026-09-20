extends RefCounted
class_name UniteRessource

var ressource : Ressource_base
var identifiant : int  # ex: 1, 2... juste pour affichage / debug

func _init(_ressource : Ressource_base, _identifiant : int) -> void:
	ressource = _ressource
	identifiant = _identifiant

func get_ressource() -> Ressource_base:
	return ressource
