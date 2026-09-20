extends PanelContainer


@export var vbox : VBoxContainer
@export var box_label : Label
@export var hbox_liste_symptomes : HBoxContainer
@export var hbox_identity : HBoxContainer
@export var statut_label : Label

var actions_affichees : Dictionary = {}  # ActionInstance -> Control (source unique)
var component : InteractionComponent

var box_instance : BoxInstance = null:
	set(new_box):
		if box_instance != new_box:
			box_instance = new_box
			setup_box()

var patient : PatientData:
	set(new_patient):
		if new_patient!= patient:
			patient = new_patient
			_update_patient()

func _ready() -> void:
	var __ = Signalbus.action_mise_en_file.connect(_on_action_mise_en_file)

func setup_box() -> void:
	box_label.text = box_instance.nom
	var __ = box_instance.current_patient_changed.connect(_on_patient_changed)

func _on_patient_changed(value : PatientData) -> void:
	if patient :
		patient.patient_state_changed.disconnect(update_statut)
	patient = value
	patient.patient_state_changed.connect(update_statut)
	

func _update_patient() -> void:
	afficher_identity()
	afficher_symptomes()
	update_statut()

func afficher_identity() ->void:
	var age :int = patient.get_age()
	var age_label = Label.new()
	hbox_identity.add_child(age_label)
	age_label.text = str(age) + " ans"

func afficher_symptomes() -> void:
	for symp : Symptome_base in patient.get_symptomes_array():
		var text_instance = Factory.create_text(StaticConst.TEXT.PANEL)
		hbox_liste_symptomes.add_child(text_instance)
		text_instance.texte = symp.nom

func update_statut() -> void:
	statut_label.text =  patient.get_state_string()

func _on_action_mise_en_file(action : ActionInstance) -> void:
	if actions_affichees.has(action):
		return
	elif action.patient == patient:
		var text_instance = Factory.create_text(StaticConst.TEXT.PANEL)
		vbox.add_child(text_instance)
		text_instance.texte = action.get_action_nom()
		actions_affichees.get_or_add(action,text_instance)
		action.terminee.connect(_on_action_terminee)

func _on_action_terminee(action : ActionInstance):
	if not actions_affichees.has(action):
		return
	actions_affichees[action].queue_free()
	actions_affichees.erase(action)
	

func _on_interaction_component_hover_started() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.2)


func _on_interaction_component_hover_ended() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2)


func _on_interaction_component_pressed() -> void:
	Signalbus.patient_picked.emit(patient)
