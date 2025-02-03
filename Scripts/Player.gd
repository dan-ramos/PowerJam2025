extends Node3D

signal popFly
signal grounder
signal leftFoul
signal rightFoul
signal homeRun

@export var controllable = true

var reticle 
var reticleRay: RayCast3D
var hitpath
var lines = []
@export var moveSpeed := .02
var health = 5

var rng
var batCrackPath
var batCrackPlayer : AudioStreamPlayer
const batCrackSFX = preload("res://Sounds/SFX/batCrack.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	#sets up some variable names for child nodes
	reticle = $Reticle
	reticleRay = $Reticle/ReticleRay
	
	batCrackPlayer = $HitSound
	batCrackPlayer.stream = batCrackSFX
	rng = RandomNumberGenerator.new()
	
	$AnimationPlayer.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if controllable:
		move_player();

func ouch(dmg):
	print(health, dmg)
	health -= dmg
	print(health)
	
func getHP():
	return health

#function to handle bat swings
func swing(ball):
	var dist = reticle.global_position.distance_to(ball.global_position)
	var ang = reticle.global_position.direction_to(ball.global_position)
	
	print(dist)
	
	batCrackPlayer.pitch_scale = rng.randf_range(0.7, 1.2)
	
	#this whole block of ifs and elifs determines which type of hit you get. 
	#each one emits a signal to the game manager script that continues the sequence
	if dist <= 0.16:
		print("Home Run!")
		emit_signal("homeRun")
		batCrackPlayer.play()
		
	elif dist > 0.16 and dist <= 0.32:
		batCrackPlayer.play()
		
		if ang.x*100 < -45:
			print("Left Foul")
			emit_signal("leftFoul")
		elif ang.x*100 > 45:
			print("Right Foul")
			emit_signal("rightFoul")
		else:
			print("Home Run!")
			emit_signal("homeRun")
			
	elif dist > 0.32 and dist <= 0.45:
		batCrackPlayer.play()
		
		var coin = rng.randi()
		if coin % 2 == 0:
			print("Pop Fly! Out!")
			emit_signal("popFly")
		else:
			print("Grounder! Out!")
			emit_signal("grounder")
			
	else:
		print("Miss!")
	
#handles what the player can do, including moving and swinging the bat
func move_player():
	if Input.is_action_pressed("Player_Left") and not Input.is_action_pressed("Player_Right"):
		self.position.x -= moveSpeed;
		self.position.x = clamp(self.position.x, -.5, .5);
	elif Input.is_action_pressed("Player_Right") and not Input.is_action_pressed("Player_Left"):
		self.position.x += moveSpeed;
		self.position.x = clamp(self.position.x, -.5, .5);
	
	if Input.is_key_pressed(KEY_Z):
		var othercam = $"../Stadium Stuff/Camera3D2"
		othercam.make_current()
	else:
		var cam = $"../Stadium Stuff/Camera3D"
		cam.make_current()
	
	if Input.is_action_pressed("Center"):
		self.position.x = 1.16
		
	if Input.is_action_just_pressed("Swing"):
		var ball = get_tree().get_first_node_in_group("Ball")
		
		$AnimationPlayer.play("Swing")
		#uncomment this next line to show the debug line that doesnt work
		#draw_debug_ray(ball);
		if ball != null:
			swing(ball)

#reset the batter for the next pitch
func upToBat():
	self.position.x = -0.06
	$AnimationPlayer.play("Idle")
	controllable = true

