extends Node2D
class_name UnitManager

static var Instance: UnitManager

@export var unitSpawnOffset: Vector2i
@export var unitScene: PackedScene
@export var spawnVectors: Array[Vector2i]
@export var unitSprites: Array[CompressedTexture2D]
@export var isEnemy: Array[bool]
@export var unitStats: Array[Stats]

var units: Array[Unit]


func _ready():
	Instance = self
	SpawnUnits()


func SpawnUnits():
	for child in get_children():
		child.queue_free()
	
	var index := 0
	for coords in spawnVectors:
		var unit = unitScene.instantiate()
		add_child(unit)
	
		var tileId = TileManager.CreateTileId(coords.x, coords.y)
		var tile = TileManager.Instance.tiles[tileId]
		MoveUnitToTile(unit, tile)
		
		unit.stats = unitStats[index]
		unit.name = unit.stats.name
		
		if isEnemy[index] == false:
			unit.scale.x = -1
		else:
			unit.isEnemy = true
		unit.SetSprite(unitSprites[index])
		
		units.append(unit)
		
		index += 1


func MoveUnitToTile(unit: Unit, tile: Tile):
	var posX = unitSpawnOffset.x + (tile.coords.x * TileManager.Instance.tileSize.x)
	var posY = unitSpawnOffset.y + (tile.coords.y * TileManager.Instance.tileSize.y)
	unit.position = Vector2i(posX, posY)
	unit.SetTile(tile)


func GetUnitOnTile(tile: Tile):
	for unit in units:
		if unit.tile == tile:
			return unit
	return null
