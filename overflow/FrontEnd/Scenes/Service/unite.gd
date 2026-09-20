extends HBoxContainer

@export var soignants_vbox : VBoxContainer
@export var file_hbox : HBoxContainer
@export var miniature_scene : PackedScene

var current_ressource : Ressource_base
var actions_affichees : Dictionary = {}  # ActionInstance -> Control (source unique)

func _ready() -> void:
	Signalbus.action_mise_en_file.connect(_on_action_mise_en_file)

func setup(ressource : Ressource_base) -> void:
	current_ressource = ressource

func _on_action_mise_en_file(instance : ActionInstance) -> void:
	if instance.get_ressource_necessaire() != current_ressource:
		return
	var text_instance = Factory.create_text(StaticConst.TEXT.PANEL)
	file_hbox.add_child(text_instance)
	text_instance.texte = instance.patient.current_box.nom + ": " + instance.get_action_nom()
	actions_affichees[instance] = text_instance
	instance.en_cours.connect(_on_action_en_cours)

func on_add_soignant(unite : UniteRessource)-> void:
	if unite.get_ressource() != current_ressource:
		printerr("pas la bonne ressource")
		return
	var node :MiniatureUnite = miniature_scene.instantiate()
	soignants_vbox.add_child(node)
	node.setup(unite)

func _on_action_en_cours(action : ActionInstance) -> void:
	if not actions_affichees.has(action):
		return
	actions_affichees[action].queue_free()
	actions_affichees.erase(action)
