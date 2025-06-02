@tool
extends Node2D
class_name TileManager

static var Instance: TileManager

@export var tileScene: PackedScene			# The tile scene used for the tilemap
@export var gridSize := Vector2i(6, 6)		# Defines how many tiles will be spawned
@export var tileSize := Vector2i(56, 42)	# Defines how much space a tile takes up

var tiles: Dictionary	# Stores references to all of the tiles


# Called when the node enters the scene tree for the first time.
func _ready():
	Instance = self


func SpawnTiles():
	print("Spawning")
	if not tileScene:
		push_error("No tile scene assigned to TileManager!")
		return
	
	for child in get_children():
		child.queue_free()
		
	for x in range(gridSize.x):
		for y in range(gridSize.y):
			var tile = tileScene.instantiate()
			tile.position = Vector2i(x * tileSize.x, y * tileSize.y)
			tile.name = "Tile - {0}, {1}".format([x, y])
			add_child(tile)
			tile.owner = self.get_tree().edited_scene_root
