extends Control
class_name TableauService

@export var hbox_boxs : HBoxContainer

func _ready() -> void:
	Signalbus.new_box_instance.connect(_setup_box)

func _setup_box(new_box) -> void:
	var box = Factory.create_box(StaticConst.BOX_SCENES.BOX_CONTAINER)
	hbox_boxs.add_child(box)
	box.box_instance = new_box
