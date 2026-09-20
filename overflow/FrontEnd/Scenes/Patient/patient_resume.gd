extends Control

@export var symptomes_container : PanelContainer
@export var prescription_container : PanelContainer
@export var pathologies_differentiel : PanelContainer
signal patient_changed(patient : PatientData)

var patient : PatientData :
	set(value):
		if value != patient:
			patient = value
			prescription_container.patient = patient
			symptomes_container.patient = patient
			pathologies_differentiel.patient = patient
			patient_changed.emit(patient)


func _on_prescription_container_prescription_choiced() -> void:
	queue_free()
