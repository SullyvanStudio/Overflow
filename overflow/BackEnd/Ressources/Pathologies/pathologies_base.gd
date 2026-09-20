extends Resource
class_name Pathologie_base
 
@export var nom : String
@export_range(0, 100) var gravite_intrinseque : int = 50
@export var symptomes_array : Array[Symptome_base]
@export var symptomes_ecartants : Array[Symptome_base]
@export var constantes_perturbees : Array[PathologieConstanteRange] = []
 
## Examens qui, s'ils sont prescrits, permettent de confirmer OU d'exclure cette
## pathologie précise -- selon ce que l'examen montre réellement chez le patient,
## pas selon un simple flag "anormal". Un même examen (ex: angioscanner) peut
## confirmer une pathologie et en exclure une autre en même temps.
@export var examens_discriminants : Array[ActionSoin_base] = []
 
