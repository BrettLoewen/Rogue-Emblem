extends Node2D
class_name Tile

@export var highlight: Sprite2D


func _ready():
	DeselectTile()


# Will be called when the mouse starts hovering over this tile
func _on_mouse_entered():
	# Add this tile to the selection queue
	if SelectionManager.Instance != null:
		SelectionManager.Instance.EnqueueTileForSelection(self)


# Will be called when the mouse stops hovering over this tile
func _on_mouse_exited():
	# Remove this tile from the selection queue
	if SelectionManager.Instance != null:
		SelectionManager.Instance.DequeueTileFromSelection(self)


# Used to highlight this tile to show it's been selected
func SelectTile():
	highlight.show()


# Used to stop highlighting this tile
func DeselectTile():
	highlight.hide()
