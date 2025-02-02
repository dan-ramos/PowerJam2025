extends Marker3D

signal strike
var hit = false

var balls = ['res://Scenes/Prefabs/Balls/slowBall.tscn',
			 'res://Scenes/Prefabs/Balls/mediumBall.tscn',
			 'res://Scenes/Prefabs/Balls/fastBall.tscn']
var instance
var nextBall
var nextBallName

func _ready():
	nextBallName = 'res://Scenes/Prefabs/Balls/slowBall.tscn'
	nextBall = load(nextBallName)

func pitch():
	instance = nextBall.instantiate()
	add_child(instance)
	instance.global_position = self.global_position
	print(instance)

func pickNextBall():
	nextBallName = balls.pick_random()
	nextBall = load(nextBallName)
	hit = false

func ballHit():
	hit = true

func reset():
	if instance != null:
		instance.queue_free()
	pickNextBall()

func _on_child_exiting_tree(node):
	if not hit:
		emit_signal("strike")
	reset()
