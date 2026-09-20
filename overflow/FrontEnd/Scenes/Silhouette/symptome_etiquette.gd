extends Control

@export var texture_rect : TextureRect
@export var label : Label

var symptome_data : Symptome_base:
	set(value):
		if symptome_data != value:
			symptome_data = value
			update(symptome_data)

func update(symptome : Symptome_base) -> void:
	label.text = symptome.nom
	texture_rect.texture = symptome.texture
	adapt_text_size.call_deferred()

func adapt_text_size() -> void:
	var current_size = 12
	label.add_theme_font_size_override("font_size", current_size)
	# Réduit la taille tant que le texte dépasse du conteneur
	while label.size.x > texture_rect.size.x+4 and current_size > 7:
		current_size -= 1
		label.add_theme_font_size_override("font_size", current_size)
