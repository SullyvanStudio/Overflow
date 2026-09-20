class_name EventManager extends RefCounted

signal pop_event(event : Event_Instance)

var event_array : Array[Event_Instance] = []

func _init() -> void:
	Signalbus.nouveau_tour.connect(nouveau_tour)

func new_event(event : Event_Instance) -> void:
	event_array.append(event)

func nouveau_tour() -> void:
	var _tour = Signalbus.tour
	for ev in event_array :
		if ev.tour == _tour:
			pop_event.emit(ev)
			event_array.erase(ev)
	
