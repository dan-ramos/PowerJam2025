extends TextureButton

@export var scene_to_go_to : String

func _on_pressed():
	get_tree().change_scene_to_file(scene_to_go_to)
	

func _process(delta):
	if Input.is_action_just_pressed("pressPlay"):
		get_tree().change_scene_to_file(scene_to_go_to)
