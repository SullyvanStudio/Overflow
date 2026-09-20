extends RefCounted
class_name Event_Instance

var ressource : Event_Resource = null
var tour : int = 0

func _init(_ressource : Event_Resource, _tour : int) -> void:
	ressource = _ressource
