extends RefCounted
class_name PatientData


enum TYPE{HOMME, FEMME, ENFANT}
var type: TYPE = TYPE.HOMME
var diagnostic_context : DiagnosticContext
var age : int
enum SEX{MASCULIN, FEMININ}
var sex : SEX 


func _init(_age : int, _sex : SEX):
	age = _age
	sex = _sex
	if age < 18 :
		type = TYPE.ENFANT
	else :
		match sex:
			SEX.MASCULIN:
				type = TYPE.HOMME
			SEX.FEMININ:
				type = TYPE.FEMME

	diagnostic_context = DiagnosticContext.new()

func get_diagnostic_context() -> DiagnosticContext:
	return diagnostic_context

func get_pathologie() -> Pathologie_base:
	return diagnostic_context.pathologie

func get_pathologie_string() -> String:
	return get_pathologie().nom

func get_symptomes_array() -> Array[Symptome_base]:
	return get_diagnostic_context().symptomes_array

func get_symptomes_array_string() -> Array[String]:
	var array : Array = get_symptomes_array().duplicate()
	var array_string : Array = []
	for symp in array:
		array_string.append(symp.nom)
	return array_string

func get_age() -> int : 
	return age

func get_sex() -> SEX :
	return sex
