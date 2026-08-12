extends RefCounted
class_name PatientsManager

var patients_list : Array[PatientData] = []
var current_patient : PatientData = null :
	set(value):
		if current_patient!= value:
			current_patient= value
			delete_patient_to_list(current_patient)

func _init():
	creer_patient()
	creer_patient()


func creer_patient()-> void:
	var age : int = randi_range(8, 99)
	var sex : int = randi_range(0, 1)
	var _new_patient = PatientData.new(age, sex)
	add_patient_to_list(_new_patient)

func add_patient_to_list(_patient) -> void:
	patients_list.append(_patient)
	Signalbus.liste_patient_changed.emit(patients_list)

func delete_patient_to_list(_patient) -> void:
	patients_list.erase(_patient)
	Signalbus.liste_patient_changed.emit(patients_list)
