###This Script adds the the list for the Labels.
extends HBoxContainer

@onready var Icons: Array[Texture2D] = Global.PointsIcons
@onready var houseSelected:Array[Global.HouseID] = Global.HouseSelected
@onready var Resources: Array[Global.Points] = Global.MakeResources
var CurrentResources: Array[Global.Points]

var IconScene:Resource = preload("res://Level/icon.tscn")
var LabelScene:Resource = preload("res://Level/icon_label.tscn")

var Labels:Array[Label]

func _ready():
	var currentPosition : int = 0
	for x in houseSelected.size():
		var current_res = Resources[x] 
		
		if current_res in CurrentResources:
			continue
		
		CurrentResources.append(current_res)
	
		var instance: TextureRect = IconScene.instantiate()
		instance.texture = Icons[x]
		add_child(instance)
		move_child(instance, currentPosition)
		currentPosition +=1
		Labels.append(LabelScene.instantiate())
		add_child(Labels[-1])
		move_child(Labels[-1],currentPosition)
		currentPosition +=1



func _on_node_2d_update_values():
	var i:int = 0
	for res in CurrentResources:
		Labels[i].text = str(Global.currentResources[res])
		i+=1
