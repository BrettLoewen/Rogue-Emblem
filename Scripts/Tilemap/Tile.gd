extends Node2D
class_name Tile

@export var edgeLines: Sprite2D
@export var highlight: Sprite2D
@export var mouseDetector: Area2D

var coords: Vector2i


func _ready():
	mouseDetector.mouse_entered.connect(_on_mouse_entered)
	mouseDetector.mouse_exited.connect(_on_mouse_exited)
	DeselectTile()
	ResetHighlightTile()


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


# Used to to show that this tile has been selected
func SelectTile():
	edgeLines.show()


# Used to stop showing selecting this tile
func DeselectTile():
	edgeLines.hide()


# Used to highlight this tile
func HighlightTile(color: Color):
	highlight.modulate = color
	highlight.show()


# Used to stop highlighting this tile
func ResetHighlightTile():
	highlight.hide()


func SetCoords(x: int, y: int):
	coords = Vector2i(x, y)
