extends PanelContainer

@export_category("Node")
@export var label : Label
@export var silhouette : Control
@export var sex_texture : TextureRect
@export var position_symptome_control : Control
@export_category("Ressource")
@export var logo_homme : Texture
@export var logo_femme : Texture
@export_category("Scene")
@export var symptome_etiquette_scene : PackedScene

var component : InteractionComponent : 
	set(value): 
		component = value
		var __ = component.connect("pressed", _on_pressed)
		__ = component.connect("hover_started", _on_hover_started)
		__ = component.connect("hover_ended", _on_hover_ended)
var patient : PatientData = null:
	set(value):
		if value != patient:
			patient = value
			update_patient()

# Mémorise la référence du node indicateur (sur la silhouette) pour chaque symptôme
var indicateur_nodes : Dictionary = {}
var lignes_indicateur : Array[Line2D] = []


func update_patient() -> void:
	if patient :
		indicateur_nodes.clear()
		clear_lignes()
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

func clear_lignes() -> void:
	for line in lignes_indicateur:
		if is_instance_valid(line):
			line.queue_free()
	lignes_indicateur.clear()

func setup_symptome_etiquette() -> void: 
	var array_symptomes = patient.get_symptomes_array()
	for sympto in array_symptomes :
		var etiquette_node = symptome_etiquette_scene.instantiate()
		position_symptome_control.add_child(etiquette_node)
		etiquette_node.symptome_data = sympto
		positionner_symptome_etiquette(etiquette_node, array_symptomes.find(sympto))

func positionner_symptome_etiquette(etiquette : Control, index : int) -> void:
	match index:
		0 : etiquette.set_anchors_preset(Control.PRESET_TOP_LEFT)
		1 : etiquette.set_anchors_preset(Control.PRESET_TOP_RIGHT)
		2 : etiquette.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
		_ : etiquette.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)

	if etiquette.symptome_data.have_indicateur :
		draw_ligne_when_ready(etiquette)

func draw_ligne_when_ready(etiquette : Control) -> void:
	if not is_inside_tree():
		await ready
	await get_tree().process_frame
	await get_tree().process_frame
	draw_ligne(etiquette)

func draw_ligne(etiquette : Control) -> void:
	if not is_instance_valid(etiquette):
		return
	var symp : Symptome_base = etiquette.symptome_data
	if not indicateur_nodes.has(symp):
		push_warning("Pas d'indicateur trouvé pour %s" % symp.nom)
		return
	var indicateur_node : Control = indicateur_nodes[symp]
	if not is_instance_valid(indicateur_node):
		return

	var inverse_transform : Transform2D = get_global_transform().affine_inverse()
	var from : Vector2 = inverse_transform * (etiquette.global_position + etiquette.size / 2.0)
	var to : Vector2 = inverse_transform * (indicateur_node.global_position + indicateur_node.size / 2.0)

	var line := Line2D.new()
	line.add_point(from)
	line.add_point(to)
	line.default_color = Color.DARK_RED
	line.width = 2.0
	self.add_child(line)
	lignes_indicateur.append(line)

func _on_pressed():
	if patient == null :
		push_error("pas de patient_data connu sur l'UI")
	else: 
		Signalbus.patient_picked.emit(patient)

func _on_hover_started():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)

func _on_hover_ended():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)

func _on_silhouette_position_indicateur(indicateur_node: Control, symp: Symptome_base) -> void:
	indicateur_nodes[symp] = indicateur_node
