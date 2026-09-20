extends PanelContainer


@export var nombre_patient_label : Label
@export var dossier_medical_texture : Texture
@export var zone_dossiers : MarginContainer

var nombre_patients : int:
	set(value):
		if value!= nombre_patients:
			nombre_patients = value
			update_label()
			check_dossier()

func _ready() -> void:
	var __ = Signalbus.liste_patient_changed.connect(_on_list_changed)

func update_label() -> void:
	if nombre_patients > 1:
		nombre_patient_label.text = "actuellement %s patients" %str(nombre_patients)
	elif nombre_patients == 1:
		nombre_patient_label.text = "actuellement %s patient" %str(nombre_patients)
	elif nombre_patients == 0 :
		nombre_patient_label.text = "aucun patient"
	else : push_error("patient en nombre négatif dans le triage")

func _on_list_changed(array : Array) -> void:
	nombre_patients = array.size()

func check_dossier()-> void:
	var children = zone_dossiers.get_children()
	var nb = children.size()
	while nb < nombre_patients :
		add_dossier()
		nb +=1
	if nb > nombre_patients:
		delete_dossier()

func add_dossier() -> void:
	var dossier_node = TextureRect.new()
	zone_dossiers.add_child(dossier_node)
	dossier_node.texture = dossier_medical_texture
	dossier_node.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
	dossier_node.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_repositionner_pile()

const OFFSET_PX = Vector2(5, 5)

func _repositionner_pile() -> void:
	var children = zone_dossiers.get_children()
	for i in children.size():
		var dossier = children[i]
		dossier.offset_transform_enabled = true
		dossier.offset_transform_position += OFFSET_PX * i
		dossier.offset_transform_rotation += randf_range(-0.2, 0.2)

func delete_dossier() -> void:
	zone_dossiers.get_child(0).queue_free()
