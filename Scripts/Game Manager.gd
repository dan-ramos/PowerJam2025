extends Node3D

var cutsceneBallLiveTime = 4
var timer = 0

var score = 0

var timeTilNextBall = 2
var pitchTimer = 0
var pitchAnimTime = 1
var pitchAnimTimer = 0
var introTimer = 0
var introTime = 8.5

var boardTimer = 0
var boardTime = 10

var intro = true
var balltime = false

var audioManager

var damage = 0
var player
var rng
var fielder
var ballSpawn
var pitcher
var pitchBot
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
	pitchBot = $PitchBot
	fielder = get_tree().get_first_node_in_group("Fielder")
	
	#connects player/fielder signals to functions placed here
	player.connect("popFly", popFly)
	player.connect("homeRun", homeRun)
	player.connect("grounder", grounder)
	player.connect("leftFoul", leftFoul)
	player.connect("rightFoul", rightFoul)
	fielder.connect("finished", resetForNextPitch)
	pitcher.connect("strike", strike)
	rng = RandomNumberGenerator.new()
	$Player/AnimationPlayer.play("Into")
	$PitchBot/AnimationPlayer.play("Intro")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	handleUI()
	if player.getHP() <= 0:
		get_tree().change_scene_to_file('res://Scenes/gameOver.tscn')
	
	#protections for when a ball is flying home run or foul, can't control the character etc
	if intro:
		introTimer += delta
		if introTimer > introTime:
			intro = false
			resetForNextPitch()
	elif balltime:
		var csb = get_tree().get_first_node_in_group("CSB")
		if csb != null:
			$"Stadium Stuff/Camera3D".look_at(csb.global_position)
		player.controllable = false
		timer += delta
		if timer > cutsceneBallLiveTime:
			resetForNextPitch()
	else:
		handlePitching(delta)
		$"Stadium Stuff/Camera3D".rotation = Vector3(-0.144426, 0, 0)

func handlePitching(delta):
	if pitchTimer < timeTilNextBall:
		pitchTimer += delta
	elif pitchTimer > timeTilNextBall and not pitching:
		pitcher.pitch()
		pitching = true

func handleUI():
	$UI/TextureRect.texture = load("res://Images/batteries/battery" + str(player.getHP()) + ".png")
	$UI/hpLabel.text = "Dingers: " + str(score)

func strike():
	damage = 1
	audioManager.playHitSound("Strike", 1)
	$HitMessage/TextureRect.texture = load("res://Images/HitStatusSprites/Srike.png")
	$HitMessage/AnimationPlayer.play("show")
	resetForNextPitch()

#reset the game for the next pitch, everybody back to positions
func resetForNextPitch():
	player.ouch(damage)
	player.upToBat()
	if newball != null:
		newball.queue_free()
	balltime = false
	timer = 0
	pitcher.reset()
	pitching = false
	pitchTimer = 0
	damage = 0
	$PitchingMarker.reset()
	pitchBot.pitch()

#randomly generates an x/z coordinate for the fielder to run to. could prob be in the fielder code but whatever
func getCatchDest():
	var randx = rng.randf_range(-15, 10)
	var randz = rng.randf_range(-15, 5)
	
	return Vector3(fielder.position.x + randx, 0, fielder.position.z + randz)

#signal connect functions, most call sendBall() below
func popFly():
	damage = 1
	fielder.popFly(getCatchDest())
	audioManager.playHitSound("PopFly", 1)
	balltime = true
	$PitchingMarker.ballHit()
	$HitMessage/TextureRect.texture = load("res://Images/HitStatusSprites/out.png")
	$HitMessage/AnimationPlayer.play("show")
func homeRun():
	damage = 0
	score += 1
	sendBall("homeRun")
	audioManager.playHitSound("HomeRun", 1)
	$PitchingMarker.ballHit()
	$HitMessage/TextureRect.texture = load("res://Images/HitStatusSprites/HOmerun.png")
	$HitMessage/AnimationPlayer.play("show")
func grounder():
	damage = 1
	fielder.grounder(getCatchDest())
	audioManager.playHitSound("Grounder", 1)
	$PitchingMarker.ballHit()
	$HitMessage/TextureRect.texture = load("res://Images/HitStatusSprites/out.png")
	$HitMessage/AnimationPlayer.play("show")
	balltime = true
func leftFoul():
	damage = 0
	sendBall("leftFoul")
	audioManager.playHitSound("Foul", 1)
	$PitchingMarker.ballHit()
	$HitMessage/TextureRect.texture = load("res://Images/HitStatusSprites/foul.png")
	$HitMessage/AnimationPlayer.play("show")
func rightFoul():
	damage = 0
	sendBall("rightFoul")
	audioManager.playHitSound("Foul", 1)
	$PitchingMarker.ballHit()
	$HitMessage/TextureRect.texture = load("res://Images/HitStatusSprites/foul.png")
	$HitMessage/AnimationPlayer.play("show")

#instantiates a fake ball for the "cutscene" of a ball flying out of the stadium
func sendBall(type):
	newball = cutsceneBall.instantiate()
	add_child(newball)
	newball.position = ballSpawn.position
	#throw the ball at (sendVector() result position)
	newball.set_linear_velocity(global_transform.basis * sendVector(type))
	newball.apply_torque(Vector3(randf_range(-15, 15), randf_range(-15, 15), randf_range(-15, 15)))
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
