extends TextureButton

@export var link_to_open : String

func _on_pressed():
	OS.shell_open(link_to_open)
