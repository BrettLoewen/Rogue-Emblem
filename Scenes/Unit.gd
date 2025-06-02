extends Node2D
class_name Unit

@export var sprite: Sprite2D


func SetSprite(texture: CompressedTexture2D):
	sprite.texture = texture
