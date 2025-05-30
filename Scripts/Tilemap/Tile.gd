extends Node2D

signal mouseEntered
signal mouseExited

func _on_mouse_entered():
	mouseEntered.emit()


func _on_mouse_exited():
	mouseExited.emit()
