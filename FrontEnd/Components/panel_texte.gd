extends PanelContainer

@export var label : Label
var color : Color


var texte : String:
	set(new_text):
		if new_text != texte:
			texte = new_text
			label.text = texte

var ressource : ResourceCommune:
	set(new_res):
		if new_res != ressource:
			ressource = new_res
			update()

func update():
	label.text = ressource.nom
	
