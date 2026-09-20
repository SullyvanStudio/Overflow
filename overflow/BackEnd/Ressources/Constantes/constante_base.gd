extends Resource
class_name Constante_base

@export var nom : String        # "Température"
@export var unite : String      # "°C"
@export var valeur_normale_min : float
@export var valeur_normale_max : float
@export var paliers : Array[PalierConstante] = []
@export var texture : Texture
@export var decimales : int = 0      # nb de décimales pour l'arrondi et l'affichage
@export var ordre_affichage : int = 0 # position dans le GridContainer

## Retourne le palier correspondant à une valeur donnée, ou null si hors plage.
func get_palier(valeur : float) -> PalierConstante:
	for palier in paliers:
		if valeur >= palier.valeur_min and valeur <= palier.valeur_max:
			return palier
	return null
