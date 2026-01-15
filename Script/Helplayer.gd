extends TileMapLayer

signal CanBuildThere(signalDictionary)
@export var tilemap: TileMapLayer
@onready var Helplayer2: TileMapLayer = $HelpLayer

var signalDictionary = {false:"CanBuild",Vector2i(0,0):"CurrentPosition",[]:"RemovePositions"}

var lastHelpVisual: Vector2i
var lastHelpVisualController: Vector2i
var treesInRange: Array[Variant] = [Vector2i(0,0)]

var tree_tile_data:Array[TileData]
var house_tile_data:Array[TileData]
var tile_data:TileData
var HelpVisual:Dictionary = {"True":Vector2i(0,0),"False":Vector2i(1,0)}

var world_pos: Vector2 
var tile_coords: Vector2i

@onready var curretnHouse:Global.HouseID = Global.HouseSelected[0]
@onready var currentHousestats = Global.house_registry[curretnHouse]

var ControlerAktive:bool
var HouseRange:int


func _ready():
	var outOufBoundsSpawnPoints: Vector2i= Vector2i(-1000,-1000)
	for house in Global.house_registry:
		for i in Global.house_registry[house].tileMapPosition.size():
			tilemap.set_cell(outOufBoundsSpawnPoints,Global.house_registry[house].tileMapID[i],Global.house_registry[house].tileMapPosition[i])
			match Global.house_registry[house].houseType:
				Global.HouseType.Trees:
					tree_tile_data.append(tilemap.get_cell_tile_data(outOufBoundsSpawnPoints))
				Global.HouseType.Houses:
					house_tile_data.append(tilemap.get_cell_tile_data(outOufBoundsSpawnPoints))
	#outOufBoundsSpawnPoints = Vector2i(outOufBoundsSpawnPoints.x+1,outOufBoundsSpawnPoints.y+1)

func _input(event):
	if event.is_action_pressed("Controller_Down"):
		tile_coords.y += 1
		ControlerAktive = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if event.is_action_pressed("Controller_Left"):
		tile_coords.x -= 1
		ControlerAktive = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if event.is_action_pressed("Controller_Up"):
		tile_coords.y -= 1
		ControlerAktive = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if event.is_action_pressed("Controller_Right"):
		tile_coords.x += 1
		ControlerAktive = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	

func _process(_delta) ->void:
	world_pos= get_global_mouse_position()
	var mousetile = self.local_to_map(world_pos) 
	if  lastHelpVisual != mousetile && !ControlerAktive:
		tile_coords = mousetile
	elif lastHelpVisual.distance_to(mousetile) > 2:
		ControlerAktive = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif lastHelpVisual == mousetile && !ControlerAktive:
		return
	if HouseRange !=  0:
		RemoveHelpRemoveLayer()
	self.set_cell(lastHelpVisual,0)
	self.set_cell(lastHelpVisualController,0)
	Helplayer2.set_cell(lastHelpVisual,0)
	Helplayer2.set_cell(lastHelpVisualController,0)
	tile_data = tilemap.get_cell_tile_data(tile_coords)
	
	if tile_data == null ||  tree_tile_data.has(tile_data) :
		self.set_cell(tile_coords,0, HelpVisual.get("True"))
		signalDictionary["CanBuild"] = true
		signalDictionary["CurrentPosition"] = tile_coords
		Helplayer2.set_cell(tile_coords,currentHousestats.tileMapID[0],currentHousestats.tileMapPosition[0])
		AddHelpRemoveLayer(curretnHouse)
			
	else: 
		self.set_cell(tile_coords,0, HelpVisual.get("False"))
		signalDictionary["CanBuild"] = false
	if !ControlerAktive:
		lastHelpVisual = tile_coords
	else:
		lastHelpVisualController = tile_coords
	emit_signal("CanBuildThere",signalDictionary)


func AddHelpRemoveLayer(House:Global.HouseID):
	
	if Global.house_registry.has(House):
		var stats = Global.house_registry[House]
		HouseRange = stats.houseRange
	else:
		HouseRange = 0
	if HouseRange == 0:
		return
	for x in range(-HouseRange, HouseRange + 1):
		for y in range(-HouseRange, HouseRange + 1):
			var offset: Vector2 = Vector2(x, y)
			if offset.length() <= HouseRange:
				var target_coords: Vector2i = tile_coords + Vector2i(x, y)
				var check_tile: TileData = tilemap.get_cell_tile_data(target_coords)
				if tree_tile_data.has(check_tile):
					self.set_cell(target_coords,0,HelpVisual.get("True"))
					treesInRange.append(target_coords) 
		signalDictionary["RemovePositions"] = treesInRange

func RemoveHelpRemoveLayer():
	for n in treesInRange:
		self.set_cell(n,0)
	treesInRange.clear()
	if signalDictionary.has("RemovePositions"):
		signalDictionary["RemovePositions"].clear()
	else:
		signalDictionary["RemovePositions"] = []

func _on_backgorund_switch_house(House):
	RemoveHelpRemoveLayer()
	curretnHouse = Global.HouseSelected[House]
	currentHousestats = Global.house_registry.get(curretnHouse)
	tile_data = tilemap.get_cell_tile_data(tile_coords)
	if tile_data == null || tree_tile_data.has(tile_data):
		Helplayer2.set_cell(tile_coords,currentHousestats.tileMapID[0],currentHousestats.tileMapPosition[0])
	AddHelpRemoveLayer(House)

func _on_node_2d_update_values():
	RemoveHelpRemoveLayer()
	signalDictionary["CanBuild"] = false
	emit_signal("CanBuildThere",signalDictionary)
	self.set_cell(tile_coords,0, HelpVisual.get("False"))
	
