extends PanelContainer

@export var label : Label
var color : Color

var texte : String:
	set(new_text):
		if new_text != texte:
			texte = new_text
			label.text = texte
