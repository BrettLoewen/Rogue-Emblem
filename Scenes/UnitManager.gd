extends Node2D
class_name UnitManager

@export var unitSpawnOffset: Vector2i
@export var unitScene: PackedScene
@export var spawnVectors: Array[Vector2i]
@export var unitSprites: Array[CompressedTexture2D]
@export var isEnemy: Array[bool]

var units: Array[Unit]


func _ready():
	SpawnUnits()


func SpawnUnits():
	for child in get_children():
		child.queue_free()
	
	var index := 0
	for coords in spawnVectors:
		var unit = unitScene.instantiate()
		var posX = unitSpawnOffset.x + (coords.x * TileManager.Instance.tileSize.x)
		var posY = unitSpawnOffset.y + (coords.y * TileManager.Instance.tileSize.y)
		unit.position = Vector2i(posX, posY)
		if isEnemy[index] == false:
			unit.scale.x = -1
		unit.SetSprite(unitSprites[index])
		
		add_child(unit)
		units.append(unit)
		
		index += 1
