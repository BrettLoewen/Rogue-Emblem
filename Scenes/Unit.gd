extends Node2D
class_name Unit

@export var sprite: Sprite2D

var tile: Tile


func SetSprite(texture: CompressedTexture2D):
	sprite.texture = texture


func SetTile(newTile: Tile):
	self.tile = newTile
