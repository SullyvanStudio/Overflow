extends Control


@export_category("Texture")
@export var texture_homme : Texture
@export var texture_femme : Texture
@export var texture_enfant : Texture
@export_category("Zones")
@export var zone_homme : Control
@export var zone_femme : Control
@export var zone_enfant : Control
@export_category("Node")
@export var texturerect : TextureRect
@export_category("Scenes")
@export var indicateur_scene : PackedScene

signal position_indicateur(pos : Vector2, symp : Symptome_base)

var type : PatientData.TYPE = PatientData.TYPE.HOMME
var array_zone : Array[Node] = []
var zone_patient : Control = null


func update(patient : PatientData):
	setup_zone_par_type(patient.type)
	for symp in patient.get_symptomes_array():
		if symp.have_indicateur :
			add_indicateur(symp)

func setup_zone_par_type(_type):
	match _type:
		PatientData.TYPE.HOMME :
			texturerect.texture = texture_homme
			zone_homme.show()
			zone_patient= zone_homme
			array_zone = zone_homme.get_children()
		PatientData.TYPE.FEMME :
			texturerect.texture = texture_femme
			zone_femme.show()
			zone_patient= zone_femme
			array_zone = zone_femme.get_children()
		PatientData.TYPE.ENFANT :
			texturerect.texture = texture_enfant
			zone_enfant.show()
			zone_patient= zone_enfant
			array_zone = zone_enfant.get_children()

func add_indicateur(symp : Symptome_base) -> void:
		var indicateur_node =indicateur_scene.instantiate()
		var zone = zone_patient.find_child(symp.zone_atteinte)
		zone.add_child(indicateur_node)
		position_indicateur.emit(indicateur_node.global_position, symp)
