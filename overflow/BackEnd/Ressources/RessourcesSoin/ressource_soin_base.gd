extends Resource
class_name Ressource_base

@export var nom : String       # "Médecin", "IDE", "Radio", "Scan", "Labo"
@export var quantite : int = 1 # nb d'unités disponibles en parallèle
enum TYPE{SOIGNANT, EXAMEN} 
@export var type : TYPE
@export var texture : Texture2D
