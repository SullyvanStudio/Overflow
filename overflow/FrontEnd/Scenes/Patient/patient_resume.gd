extends Control

@export var prescription_container : PanelContainer


var patient : PatientData :
	set(value):
		if value != patient:
			patient = value
			prescription_container.patient = patient
