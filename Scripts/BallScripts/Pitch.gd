extends Node3D

@export var ballData : Resource

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Path3D/PathFollow3D.progress += ballData.speed * delta
	
	if $Path3D/PathFollow3D.progress_ratio == 1:
		queue_free()
