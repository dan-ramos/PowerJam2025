extends Node3D

func pitch():
	$AnimationPlayer.play("Shoot_Reload")

func idle():
	$AnimationPlayer.play("Idle")
