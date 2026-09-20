extends RefCounted
class_name PrescriptionsInstance

var action : ActionSoin_base
var patient : PatientData

func _init(_action : ActionSoin_base, _patient : PatientData) -> void:
	action = _action
	patient = _patient
