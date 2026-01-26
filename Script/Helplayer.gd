extends TileMapLayer

signal CanBuildThere(signalDictionary)
@export var tilemap: TileMapLayer
@export var controllerSpeed: float = 5
@onready var Helplayer2: TileMapLayer = $HelpLayer

var signalDictionary = {"CanBuild":false,"CurrentPosition":[],"RemovePositions":[]}

var lastHelpVisual: Array[Vector2i] = [Vector2i(0,0)]
var lastHelpVisualController: Array[Vector2i] = [Vector2i(0,0)]
var tileInRange: Array[Variant] = [Vector2i(0,0)]

var tree_tile_data:Array[TileData]
var house_tile_data:Array[TileData]
var buildTiles:Array[Vector2i]
var tile_data:TileData
var HelpVisual:Dictionary = {"True":Vector2i(0,0),"False":Vector2i(1,0)}

var world_pos: Vector2 

var world_contr_pos:Vector2 
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
func _physics_process(_delta):
	var direction = Vector2(
   	 Input.get_action_strength("Right") - Input.get_action_strength("Left"),
   	 Input.get_action_strength("Down") - Input.get_action_strength("Up")
	)
	
	direction.normalized()
	if !ControlerAktive:
		world_contr_pos = world_pos
	world_contr_pos += direction *controllerSpeed
	tile_coords = self.local_to_map(world_contr_pos) 
	if direction != Vector2(0,0):
		ControlerAktive = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	


func _process(_delta) ->void:
	world_pos= get_global_mouse_position()
	var mousetile = self.local_to_map(world_pos) 
	if  lastHelpVisual[0] != mousetile && !ControlerAktive:
		tile_coords = mousetile
	elif lastHelpVisual[0].distance_to(mousetile) > 2:
		ControlerAktive = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#if tile == mousetile && !ControlerAktive:
	#	return
	if HouseRange !=  0:
		RemoveHelpRemoveLayer()
	for tile in lastHelpVisual:
		self.set_cell(tile,0)
		Helplayer2.set_cell(tile,0)
	for tile in lastHelpVisualController:
		Helplayer2.set_cell(tile,0)
		self.set_cell(tile,0)
	
	signalDictionary["CanBuild"] = true
	buildTiles.clear()
	signalDictionary["CurrentPosition"] = []
	for x in currentHousestats.size.x:
		for y in currentHousestats.size.y:
			var currenttileCoords:Vector2i = Vector2i(tile_coords.x+x,tile_coords.y+y)
			tile_data = tilemap.get_cell_tile_data(currenttileCoords)
			if tile_data == null ||  tree_tile_data.has(tile_data) :
				var tileInMap:Vector2i = Vector2i(x,y)
				Helplayer2.set_cell(currenttileCoords,currentHousestats.tileMapID[0],currentHousestats.tileMapPosition[0]+tileInMap)
				signalDictionary["CurrentPosition"].append(currenttileCoords) 
			else: 
				signalDictionary["CanBuild"] = false
			buildTiles.append(currenttileCoords)
			if !ControlerAktive:
				lastHelpVisual.append(currenttileCoords) 
			else:
				lastHelpVisualController.append(currenttileCoords)
	for tile in buildTiles:
		if signalDictionary["CanBuild"]:
			self.set_cell(tile,0, HelpVisual.get("True"))
			AddHelpLayer(curretnHouse,tile)
		else:
			self.set_cell(tile,0, HelpVisual.get("False"))
			Helplayer2.erase_cell(tile)
	emit_signal("CanBuildThere",signalDictionary)
	
	
func AddHelpLayer(House:Global.HouseID, currentPosition:Vector2i):
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
				var target_coords: Vector2i = currentPosition + Vector2i(x, y)
				var check_tile: TileData = tilemap.get_cell_tile_data(target_coords)
				match currentHousestats.usesType:
					Global.HouseType.Trees:
						if tree_tile_data.has(check_tile):
							addtileInRanges(target_coords)
					Global.HouseType.Houses:
						if house_tile_data.has(check_tile):
							addtileInRanges(target_coords)
		signalDictionary["RemovePositions"] = tileInRange


func addtileInRanges(currentPosition:Vector2i):
	if tileInRange.has(currentPosition):
		return
	self.set_cell(currentPosition,0,HelpVisual.get("True"))
	tileInRange.append(currentPosition) 

func RemoveHelpRemoveLayer():
	for n in tileInRange:
		self.set_cell(n,0)
	tileInRange.clear()
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
		AddHelpLayer(House,tile_coords)

func _on_node_2d_update_values():
	RemoveHelpRemoveLayer()
	signalDictionary["CanBuild"] = false
	emit_signal("CanBuildThere",signalDictionary)
	self.set_cell(tile_coords,0, HelpVisual.get("False"))
	
