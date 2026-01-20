extends Control

@export var canvasLayer:CanvasLayer

func _ready():
	if Global.HouseUnlocked.size() < 2:
		#canvasLayer.visible = false
		pass
