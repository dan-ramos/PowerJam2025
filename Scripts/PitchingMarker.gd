extends Marker3D

signal strike
var hit = false
var rng

var balls = [
				'res://Scenes/Prefabs/Balls/slowBall.tscn',
				'res://Scenes/Prefabs/Balls/mediumBall.tscn',
				'res://Scenes/Prefabs/Balls/fastBall.tscn',
				'res://Scenes/Prefabs/Balls/squareBall.tscn',
				'res://Scenes/Prefabs/Balls/lobBall.tscn'
			]
var instance
var nextBall
var nextBallName

func _ready():
	nextBallName = 'res://Scenes/Prefabs/Balls/lobBall.tscn'
	nextBall = load(nextBallName)
	rng = RandomNumberGenerator.new()

func pitch():
	instance = nextBall.instantiate()
	add_child(instance)
	instance.rotation = Vector3(0, rng.randf_range(-0.03, 0.03), 0)
	#print(instance.rotation)
	instance.global_position = self.global_position
	#print(instance)

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
