extends Resource
class_name PalierConstante

@export var nom : String  # "Hyperthermie modérée"
@export var valeur_min : float
@export var valeur_max : float
@export_enum("normal", "leger", "modere", "severe", "critique") var gravite : String = "normal"
