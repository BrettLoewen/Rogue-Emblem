extends Node
class_name SelectionManager

static var Instance: SelectionManager

# Variables for tracking the selected tile (the tile the player's mouse is currently over)
var selectedTileQueue: Array[Tile]
var selectedTile: Tile
var selectedTileGridPos: Vector2i

var selectedUnit: Unit


func _ready():
	Instance = self


func _process(_delta):
	TileSelectHandler()
	InputHandler()


func InputHandler():
	if TileManager.Instance == null or TileManager.Instance.tiles == null:
		return
	if selectedTile == null:
		return
	
	if selectedUnit != null:
		# Try to move the unit
		if Input.is_action_just_pressed("select"):
			var unit = UnitManager.Instance.GetUnitOnTile(selectedTile)
			if unit == null:
				UnitManager.Instance.MoveUnitToTile(selectedUnit, selectedTile)
				selectedUnit = null
		# Deselect the unit
		elif Input.is_action_just_pressed("cancel"):
			selectedUnit = null
	else:
		# Select the unit
		if Input.is_action_just_pressed("select"):
			var unit = UnitManager.Instance.GetUnitOnTile(selectedTile)
			if unit != null:
				selectedUnit = unit


func TileSelectHandler():
	# If a new tile should be selected
	if selectedTileQueue.size() > 0 && selectedTile != selectedTileQueue[0]:
		# Deselect the selected tile
		if selectedTile != null:
			selectedTile.DeselectTile()
		
		# Select the new tile
		selectedTile = selectedTileQueue[0]
		selectedTile.SelectTile()
	
	# If no tile should be selected right now, then make sure none are
	elif selectedTileQueue.size() == 0:
		if selectedTile != null:
			selectedTile.DeselectTile()
			selectedTile = null


# Used to add tiles to the selected tile queue so they can be selected as needed
func EnqueueTileForSelection(tileToEnqueue):
	selectedTileQueue.push_back(tileToEnqueue)


# Used to remove tiles from the selected tile queue so the next tile can be selected
func DequeueTileFromSelection(tileToDequeue):
	# The tile might not be the first tile in the queue, so we need to find it and then remove it
	var index = selectedTileQueue.find(tileToDequeue)
	if index >= 0:
		selectedTileQueue.remove_at(index)
