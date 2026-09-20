extends RefCounted
class_name PatientsManager

signal choix_evalue(resultat : Dictionary)
signal patient_parti(patient : PatientData)

var patients_triage_list : Array[PatientData] = []
var boxs_array : Array[BoxInstance] = []

var current_patient : PatientData = null :
	set(value):
		if current_patient != value:
			var resultat := TriageEvaluator.evaluer(value, patients_triage_list)
			choix_evalue.emit(resultat)
			current_patient = value
			triage_to_box(current_patient)

func _init():
	creer_patient()
	creer_patient()
	creer_box(5)

func creer_box(nombre : int) -> void:
	for i in nombre:
		var string :String = "Box "+str(i+1) 
		var box = BoxInstance.new(string)
		boxs_array.append(box)


func creer_patient()-> void:
	var age : int = randi_range(8, 99)
	var sex : int = randi_range(0, 1)
	var _new_patient = PatientData.new(age, sex)
	add_patient_to_triage(_new_patient)

func add_patient_to_triage(_patient) -> void:
	patients_triage_list.append(_patient)
	_patient.patient_state = PatientData.STATE.TRIAGE
	Signalbus.liste_patient_changed.emit(patients_triage_list)


func triage_to_box(_patient) -> void:
	patients_triage_list.erase(_patient)
	for box in boxs_array:
		if box.current_patient == null :
			box.add_patient(_patient)
			Signalbus.liste_patient_changed.emit(patients_triage_list)
			break
	
	
	
func delete_patient_to_triage(_patient) -> void:
	patients_triage_list.erase(_patient)
	Signalbus.liste_patient_changed.emit(patients_triage_list)




## À appeler à chaque fin de cycle (timer écoulé), pour tous les patients
## encore en attente. Fait sortir ceux dont l'impatience dépasse le seuil.
func nouveau_tour() -> void:
	var partis : Array[PatientData] = []
	for p in patients_triage_list:
		p.avancer_tour()
		if p.veut_partir():
			partis.append(p)

	for p in partis:
		patients_triage_list.erase(p)
		patient_parti.emit(p)

	if partis.size() > 0:
		Signalbus.liste_patient_changed.emit(patients_triage_list)
