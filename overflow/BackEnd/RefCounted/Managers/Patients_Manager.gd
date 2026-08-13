extends RefCounted
class_name PatientsManager

signal choix_evalue(resultat : Dictionary)
signal patient_parti(patient : PatientData)

var patients_list : Array[PatientData] = []
var current_patient : PatientData = null :
	set(value):
		if current_patient != value:
			var resultat := TriageEvaluator.evaluer(value, patients_list)
			choix_evalue.emit(resultat)
			current_patient = value
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


## À appeler à chaque fin de cycle (timer écoulé), pour tous les patients
## encore en attente. Fait sortir ceux dont l'impatience dépasse le seuil.
func nouveau_tour() -> void:
	var partis : Array[PatientData] = []
	for p in patients_list:
		p.avancer_tour()
		if p.veut_partir():
			partis.append(p)

	for p in partis:
		patients_list.erase(p)
		patient_parti.emit(p)

	if partis.size() > 0:
		Signalbus.liste_patient_changed.emit(patients_list)
	creer_patient()
