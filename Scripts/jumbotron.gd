extends MeshInstance3D

var boardTimer = 0
var boardTime = 10
var index = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	boardTimer += delta
	if boardTimer > boardTime:
		index += 1
		mesh.material.albedo_texture = load('res://Images/Jumbotron/' + str(index) + '.png')
		print('res://Images/Jumbotron/' + str(index) + '.png')
		boardTimer = 0
		if index >= 9:
			index = 0
	
