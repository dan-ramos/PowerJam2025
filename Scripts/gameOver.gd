extends Node2D

var GOtime = 5
var GOtimer = 0

func _process(delta):
	GOtimer += get_process_delta_time()
	if GOtimer > GOtime:
		get_tree().change_scene_to_file('res://Scenes/TitleScene.tscn')
