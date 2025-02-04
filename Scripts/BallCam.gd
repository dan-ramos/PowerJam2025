extends Camera3D

var pos = Vector3(00, 1.77, 4.58)
var rot = Vector3(-18, 0, 0)
var timer = 0
var liveTime = 4

func _process(delta):
	#makes the ball's camera the cu
	#make_current()
	#locks camera's position to be offset the ball while its around
	position = pos + $"..".position
	rot = rotation

