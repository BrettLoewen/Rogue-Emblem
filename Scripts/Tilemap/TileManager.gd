#@tool
extends Node2D
class_name TileManager

static var Instance: TileManager

@export var tileScene: PackedScene			# The tile scene used for the tilemap
@export var gridSize := Vector2i(6, 6)		# Defines how many tiles will be spawned
@export var tileSize := Vector2i(56, 42)	# Defines how much space a tile takes up

@export var tiles: Dictionary	# Stores references to all of the tiles


# Called when the node enters the scene tree for the first time.
func _ready():
	Instance = self
	SpawnTiles()


func SpawnTiles():
	print("Spawning")
	if not tileScene:
		push_error("No tile scene assigned to TileManager!")
		return
	
	for child in get_children():
		child.queue_free()
	
	tiles.clear()
	
	for x in range(gridSize.x):
		for y in range(gridSize.y):
			var tile = tileScene.instantiate()
			tile.position = Vector2i(x * tileSize.x, y * tileSize.y)
			var tileId = CreateTileId(x, y)
			tile.SetCoords(x, y)
			tile.name = "Tile - {0}, {1}".format([x, y])
			
			add_child(tile)
			tiles[tileId] = tile
			
			# Used for in-editor spawning of tilemap
			#tile.owner = self.get_tree().edited_scene_root


static func CreateTileId(x: int, y: int):
	return "{0}|{1}".format([x, y])


func ResetPathfindingTiles():
	for tile in tiles.values():
		tile.parent = null
		tile.distance = 1000 # Big number so every distance check is less
		tile.visited = false
		tile.ResetHighlightTile()


func CalcWalkableTiles(unit: Unit):
	print("Calc tiles for {0} with movement {1}".format([unit.stats.name, unit.stats.movement]))
	
	var walkableTiles: Array[Tile]
	
	for tile in tiles.values():
		tile.parent = null
		tile.distance = 1000 # Big number so every distance check is less
		tile.visited = false
		tile.ResetHighlightTile()
	
	# Start by processing the tile the unit is currently on
	var tileQueue: Array[Tile]
	tileQueue.append(unit.tile)
	unit.tile.visited = true
	unit.tile.distance = 0
	
	# Until every tile in the movement distance is processed, keep expanding and processing
	while tileQueue.size() > 0:
		var tile = tileQueue.pop_front()
		print("Tile: {0}".format([CreateTileId(tile.coords.x, tile.coords.y)]))
		
		# Is the tile walkable?
		if tile.distance <= unit.stats.movement:
			walkableTiles.append(tile)
			tile.HighlightTile(Color(0, 0, 255, 0.5))
			
			# Check the neighbouring tiles
			AddTileToQueue(tileQueue, tile, tile.coords.x, tile.coords.y - 1) # up
			AddTileToQueue(tileQueue, tile, tile.coords.x, tile.coords.y + 1) # down
			AddTileToQueue(tileQueue, tile, tile.coords.x - 1, tile.coords.y) # left
			AddTileToQueue(tileQueue, tile, tile.coords.x + 1, tile.coords.y) # right
	
	


func AddTileToQueue(queue: Array[Tile], parent: Tile, x: int, y: int):
	var tile = GetTile(x, y)
	if tile != null:
		var distance = parent.distance + 1
		
		# If this tile has not been checked or a better path was found
		if tile.visited == false or tile.distance > distance:
			tile.parent = parent
			tile.visited = true
			tile.distance = distance
			queue.append(tile)


func GetTile(x: int, y: int):
	var id = CreateTileId(x, y)
	if tiles.has(id):
		return tiles[id]
	else:
		return null
