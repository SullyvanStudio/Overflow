extends PanelContainer

@export var hbox : HBoxContainer

var patient : PatientData = null:
	set(value):
		if value != patient:
			patient = value
			update_patient()

func update_patient() -> void:
	for dict in patient.get_differential_pathologies():
		var panel_label = Factory.create_text(StaticConst.TEXT.PANEL)
		hbox.add_child(panel_label)
		panel_label.texte = dict["pathologie"].nom
