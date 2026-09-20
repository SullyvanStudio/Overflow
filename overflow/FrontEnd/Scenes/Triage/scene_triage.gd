extends Control

@export_category("PackedScene")
@export var scene_panel_patient : PackedScene
@export_category("Node")
@export var hbox_container : HBoxContainer
@export var progress_bar : ProgressBar
var progress_tween: Tween
var time : int

var liste_patients : Array[PatientData]

signal temps_ecoule

func _ready() -> void:
	var __ = Signalbus.liste_patient_changed.connect(_on_liste_changed)
	__ = Signalbus.patient_picked.connect(_on_patient_picked)
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
		hbox_container.add_child(scene_node)
		scene_node.patient = _patient

func start_progress_bar() -> void:
	if progress_tween and progress_tween.is_running():
		progress_tween.kill()
	
	progress_tween = create_tween()
	progress_bar.value = progress_bar.max_value
	progress_tween.tween_property(progress_bar, "value", 0, time)
	progress_tween.finished.connect(func(): temps_ecoule.emit())

func stop_progress_bar() -> void:
	if progress_tween:
		progress_tween.kill()

func _on_patient_picked(_p) -> void:
	stop_progress_bar()
	start_progress_bar()
