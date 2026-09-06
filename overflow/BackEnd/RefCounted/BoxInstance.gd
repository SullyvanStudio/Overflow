class_name BoxInstance extends RefCounted

var nom : String
signal current_patient_changed(current_patient)

var current_patient : PatientData = null:
	set(new):
		if new != current_patient:
			current_patient = new
			current_patient_changed.emit(current_patient)
			current_patient.current_box = self
			if new != null:
				print("Box : %s " %nom)

func _init(_nom) -> void:
	nom = _nom
	Signalbus.new_box_instance.emit(self)

func add_patient(patient : PatientData) -> void:
	if current_patient == null :
		current_patient = patient
	else : printerr("box %s est indisponible" %nom)

func delete_patient(_patient : PatientData):
	if current_patient != null :
		current_patient = null
	else : printerr("box %s était vide" %nom)
