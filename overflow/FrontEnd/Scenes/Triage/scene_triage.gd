extends Control

@export_category("PackedScene")
@export var scene_panel_patient : PackedScene
@export_category("Node")
@export var hbox_container : HBoxContainer
@export var progress_bar : ProgressBar
var time : int

var liste_patients : Array[PatientData]

func _ready() -> void:
	var __ = Signalbus.liste_patient_changed.connect(_on_liste_changed)
	creer_choix_patient()
	start_progress_bar()

func _on_liste_changed(new_liste) -> void:
	liste_patients = new_liste
	for child in hbox_container.get_children():
		child.queue_free()
	creer_choix_patient()

func creer_choix_patient() -> void:
	for _patient in liste_patients:
		var scene_node = scene_panel_patient.instantiate()
		scene_node.patient = _patient
		hbox_container.add_child(scene_node)

func start_progress_bar() -> void:
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", 0, time)
