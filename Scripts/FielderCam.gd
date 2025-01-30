extends Camera3D

var pos = Vector3(-1.7, 2.77, 5.2)
var rot = Vector3(-20, -20, -7.4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = pos + $"..".position
	rot = rotation
