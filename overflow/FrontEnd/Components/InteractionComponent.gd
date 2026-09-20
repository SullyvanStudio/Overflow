extends Control
class_name InteractionComponent

@export var porteur : Control
@export var hover_mode : bool = true
@export var toggle_mode : bool = false
@export var pressed_mode : bool = true

signal pressed
signal hover_started
signal hover_ended
signal toggled(active : bool)

var is_hovered : bool = false
var is_active : bool = false : set = set_active

func _ready() -> void:
	if !porteur:
		printerr("InteractionComponent n'a pas de porteur !")
		return
	porteur.component = self
	size = porteur.size
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if hover_mode :
		is_hovered = true
		hover_started.emit()

func _on_mouse_exited() -> void:
	if hover_mode :
		is_hovered = false
		hover_ended.emit()

func _gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
				_on_clicked()

func _on_clicked() -> void:
	pressed.emit()
	if toggle_mode:
		set_active(!is_active)

func set_active(value : bool) -> void:
	if is_active != value:
		is_active = value
		toggled.emit(is_active)
