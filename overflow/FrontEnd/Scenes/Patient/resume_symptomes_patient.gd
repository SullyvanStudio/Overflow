extends PanelContainer

@export_category("Node")
@export var label : Label
@export var silhouette : Control
@export var sex_texture : TextureRect
@export var position_symptome_control : Control
@export var constantes_container : Control
@export_category("Ressource")
@export var logo_homme : Texture
@export var logo_femme : Texture
@export_category("Scene")



var patient : PatientData = null:
	set(value):
		if value != patient:
			patient = value
			update_patient()

# Mémorise la référence du node indicateur (sur la silhouette) pour chaque symptôme
var indicateur_nodes : Dictionary = {}


func update_patient() -> void:
	if patient :
		var age_string : String = str(patient.get_age())
		var text : String = ""
		silhouette.update(patient)
		match patient.get_sex():
			PatientData.SEX.MASCULIN :
				text = "Homme de "+age_string+" ans"
				sex_texture.texture = logo_homme
			PatientData.SEX.FEMININ :
				text = "Femme de "+age_string+" ans"
				sex_texture.texture = logo_femme
		if patient.type == PatientData.TYPE.ENFANT :
			text = "Enfant de "+age_string+" ans"
		label.text = text
		setup_symptome_etiquette()
		setup_constantes_panel()

#region Symptomes
func setup_symptome_etiquette() -> void: 
	var array_symptomes = patient.get_symptomes_array()
	for sympto in array_symptomes :
		var panel_text = Factory.create_text(StaticConst.TEXT.PANEL)
		position_symptome_control.add_child(panel_text)
		panel_text.texte = sympto.nom

#endregion

#region Constantes
func setup_constantes_panel() -> void:
	constantes_container.patient_constantes = patient.get_constantes_context()
#endregion


func _on_silhouette_position_indicateur(indicateur_node: Control, symp: Symptome_base) -> void:
	indicateur_nodes[symp] = indicateur_node
