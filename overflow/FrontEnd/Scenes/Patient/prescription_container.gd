extends PanelContainer

var patient : PatientData:
	set(new_patient):
		if new_patient!= patient:
			patient = new_patient
			generer_boutons_prescription(patient)

@export var container : GridContainer
var array_prescription: Array[PrescriptionsInstance]


func generer_boutons_prescription(_patient : PatientData) -> void:
	for action in PathologieLoader.get_actions_prescriptibles():
		var bouton : Button = CheckButton.new()
		bouton.text = action.nom
		bouton.toggled.connect(_on_button_toggled.bind(action, _patient))
		container.add_child(bouton)

func _on_button_toggled(value : bool, _action, _patient):
	if value :
		_add_prescription(_action, _patient)
	else :
		_delete_prescription(_action)

func _add_prescription(_action, _patient):
	var prescription = PrescriptionsInstance.new(_action, _patient)
	array_prescription.append(prescription)


func _delete_prescription(_action):
	for pres in array_prescription:
		if pres.action == _action :
			array_prescription.erase(pres)




func _on_valider_button_pressed() -> void:
	Signalbus.prescriptions_picked.emit(array_prescription)
	print(array_prescription)
