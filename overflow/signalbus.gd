extends Node

@warning_ignore_start("unused_signal")
# envoyé par le backend
signal liste_patient_changed(list :Array[PatientData])

## envoyé par le front
signal patient_picked(patient :PatientData)
signal prescriptions_picked(array_pres : Array[PrescriptionsInstance])
