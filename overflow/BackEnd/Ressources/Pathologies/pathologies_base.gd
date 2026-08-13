extends Resource
class_name Pathologie_base

@export var nom : String
@export_range(0, 100) var gravite_intrinseque : int = 50
@export var symptomes_array : Array[Symptome_base]
@export var symptomes_ecartants : Array[Symptome_base]
@export var constantes_perturbees : Array[PathologieConstanteRange] = []
