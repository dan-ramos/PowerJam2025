extends Node3D

var cutsceneBallLiveTime = 4
var timer = 0

var timeTilNextBall = 2
var pitchTimer = 0

var balltime = false

var audioManager

var player
var rng
var fielder
var ballSpawn
var pitcher
var pitching = false
var newball
var cutsceneBall = preload("res://Scenes/Prefabs/cutsceneBall.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#variable name setup pulled from root tree
	player = $Player
	ballSpawn = $"Stadium Stuff/BallSpawnPoint"
	audioManager = $"BGM + Audio Manager"
	pitcher = $PitchingMarker
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
	else:
		handlePitching(delta)

func handlePitching(delta):
	if pitchTimer < timeTilNextBall:
		pitchTimer += delta
	elif pitchTimer > timeTilNextBall and not pitching:
		pitcher.pitch()
		pitching = true

#reset the game for the next pitch, everybody back to positions
func resetForNextPitch():
	player.upToBat()
	if newball != null:
		newball.queue_free()
	balltime = false
	timer = 0
	pitcher.reset()
	pitching = false
	pitchTimer = 0

#randomly generates an x/z coordinate for the fielder to run to. could prob be in the fielder code but whatever
func getCatchDest():
	var randx = rng.randf_range(-15, 10)
	var randz = rng.randf_range(-15, 5)
	
	return Vector3(fielder.position.x + randx, 0, fielder.position.z + randz)

#signal connect functions, most call sendBall() below
func popFly():
	fielder.popFly(getCatchDest())
	audioManager.playHitSound("PopFly", 1)
	balltime = true
func homeRun():
	sendBall("homeRun")
	audioManager.playHitSound("HomeRun", 1)
func grounder():
	fielder.grounder(getCatchDest())
	audioManager.playHitSound("Grounder", 1)
	balltime = true
func leftFoul():
	sendBall("leftFoul")
	audioManager.playHitSound("Foul", 1)
func rightFoul():
	sendBall("rightFoul")
	audioManager.playHitSound("Foul", 1)

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
