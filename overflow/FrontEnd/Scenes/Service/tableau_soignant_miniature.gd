extends HBoxContainer
class_name MiniatureUnite

@export var texture_soignant : TextureRect
@export var label_soignant : Label
@export var disponibilite_texture : TextureRect
@export var action_en_cours_container : Control

var actions_affichees : Dictionary = {}  # ActionInstance -> Control (source unique)
var current_unite : UniteRessource = null

var busy : bool = false : 
	set(value):
		busy = value
		if busy :
			disponibilite_texture.self_modulate = Color.RED
		else : disponibilite_texture.self_modulate = Color.WHITE

func _ready() -> void:
	Signalbus.nouvelle_action_demarree.connect(_on_action_demarree)

func _on_action_demarree(action_instance : ActionInstance, unite : UniteRessource) -> void:
	if unite != current_unite :
		return
	if action_instance .get_ressource_necessaire() != current_unite.get_ressource():
		return
	busy = true
	var text_instance = Factory.create_text(StaticConst.TEXT.PANEL)
	action_en_cours_container.add_child(text_instance)
	text_instance.texte = action_instance .patient.current_box.nom + ": " + action_instance .get_action_nom()
	actions_affichees[action_instance ] = text_instance
	action_instance.terminee.connect(_on_action_terminee)

func setup(unite: UniteRessource) -> void:
	current_unite = unite
	busy = false
	texture_soignant.texture = current_unite.get_ressource().texture
	label_soignant.text = current_unite.get_ressource().nom + str(current_unite.identifiant)


func _on_action_terminee(action : ActionInstance) -> void:
	if not actions_affichees.has(action):
		return
	busy=false
	actions_affichees[action].queue_free()
	actions_affichees.erase(action)
