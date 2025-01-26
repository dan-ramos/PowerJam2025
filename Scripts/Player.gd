extends Node

var reticle
var hitpath
var lines = []
@export var moveSpeed := .02

# Called when the node enters the scene tree for the first time.
func _ready():
	reticle = $Reticle
	hitpath = $Path3D
	
	$AnimationPlayer.play("Idle")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_player();

func move_player():
	if Input.is_action_pressed("Player_Left") and not Input.is_action_pressed("Player_Right"):
		self.position.x -= moveSpeed;
		#self.position.x = clamp(self.position.x, .7, 1.3);
	elif Input.is_action_pressed("Player_Right") and not Input.is_action_pressed("Player_Left"):
		self.position.x += moveSpeed;
		#self.position.x = clamp(self.position.x, .7, 1.3);
	
	if Input.is_action_pressed("Center"):
		self.position.x = 1
		
	if Input.is_action_just_pressed("Swing"):
		var ball = get_tree().get_first_node_in_group("Ball")
		
		$AnimationPlayer.play("Swing")
		
		#clears up any lines that already exist and draws a fresh one
		for l in lines:
			l.queue_free()
		lines.clear()
		var extension = 10
		var beyond = Vector3(ball.global_position.x * extension - reticle.global_position.x, ball.global_position.y * extension/6, ball.global_position.z * extension - reticle.global_position.z)
		lines.append(await Draw3d.line(beyond, reticle.global_position, Color.FIREBRICK))
