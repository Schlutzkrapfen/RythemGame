extends Node2D

# We need a reference to the TileMap node.
@export var tilemap: TileMapLayer
@export var UnlockAnimations: Array[AnimationPlayer]
@export var SoundAnimations: AnimationPlayer
@export var EmmitersScene:PackedScene


signal Perfect
signal Good
signal Okay
signal EarlyFullMiss 
signal Early
signal Full
signal Miss
signal UpdateValues


var buildParticelList:Array[GPUParticles2D]
var source
var HouseTileSetID:int = 0;

var RemoveArray:Array = [];
var ChangeHouses:Array[Vector2i]
var CanBuild:bool;

var currentStats 

var tile_coords: Vector2i

var PeopleAmountForWoodcutter:int = 5
var WoodAnoumtForWinHouse:int = 5
var loop:int =1

var pointsDict: Dictionary[Global.Points, int] = {
	Global.Points.Miss: 0, 
	Global.Points.Early: 0, 
	Global.Points.Full: 0, 
	Global.Points.Okay: 0, 
	Global.Points.Good: 0, 
	Global.Points.Perfect: 0, 
	Global.Points.people: 0, 
	Global.Points.wood: 0, 
	Global.Points.multiplaier: 1, 
}


var CurrentID:int 
var HitId:int
var CurrentHit:int

func _ready():
	currentStats = Global.house_registry.get(Global.HouseSelected[0])

func addHouse():
	tilemap.set_cell(tile_coords,currentStats.TileMapID,currentStats.TileMapPosition)
	pointsDict[currentStats.unitType] += currentStats.points
	Global.currentResources[Global.pointsConnectDict[currentStats.buildType[0]]] -= currentStats.buildCost[0]
	if Global.pointsConnectDict.has(currentStats.unitType):
		Global.currentResources[Global.pointsConnectDict[currentStats.unitType]] += currentStats.points
	Removelayer()
	emit_signal("UpdateValues")

func Removelayer():
	for x in RemoveArray:
		tilemap.set_cell(x,0)
		pointsDict[currentStats.unitType] += currentStats.points
		if Global.pointsConnectDict.has(currentStats.unitType):
			Global.currentResources[Global.pointsConnectDict[currentStats.unitType]] += currentStats.points

func _input(event) -> void:
	# Check specifically for a left mouse button press
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed || event.is_action_pressed("Controller_Input"):
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
			0:
				emit_signal("Perfect")
				pointsDict[Global.Points.Perfect] +=1
			1:
				emit_signal("Good")
				pointsDict[Global.Points.Good] +=1
			2:
				emit_signal("Okay")
				pointsDict[Global.Points.Okay] +=1
		CurrentHit = 0
		HitId= CurrentID
	
func _on_midi_player_midi_event(_channel, _event:SMF.MIDIEvent):
	CurrentHit = 0
	if  CurrentID != HitId:
		if loop %2 == 0:
			emit_signal("Miss")
			emit_signal("EarlyFullMiss")
			pointsDict[Global.Points.Miss] +=1
	#This code gets called 2 Times and I can't find a better way to fix it
	#to bad
	if loop %2 == 0:
		CurrentID +=1;
	loop += 1
	
func spawnBuildEffects(point:Vector2)->void:
	for e in buildParticelList:
		if e.finished:
			e.position = point
			e.restart()
			e.emitting = true
			return
	var Emmiter =EmmitersScene.instantiate()
	buildParticelList.append(Emmiter)
	add_child(Emmiter)
	buildParticelList.back().position = position
	buildParticelList.back().emitting = true

func addOneToCurrentHit():
	CurrentHit +=1;

func _on_timer_timeout():
	Global.pointsDict = pointsDict

func _on_help_layer_can_build_there(signalDictionary):
	CanBuild = signalDictionary.get("CanBuild", false)
	tile_coords = signalDictionary.get("CurrentPosition", Vector2i(0,0))
	RemoveArray = signalDictionary.get("RemovePositions", [])
	
func _on_backgorund_switch_house(House):
	currentStats =  Global.house_registry.get(House)
	
