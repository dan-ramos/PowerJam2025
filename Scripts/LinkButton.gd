extends TextureButton

@export var link_to_open : String

func _process(delta):
	if Input.is_key_pressed(KEY_TAB):
		$"../../controls".visible = true
	else:
		$"../../controls".visible = false

func _on_pressed():
	OS.shell_open(link_to_open)
