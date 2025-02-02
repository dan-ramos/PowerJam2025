extends AudioStreamPlayer

const startBanterPath = 'res://Sounds/Banter/banter_START.wav'
const bgmPath = 'res://Sounds/Music/Mario Stadium - Mario Super Sluggers Music Extended.ogg'
const ambiencePath = "res://Sounds/SFX/baseball-sounds-52818.ogg"
var ambient = preload(ambiencePath)
var bgm = preload(bgmPath)
var startBanter = preload(startBanterPath)

var waiting = true

var bootTime = 1.5
var waitTimer = 0
var banterTimer = 5
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.stream = startBanter
	$BgmPlayer.stream = bgm
	$BgmPlayer.play()
	
	$"ambient crowd".stream = ambient
	$"ambient crowd".play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not waiting:
		if not self.is_playing():
			timer += delta
			
			if timer > banterTimer:
				var list = []
				for i in range(1, 16):
					list.append("res://Sounds/Banter/" + str(i) + ".wav")
				var i = list.pick_random()
				var bntr = load(i)
				self.stream = bntr
				play()
				
				timer = 0
	else:
		waitTimer += delta
		if waitTimer > bootTime:
			waiting = false
			play()
