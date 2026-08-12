extends RefCounted
class_name DiagnosticContext

var pathologie : Pathologie_base
var symptomes_array : Array[Symptome_base] 

func _init() -> void:
	obtenir_pathologie()
	obtenir_symptomes()

func obtenir_pathologie():
	pathologie = PathologieLoader.get_random_pathology()

func obtenir_symptomes() -> void:
	if symptomes_array == []:
		for sympto in pathologie.symptomes_array:
			symptomes_array.append(sympto)
