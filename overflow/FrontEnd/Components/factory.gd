class_name Factory extends Object

static func create_text(text_id : StaticConst.TEXT) -> Control:
	var scene_path : String = StaticConst.TEXT_SCENES[text_id]
	var scene : PackedScene = load(scene_path)
	var instance : Control = scene.instantiate()
	return instance

static func create_box(box_id : StaticConst.BOX_SCENES) -> Control:
	var scene_path : String = StaticConst.BOX_SCENE[box_id] 
	var scene : PackedScene = load(scene_path)
	var instance : Control = scene.instantiate()
	return instance
