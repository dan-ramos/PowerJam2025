extends Node3D

var reticle 
var reticleRay: RayCast3D
var hitpath
var lines = []
@export var moveSpeed := .02

# Called when the node enters the scene tree for the first time.
func _ready():
	reticle = $Reticle
	reticleRay = $Reticle/ReticleRay
	
	$AnimationPlayer.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_player();
	handle_reticle();
	
func handle_reticle():
	var ball = get_tree().get_first_node_in_group("Ball")
	var extension = 2
	var beyond = Vector3(ball.global_position.x * extension - reticle.global_position.x*2, ball.global_position.y * extension*.5 - reticle.global_position.z, ball.global_position.z * extension - reticle.global_position.z)
	if ball:
		reticleRay.target_position = beyond

func swing(ball):
	var dist = reticle.global_position.distance_to(ball.global_position)
	var ang = reticle.global_position.direction_to(ball.global_position)
	print("dist:", dist, "\nang:", ang)
	
	if dist <= 0.16:
		print("Home Run!")
	elif dist > 0.16 and dist <= 0.26:
		if ang.x*100 < -45:
			print("Left Foul")
		elif ang.x*100 > 45:
			print("Right Foul")
		else:
			print("Home Run!")
	elif dist > 0.26 and dist <= 0.41:
		if int(ang.x * 10000) % 2 == 0:
			print("Pop Fly! Out!")
		else:
			print("Grounder! Out!")
	else:
		print("Miss!")
	
	#if reticleRay.is_colliding():
		#var collider = reticleRay.get_collider()
		#print(collider.name)
		#if collider.is_in_group("ScoreZone"):
			#print(collider.name)

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
		draw_debug_ray(ball);
		
		swing(ball)

func draw_debug_ray(ball):
	for l in lines:
		l.queue_free()
	lines.clear()
	var extension = 2
	var beyond = Vector3(ball.global_position.x * extension - reticle.global_position.x*10, ball.global_position.y * extension*1.5, ball.global_position.z * extension - reticle.global_position.z)
	lines.append(await Draw3d.line(beyond, reticle.global_position, Color.FIREBRICK))
