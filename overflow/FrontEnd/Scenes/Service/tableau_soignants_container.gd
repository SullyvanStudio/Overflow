extends PanelContainer

@export var vbox : VBoxContainer
@export var scene_tableau_soignant_miniature : PackedScene

var soignants_ressource_array : Array[Ressource_base] = []
var soignants_node_array : Array = []


func _on_array_soignants_changed(array) -> void:
	soignants_ressource_array = array
	update()

func update() -> void:
	for ressource in soignants_ressource_array :
		var n = ressource.quantite 
		while n > 0:
			var node = scene_tableau_soignant_miniature.instantiate()
			vbox.add_child(node)
			node.setup(ressource)
			n -= 1
		
