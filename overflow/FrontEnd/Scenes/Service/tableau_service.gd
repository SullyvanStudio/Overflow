extends Control
class_name TableauService

@export var soignant_container : PanelContainer

signal array_soignants_changed(array)
var array_soignants : Array[Ressource_base] = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	array_soignants_changed.connect(soignant_container._on_array_soignants_changed)
	array_soignants = LoaderNeeded.get_ressources_soignant()
	setup_soignants()

func setup_soignants():
	if array_soignants == []:
		push_error("pas de soignants dans l'array")
	else :
		array_soignants_changed.emit(array_soignants)
