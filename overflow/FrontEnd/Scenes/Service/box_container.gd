extends PanelContainer


@export var vbox : VBoxContainer

var patient : PatientData:
	set(new_patient):
		if new_patient!= patient:
			patient = new_patient
			_update()

func _ready() -> void:
	var __ = Signalbus.patient_picked.connect(_on_patient_picked)

func _on_patient_picked(value : PatientData) -> void:
	patient = value

func _update() -> void:
	var __ = Signalbus.prescriptions_picked.connect(_on_prescription_picked)

func _on_prescription_picked(array) -> void:
	for prescription in array :
		if prescription.patient == patient:
			var text_instance = Factory.create_text(StaticConst.TEXT.PANEL)
			vbox.add_child(text_instance)
			text_instance.texte = prescription.action.nom
			
