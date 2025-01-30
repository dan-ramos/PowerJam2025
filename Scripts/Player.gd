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

# Called when the node enters the scene tree for the first time.
func _ready():
	#sets up some variable names for child nodes
	reticle = $Reticle
	reticleRay = $Reticle/ReticleRay
	
	$AnimationPlayer.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if controllable:
		move_player();
	handle_reticle();
	
func handle_reticle():
	var ball = get_tree().get_first_node_in_group("Ball")
	var extension = 2
	#calculates a position beyond the ball based on the reticle's position. mostly for reticle debug lines
	var beyond = Vector3(ball.global_position.x * extension - reticle.global_position.x*2, ball.global_position.y * extension*.5 - reticle.global_position.z, ball.global_position.z * extension - reticle.global_position.z)
	if ball:
		reticleRay.target_position = beyond

#function to handle bat swings
func swing(ball):
	var dist = reticle.global_position.distance_to(ball.global_position)
	var ang = reticle.global_position.direction_to(ball.global_position)
	
	#this whole block of ifs and elifs determines which type of hit you get. 
	#each one emits a signal to the game manager script that continues the sequence
	if dist <= 0.16:
		print("Home Run!")
		emit_signal("homeRun")
		
	elif dist > 0.16 and dist <= 0.32:
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
		if int(ang.x * 10000) % 2 == 0:
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
		self.position.x = clamp(self.position.x, .64, 1.56);
	elif Input.is_action_pressed("Player_Right") and not Input.is_action_pressed("Player_Left"):
		self.position.x += moveSpeed;
		self.position.x = clamp(self.position.x, .64, 1.56);
	
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
		
		swing(ball)

#reset the batter for the next pitch
func upToBat():
	self.position.x = 1.16
	$AnimationPlayer.play("Idle")
	controllable = true

#debug stuff, unused now but kept for idk why
#func draw_debug_ray(ball):
	#for l in lines:
		#l.queue_free()
	#lines.clear()
	#var extension = 2
	#var beyond = Vector3(ball.global_position.x * extension - reticle.global_position.x*10, ball.global_position.y * extension*1.5, ball.global_position.z * extension - reticle.global_position.z)
	#lines.append(await Draw3d.line(beyond, reticle.global_position, Color.FIREBRICK))
