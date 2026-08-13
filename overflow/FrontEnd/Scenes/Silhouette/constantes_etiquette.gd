extends Control

@export var texture : TextureRect
@export var label : Label

var constante:
	set(value):
		if value != constante:
			constante = value
			update_view.call_deferred()

func update_view()->void:
	texture.texture = constante.texture
	label.text = constante.get_constante_string()
