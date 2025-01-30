extends Node3D

signal finished

var fieldercam : Camera3D 
var timer = 0.0
var popRunTime = 2
var slidingTime = 2
var popCatchTime = 1
var groundRunTime = 2
var groundCatchTime = 1.5
var groundPullupTime = 2

var popFlying = false
var sliding = false
var getup = false

var grounding = false
var running = false
var gloveDown = false

var resetPos : Vector3
var runningDest : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	fieldercam = $FielderCam
	lookHome()
	resetPos = position


func _physics_process(delta):
	#these sections have relayed timers that go step by step through the fielders animations as they happen and he moves
	if popFlying:
		fieldercam.make_current()
		timer += delta
		if popFlying:
			if running:
				position = lerp(resetPos, runningDest, timer)
				if timer > popRunTime:
					timer = 0.0
					running = false
					sliding = true
					$AnimationPlayer.play("Dive")
			elif sliding:
				if timer > slidingTime:
					timer = 0.0
					sliding = false
					getup = true
					$AnimationPlayer.play("GET_UP")
			elif getup:
				if timer > popCatchTime:
					reset()

	if grounding:
		fieldercam.make_current()
		timer += delta
		if running:
			position = lerp(resetPos, runningDest, timer)
			if timer > groundRunTime:
				timer = 0.0
				running = false
				gloveDown = true
				$AnimationPlayer.play("Glove_Down")
				lookHome()
		elif gloveDown:
			if timer > groundCatchTime:
				timer = 0.0
				gloveDown = false
				$AnimationPlayer.play("Glove_Catch")
		else:
			if timer > groundPullupTime:
				reset()


#func demo_controls():
	#if Input.is_key_pressed(KEY_G):
		#grounder(Vector3(self.global_position.x + 5, 0, self.global_position.z + 2))
		#
	#if Input.is_key_pressed(KEY_P):
		#popFly(Vector3(self.global_position.x - 1, 0, self.global_position.z + 1.5))

#sets up for the popFly relay
func popFly(position):
	runningDest = position
	self.look_at(runningDest, Vector3.UP)
	popFlying = true
	running = true
	$AnimationPlayer.play("Run")

#sets up for the grounder relay
func grounder(position):
	runningDest = position
	self.look_at(runningDest, Vector3.UP)
	grounding = true
	running = true
	$AnimationPlayer.play("Run")

#gets the fielder back to where he stands, and sets all the flags back to their default values
func reset():
	$AnimationPlayer.play("Idle")
	lookHome()
	position = resetPos
	popFlying = false
	grounding = false
	running = false
	sliding = false
	getup = false
	timer = 0
	emit_signal("finished")

#makes the fielder rotate to face home plate but i don't think this actually works and im not gonna fix it
func lookHome():
	var home = get_tree().get_first_node_in_group("Home")
	if home:
		self.look_at(home.position, Vector3.UP)
