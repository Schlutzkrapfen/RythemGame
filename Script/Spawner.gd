extends Node2D

# We need a reference to the TileMap node.
@export var tilemap: TileMapLayer
@export var UnlockAnimations: Array[AnimationPlayer]
@export var SoundAnimations: AnimationPlayer
@export var UiLabels:Array[Label]

@export var EmmitersScene:PackedScene

signal Perfect
signal Good
signal Okay
signal EarlyFullMiss 
signal Early
signal Full
signal Miss

signal SwitchHouse(House)


var buildParticelList:Array[GPUParticles2D]
var source
var HouseTileSetID:int = 4;

var Trees:Array = [];
var ChangeHouses:Array[Vector2i]
var CanBuild:bool;

enum House { Normal = 0,Woodcutter= 1, Winhouse=2, Backery=3  }
var curretnHouse:House = House.Normal




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
	Global.Points.unemployed: 0, 
	Global.Points.wood: 0, 
	Global.Points.unusedWood: 0, 
	Global.Points.multiplaier: 1, 
}

var CurrentID:int 
var HitId:int
var CurrentHit:int

	
func addWinHouse():
	tilemap.set_cell(tile_coords,0, Global.Houses.get("WinHouse"))
	pointsDict[Global.Points.multiplaier] += 1
	pointsDict[Global.Points.unusedWood] -= WoodAnoumtForWinHouse
	
	UpdateResources()
	if pointsDict[Global.Points.unusedWood] <WoodAnoumtForWinHouse:
		UnlockAnimations[1].play("LockWinhouse")
		curretnHouse = House.Normal
	
func addNormalHouse():
	tilemap.set_cell(tile_coords,HouseTileSetID, Global.Houses.get("House"))
	pointsDict[Global.Points.people] +=1;
	pointsDict[Global.Points.unemployed] +=1;
	UpdateResources()
	if pointsDict[Global.Points.unemployed] >= PeopleAmountForWoodcutter:
		UnlockAnimations[0].play("UnlockWood")

func UpdateResources():
	UiLabels[0].text = str(pointsDict[Global.Points.unemployed])
	UiLabels[1].text = str(pointsDict[Global.Points.unusedWood])
	UiLabels[2].text = str(pointsDict[Global.Points.multiplaier])

func RemoveTrees():
	for x in Trees:
		tilemap.set_cell(x,0)
		pointsDict[Global.Points.unusedWood] += 1
		pointsDict[Global.Points.wood] +=1

func addWoodCutter():
	RemoveTrees()
	pointsDict[Global.Points.unemployed] -= PeopleAmountForWoodcutter
	if !ChangeHouses.is_empty():
		pass
	#if tilemap.get_cell_tile_data(Vector2i(tile_coords.x+1,tile_coords.y))== house_tile_data:
	#	tilemap.set_cell(Vector2i(tile_coords.x+1,tile_coords.y),HouseTileSetID, Houses.get("WoodCutterHR"))
	#	tilemap.set_cell(tile_coords,4, Houses.get("WoodCutterWR"))
	#elif tilemap.get_cell_tile_data(Vector2i(tile_coords.x-1,tile_coords.y))== house_tile_data:
	#	tilemap.set_cell(Vector2i(tile_coords.x-1,tile_coords.y),HouseTileSetID, Houses.get("WoodCutterHL"))
	#	tilemap.set_cell(tile_coords,HouseTileSetID, Houses.get("WoodCutterWL"))
	else:
		tilemap.set_cell(tile_coords,HouseTileSetID, Global.Houses.get("WoodCutter"))
	if pointsDict[Global.Points.unemployed] < PeopleAmountForWoodcutter:
		UnlockAnimations[0].play("LockWood")
		curretnHouse = House.Normal
		emit_signal("SwitchHouse",House.Normal)
	if pointsDict[Global.Points.unusedWood] >=WoodAnoumtForWinHouse:
		UnlockAnimations[1].queue("UnlockWinHouse")
	UpdateResources()

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
			if curretnHouse == House.Woodcutter:
				addWoodCutter()
			elif curretnHouse == House.Normal:
				addNormalHouse()
			elif curretnHouse == House.Winhouse:
				addWinHouse()
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
		#spawnBuildEffects(world_pos)
		print(CurrentHit)
		CurrentHit = 0
		HitId= CurrentID
	if event.is_action_pressed("House"):
		curretnHouse = House.Normal;
		emit_signal("SwitchHouse",House.Normal)
	if event.is_action_pressed("WoodCutter"):
		if pointsDict[Global.Points.people] >= PeopleAmountForWoodcutter:
			curretnHouse = House.Woodcutter;
			emit_signal("SwitchHouse",House.Woodcutter)
	if event.is_action_pressed("WinHouse"):
		if pointsDict[Global.Points.unusedWood] >= WoodAnoumtForWinHouse:
			curretnHouse = House.Winhouse;
			emit_signal("SwitchHouse",House.Winhouse)


func _on_midi_player_midi_event(channel, event:SMF.MIDIEvent):
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
	



func spawnBuildEffects(position:Vector2)->void:
	for e in buildParticelList:
		if e.finished:
			e.position = position
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
	Trees = signalDictionary.get("RemovePositions", [])
	
	print(tile_coords)
