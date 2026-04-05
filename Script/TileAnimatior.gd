extends Node

var i:int = 0
var d:int = 0
var maxpool: int = 2
@export var rhythm:RhythmNotifier
@onready var time = rhythm.beat_length
@onready var halfTime = time /2
@onready var mainTile:TileMapLayer = get_parent()
@onready var treeId:Array[int] = Global.house_registry[Global.HouseID.Trees].tileMapID
@onready var treeSpawnPoints:Array[Vector2i] = Global.house_registry[Global.HouseID.Trees].tileMapPosition
var startScale:Vector2 =-Vector2(0.2,0.1)
var endScale:Vector2 =Vector2(0.2,0.1)

var tile:TileData
 
class HouseInfo: 
	var id: Global.HouseID
	var data: TileData
	func _init(_id: Global.HouseID, _data: TileData):
		id = _id
		data = _data
var houseInfo:Array[HouseInfo]
var positionDic: Dictionary[Vector2i, HouseInfo] = {}
#Adds the trees in the Tilemap to the trees[Array]
func _on_main_layer_trees_spawned(trees):
	for tree_pos in trees:
		var data = mainTile.get_cell_tile_data(tree_pos)
		positionDic[tree_pos] = HouseInfo.new( Global.HouseID.Trees, data)

#Code Function and works for trees but Assets are missing and looks weird
#TODO: MAKE ASSETES THAT I KNOW HOW IT Looks
func _on_rhythm_notifier_beat(current_beat):
	if !GlobalSettings.animations:
		return
		
	i = (i + 1) % maxpool
	d = (i + 1) % maxpool 
	var deleteArray: Array[Vector2i] = []
	for pos in positionDic.keys():
		var info = positionDic[pos]
		
		if mainTile.get_cell_tile_data(pos) == null:
			deleteArray.append(pos)
			continue
		if info.id == Global.HouseID.Trees:
			if (pos.x + pos.y) % 2 == 0:
				mainTile.set_cell(pos, treeId[i], treeSpawnPoints[i])
			else:
				mainTile.set_cell(pos, treeId[d], treeSpawnPoints[d])
		if info.id == Global.HouseID.Default:
			var tween1:Tween = get_tree().create_tween()
			tile = info.data
			tween1.tween_method(set_shader_value,startScale,endScale,halfTime).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween1.tween_method(set_shader_value,endScale,startScale,halfTime).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	for pos in deleteArray:
		positionDic.erase(pos)

func Finished():
	set_shader_value(Vector2(0,0))

func _on_node_2d_early_full_miss():
	maxpool =2


func _on_node_2d_changed_house_at_position(house_id, pos, _world_position):
	var data = mainTile.get_cell_tile_data(pos)
	positionDic[pos] = HouseInfo.new( house_id, data)

func set_shader_value(value: Vector2 ):
	tile.material.set_shader_parameter("deformation", value)
