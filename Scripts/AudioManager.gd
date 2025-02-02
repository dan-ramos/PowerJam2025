extends AudioStreamPlayer

const bgmpath = "res://Sounds/Music/BatterBots.wav"
var bgm = preload(bgmpath)

var players

func _ready():
	self.stream = bgm
	
	play()

func playHitSound(soundType, waitTime):
	match soundType:
		"Foul":
			var list = []
			for i in range(1, 23):
				list.append("res://Sounds/Foul/" + str(i) + ".wav")
			var i = list.pick_random()
			playSound(i, waitTime)
		"Grounder":
			var list = []
			for i in range(1, 13):
				list.append("res://Sounds/Grounder/" + str(i) + ".wav")
			var i = list.pick_random()
			playSound(i, waitTime)
		"HomeRun":
			var list = []
			for i in range(1, 22):
				list.append("res://Sounds/HomeRun/" + str(i) + ".wav")
			var i = list.pick_random()
			playSound(i, waitTime)
		"PopFly":
			var list = []
			for i in range(1, 16):
				list.append("res://Sounds/PopFly/" + str(i) + ".wav")
			var i = list.pick_random()
			playSound(i, waitTime)
		"Strike":
			var list = []
			for i in range(1, 24):
				list.append("res://Sounds/Strike/" + str(i) + ".wav")
			var i = list.pick_random()
			playSound(i, waitTime)

func playSound(sound, waitTime):
	players = get_children()
	
	var firstFree
	for i in players:
		if i.is_playing():
			continue
		else:
			wait(waitTime)
			var fx = load(sound)
			i.stream = fx
			i.play()
			break

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
