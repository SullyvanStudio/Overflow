extends PanelContainer
class_name Unites_Container

@export_category("Nodes")
@export var soignant_container : VBoxContainer
@export var examen_container : VBoxContainer
@export_category("Scene")
@export var unite_vbox_scene : PackedScene

var gestionnaire : GestionnaireFilesAttente

func _ready() -> void:
	Signalbus.gestionnaire_soins_pret.connect(_on_gestionnaire_pret)

func _on_gestionnaire_pret(_g : GestionnaireFilesAttente):
	gestionnaire = _g
	update_unites()

func update_unites() -> void:
	var file_par_type_dict = gestionnaire.get_files()

	for ressource in file_par_type_dict:
		var unite_node = unite_vbox_scene.instantiate()
		match ressource.type :
			Ressource_base.TYPE.SOIGNANT:
				soignant_container.add_child(unite_node)
			Ressource_base.TYPE.EXAMEN:
				examen_container.add_child(unite_node)
		unite_node.setup(ressource)
	
		var file :FileAttenteRessource = file_par_type_dict[ressource]
		for unite in file.unites:
			unite_node.on_add_soignant(unite)
