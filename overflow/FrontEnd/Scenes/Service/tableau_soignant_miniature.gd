extends HBoxContainer

@export var texture_soignant : TextureRect
@export var label_soignant : Label
@export var disponibilite_texture : TextureRect


func setup(ressource : Ressource_base) -> void:
	texture_soignant.texture = ressource.texture
	label_soignant.text = ressource.nom
