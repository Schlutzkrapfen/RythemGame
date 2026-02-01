extends Node2D
#Spawns the Houses

@export var tilemap: TileMapLayer
@export var UnlockAnimations: Array[AnimationPlayer]
@export var SoundAnimations: AnimationPlayer
@export var EmmitersScene:PackedScene
var Clicked:bool

signal Perfect
signal Good
signal Okay
signal EarlyFullMiss 
signal Early
signal Full
signal Miss

signal UpdateValues()
signal ChangedHouseAtPosition(Type:Global.HouseID,Vector2i,Vector2)
var buildParticelList:Array[GPUParticles2D]
var source
var HouseTileSetID:int = 0;

var RemoveArray:Array = [];
var ChangeHouses:Array[Vector2i]
var CanBuild:bool;

var currentStats 
var currentHouse:Global.HouseID

var tile_coords:Array

var PeopleAmountForWoodcutter:int = 5
var WoodAnoumtForWinHouse:int = 5
var loop:int =1
var TimesinstLastInput:float

var pointsDict: Dictionary[Global.Points, float] = {
	Global.Points.Miss: 0, 
	Global.Points.Early: 0, 
	Global.Points.Full: 0, 
	Global.Points.Okay: 0, 
	Global.Points.Good: 0, 
	Global.Points.Perfect: 0, 
	Global.Points.people: 0, 
	Global.Points.wood: 0, 
	Global.Points.time: 0, 
	Global.Points.multiplaier: 1, 
}

var CurrentID:int 
var HitId:int
var CurrentHit:int
#Sets the currenstats of the hosue 
func getStartingStat():
	#currentStats = Global.house_registry.get(Global.HouseSelected[0])
	pass
func _ready():
	getStartingStat()

#Adds the house to the Tileset
func addHouse():
	if currentStats.houseRange == 0:
		addPoints()
	else:
		changeLayer()
	for x in currentStats.size.x:
		for y in currentStats.size.y:
			var tile = Vector2i(tile_coords[0].x+x,tile_coords[0].y+y)
			var currentShowTile = Vector2i(currentStats.tileMapPosition[0].x+x,currentStats.tileMapPosition[0].y+y)
			tilemap.set_cell(tile,currentStats.tileMapID[0],currentShowTile)
			var globalTilePosition = tilemap.to_global(tilemap.map_to_local(tile))
			emit_signal("ChangedHouseAtPosition",currentHouse,tile,globalTilePosition)
	Global.currentResources[Global.pointsConnectDict[currentStats.buildType]] -= currentStats.buildCost
	emit_signal("UpdateValues")

#adds the point to currentPoints and to the Points that get later converted in
#Global points
func addPoints():
	if Global.pointsConnectDict.has(currentStats.unitType):
		Global.currentResources[Global.pointsConnectDict[currentStats.unitType]] += currentStats.points
	else:
		Global.currentResources[currentStats.unitType] += currentStats.points
	pointsDict[currentStats.unitType] += currentStats.points
	
#adds the Points for the building that are in Range and Destroyes them if the 
#builing should do so
func changeLayer():
	for x in RemoveArray:
		if currentStats.destroyes:
			tilemap.set_cell(x,0)
		addPoints()
#Check if the house is Placed and how good is clicked
func _input(event) -> void:
	if  event.is_action_pressed("Controller_Input"):
		if CurrentID == HitId:
			return
		if !SoundAnimations.is_playing():
			emit_signal("EarlyFullMiss")
			emit_signal("Early")
			pointsDict[Global.Points.Early] +=1
			HitId=CurrentID
			return
		if CanBuild :
			addHouse()
		else:
			emit_signal("EarlyFullMiss")
			emit_signal("Full")
			pointsDict[Global.Points.Full] +=1
			HitId+=1
			return
		match(CurrentHit):
			0 , 4:
				emit_signal("Okay")
				pointsDict[Global.Points.Okay] +=1
			1 , 3:
				emit_signal("Good")
				pointsDict[Global.Points.Good] +=1
			2:
				emit_signal("Perfect")
				pointsDict[Global.Points.Perfect] +=1
		CurrentHit = 0
		HitId= CurrentID
#Add the AnimationPlayer the function gets called and is used to check how close the call is
func addOneToCurrentHit():
	CurrentHit +=1;

#Gets all the Info for building from a Second Script
func _on_help_layer_can_build_there(signalDictionary):
	CanBuild = signalDictionary.get("CanBuild", false)
	tile_coords = signalDictionary.get("CurrentPosition", [])
	RemoveArray = signalDictionary.get("RemovePositions", [])
	
#Switches Houses
func _on_backgorund_switch_house(House):
	currentHouse = Global.HouseSelected[House]
	currentStats = Global.house_registry.get(currentHouse)
#Here Gets checked if Someone misses to click
func _on_rhythm_notifier_beat(_current_beat):
	CurrentHit = 0
	if  CurrentID != HitId:
		emit_signal("Miss")
		emit_signal("EarlyFullMiss")
		pointsDict[Global.Points.Miss] +=1
	CurrentID +=1;

#loads the points in the Globaldict
func _on_level_switcher_finished():
	Global.pointsDict = pointsDict
