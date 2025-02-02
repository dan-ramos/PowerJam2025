extends Node3D

var speed = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Path3D/PathFollow3D.progress += speed * delta
