class_name Factory extends Object

static func create_text(text_id : StaticConst.TEXT) -> Control:
	var scene_path : String = StaticConst.TEXT_SCENES[text_id]
	var scene : PackedScene = load(scene_path)
	var instance : Control = scene.instantiate()
	return instance
	
