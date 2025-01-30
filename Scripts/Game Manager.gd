extends Node3D

var cutsceneBallLiveTime = 4
var timer = 0
var balltime = false

var player
var rng
var fielder
var ballSpawn
var newball
#var velocity = 10
var left1
var left2
var right1
var right2
var homer1 # mmm donut 
var homer2
var cutsceneBall = preload("res://Scenes/Prefabs/cutsceneBall.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#variable name setup pulled from root tree
	player = $Player
	ballSpawn = $"Stadium Stuff/BallSpawnPoint"
	left1 = $"Stadium Stuff/AimPoints/Left1"
	left2 = $"Stadium Stuff/AimPoints/Left2"
	fielder = get_tree().get_first_node_in_group("Fielder")
	
	#connects player/fielder signals to functions placed here
	player.connect("popFly", popFly)
	player.connect("homeRun", homeRun)
	player.connect("grounder", grounder)
	player.connect("leftFoul", leftFoul)
	player.connect("rightFoul", rightFoul)
	fielder.connect("finished", resetForNextPitch)
	rng = RandomNumberGenerator.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#protections for when a ball is flying home run or foul, can't control the character etc
	if balltime:
		player.controllable = false
		timer += delta
		if timer > cutsceneBallLiveTime:
			resetForNextPitch()

#reset the game for the next pitch, everybody back to positions
func resetForNextPitch():
	player.upToBat()
	if newball != null:
		newball.queue_free()
	balltime = false
	timer = 0
	#pitcher.reset()

#randomly generates an x/z coordinate for the fielder to run to. could prob be in the fielder code but whatever
func getCatchDest():
	var randx = rng.randf_range(-15, 10)
	var randz = rng.randf_range(-15, 5)
	
	return Vector3(fielder.position.x + randx, 0, fielder.position.z + randz)

#signal connect functions, most call sendBall() below
func popFly():
	fielder.popFly(getCatchDest())
func homeRun():
	sendBall("homeRun")
func grounder():
	fielder.grounder(getCatchDest())
func leftFoul():
	sendBall("leftFoul")
func rightFoul():
	sendBall("rightFoul")

#instantiates a fake ball for the "cutscene" of a ball flying out of the stadium
func sendBall(type):
	newball = cutsceneBall.instantiate()
	add_child(newball)
	newball.position = ballSpawn.position
	#throw the ball at (sendVector() result position)
	newball.set_linear_velocity(global_transform.basis * sendVector(type))
	#(and sets ball time to true so the player can't move)
	balltime = true

#makes a fake vector that the cutscene ball will get launched with.
func sendVector(type):
	var xAng #left/right pos
	var yAng #up/down ang
	var zAng #power but also other stuff i dunoo
	match type:
		"homeRun": #HOME RUN
			xAng = rng.randf_range(-25, 25)
			yAng = 45
			zAng = rng.randf_range(-35, -50)

		"leftFoul": #LEFT FOUL
			xAng = rng.randf_range(-50, -20)
			yAng = rng.randf_range(10, 60)
			zAng = rng.randf_range(-10, -20)

		"rightFoul": #RIGHT FOUL
			xAng = rng.randf_range(20, 50)
			yAng = rng.randf_range(10, 60)
			zAng = rng.randf_range(-10, -20)
	
	return Vector3(xAng, yAng, zAng)
