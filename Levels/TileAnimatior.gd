extends Node

var i:int = 0
var d:int = 0
var maxpool: int = 2
@onready var mainTile:TileMapLayer = get_parent()
@onready var treeId:Array[int] = Global.house_registry[Global.HouseID.Trees].tileMapID
@onready var treeSpawnPoints:Array[Vector2i] = Global.house_registry[Global.HouseID.Trees].tileMapPosition
@export var positionDic: Dictionary[Vector2i,Global.HouseID]

func _on_main_layer_trees_spawned(trees):
	for tree in trees:
		positionDic.get_or_add(tree,Global.HouseID.Trees)

#Code Function and works for trees but Assets are missing and looks weird
#TODO: MAKE ASSETES THAT I KNOW HOW IT Looks
func _on_rhythm_notifier_beat(_current_beat):
	if !GlobalSettings.animations:
		return
	i = (i +1) % maxpool
	d = (i +1) % maxpool
	var deleteArray:Array[Vector2i] = []
	for positions in positionDic:
		if mainTile.get_cell_tile_data(positions) == null:
			deleteArray.append(positions)
			continue
		if positionDic[positions] == Global.HouseID.Trees:
			if (positions.x+positions.y) %2 == 0:
				mainTile.set_cell(positions,treeId[i],treeSpawnPoints[i])
			else:
				mainTile.set_cell(positions,treeId[d],treeSpawnPoints[d])
	for position in deleteArray:
		positionDic.erase(position)


func _on_node_2d_early_full_miss():
	maxpool =2

func _on_node_2d_changed_house_at_position(HouseId, position,_WorldPositon ):
	positionDic.set(position,HouseId)
	pass # Replace with function body.
