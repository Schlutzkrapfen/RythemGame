extends Node2D

# We need a reference to the TileMap node.
@export var tilemap: TileMapLayer
@export var Helplayer: TileMapLayer
@export var UnlockAnimations: Array[AnimationPlayer]
@export var SoundAnimations: AnimationPlayer
@export var UiLabels:Array[Label]
@export var Emmiters:Array[GPUParticles2D]
@export var EmmitersScene:PackedScene

signal Perfect
signal Good
signal Okay
signal EarlyFullMiss 

enum Points  {Miss,Early,Full,Okay,Good,Perfect,people,unemployed,wood,unusedWood,multiplaier}

enum ParticelsOrder {Miss,Early,Full,Okay,Good,Perfect,Confetti,BadEffect,GoodEffect}
var buildParticelList:Array[GPUParticles2D]
var source
var woodcuterRange:int = 3;
enum House { Normal = 0,Woodcutter= 1, Winhouse=2, Backery=3  }
var curretnHouse:House = House.Normal
var Houses:Dictionary = {"House":Vector2i(1,1),"WoodCutter":Vector2i(5,5),"Tree":Vector2i(11,6),"WinHouse":Vector2i(12,8)}
var HelpVisual:Dictionary = {"True":Vector2i(0,0),"False":Vector2i(1,0)}
var lastHelpVisual: Vector2i
var treesInRange: Array[Variant] = [Vector2i(0,0)]
#I havent found a better way but one tile is spawned and than seen if there is equal to other
var tree_tile_data:TileData
var world_pos: Vector2 
var tile_coords: Vector2i
var tile_data:TileData
var PeopleAmountForWoodcutter:int = 5
var WoodAnoumtForWinHouse:int = 5
var loop:int =1

var pointsDict: Dictionary[Points, int] = {
	Points.Miss: 0, 
	Points.Early: 0, 
	Points.Full: 0, 
	Points.Okay: 0, 
	Points.Good: 0, 
	Points.Perfect: 0, 
	Points.people: 0, 
	Points.unemployed: 0, 
	Points.wood: 0, 
	Points.unusedWood: 0, 
	Points.multiplaier: 0, 
}

var CurrentID:int 
var HitId:int
var CurrentHit:int

		
func RemoveHelpTrees():
	for n in treesInRange:
		Helplayer.set_cell(n,0)
	treesInRange.clear()

func AddHelpTrees():
	for x in range(-woodcuterRange, woodcuterRange + 1):
		for y in range(-woodcuterRange, woodcuterRange + 1):
			var offset: Vector2 = Vector2(x, y)
			if offset.length() <= woodcuterRange:
				var target_coords: Vector2i = tile_coords + Vector2i(x, y)
				var check_tile: TileData = tilemap.get_cell_tile_data(target_coords)
				if check_tile == tree_tile_data:
					Helplayer.set_cell(target_coords,0,HelpVisual.get("True"))
					treesInRange.append(target_coords) 

func _process(_delta) ->void:
	world_pos= get_global_mouse_position()
	tile_coords = tilemap.local_to_map(world_pos)
	if lastHelpVisual == tile_coords:
		return
	if curretnHouse == House.Woodcutter :
		RemoveHelpTrees()
	Helplayer.set_cell(lastHelpVisual,0)

	tile_data = tilemap.get_cell_tile_data(tile_coords)
	
	if tile_data == null || tile_data == tree_tile_data :
		Helplayer.set_cell(tile_coords,0, HelpVisual.get("True"))
		if curretnHouse == House.Woodcutter:
			AddHelpTrees()
	else: 
		Helplayer.set_cell(tile_coords,0, HelpVisual.get("False"))
	lastHelpVisual = tile_coords
	
func addWinHouse():
	tilemap.set_cell(tile_coords,0, Houses.get("WinHouse"))
	pointsDict[Points.multiplaier] += 1
	pointsDict[Points.unusedWood] -= WoodAnoumtForWinHouse
	
	UpdateResources()
	if pointsDict[Points.unusedWood] <WoodAnoumtForWinHouse:
		UnlockAnimations[1].play("LockWinhouse")
		curretnHouse = House.Normal
	
func addNormalHouse():
	tilemap.set_cell(tile_coords,0, Houses.get("House"))
	pointsDict[Points.people] +=1;
	pointsDict[Points.unemployed] +=1;
	UpdateResources()
	if pointsDict[Points.unemployed] >= PeopleAmountForWoodcutter:
		UnlockAnimations[0].play("UnlockWood")

func UpdateResources():
	UiLabels[0].text = str(pointsDict[Points.unemployed])
	UiLabels[1].text = str(pointsDict[Points.unusedWood])
	UiLabels[2].text = str(pointsDict[Points.multiplaier])

func addWoodCutter():
				for x in range(-woodcuterRange, woodcuterRange + 1):
					for y in range(-woodcuterRange, woodcuterRange + 1):
						var offset: Vector2 = Vector2(x, y)
						if offset.length() <= woodcuterRange:
							var target_coords: Vector2i = tile_coords + Vector2i(x, y)
							var check_tile: TileData = tilemap.get_cell_tile_data(target_coords)
							if check_tile == tree_tile_data:
								tilemap.set_cell(target_coords,0)
								pointsDict[Points.unusedWood] += 1
								pointsDict[Points.wood] +=1
							RemoveHelpTrees()
				pointsDict[Points.unemployed] -= PeopleAmountForWoodcutter
				
				
				tilemap.set_cell(tile_coords,0, Houses.get("WoodCutter"))
				if pointsDict[Points.unemployed] < PeopleAmountForWoodcutter:
					UnlockAnimations[0].play("LockWood")
					curretnHouse = House.Normal
				if pointsDict[Points.unusedWood] >=WoodAnoumtForWinHouse:
					UnlockAnimations[1].queue("UnlockWinHouse")
				UpdateResources()
				
func _input(event) -> void:
	# Check specifically for a left mouse button press
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if CurrentID == HitId:
			return
		if !SoundAnimations.is_playing():
			playEmitter(ParticelsOrder.Early)
			playEmitter(ParticelsOrder.BadEffect)
			HitId=CurrentID
			return
	
		
		print("\n--- Mouse Click Recorded ---")
		print("1. Raw World Position (Pixels): ", world_pos)
		print("2. Converted Grid Coordinates (Cell ID): ", tile_coords)
		print(tile_data)
		print(tree_tile_data)
		if tile_data == null || tile_data == tree_tile_data :
			if curretnHouse == House.Woodcutter:
				addWoodCutter()
			if curretnHouse == House.Normal:
				addNormalHouse()
			if curretnHouse == House.Winhouse:
				addWinHouse()
			tile_data = tilemap.get_cell_tile_data(tile_coords)
		else:
			print("there is already Something There")
			playEmitter(ParticelsOrder.Full)
			playEmitter(ParticelsOrder.BadEffect)
			emit_signal("EarlyFullMiss")
			HitId+=1
			return
		match(CurrentHit):
			0:
				playEmitter(ParticelsOrder.Perfect)
				playEmitter(ParticelsOrder.Confetti)
				emit_signal("Perfect")
			1:
				playEmitter(ParticelsOrder.Good)
				playEmitter(ParticelsOrder.GoodEffect)
				emit_signal("Good")
			2:
				playEmitter(ParticelsOrder.Okay)
				emit_signal("Good")
		spawnBuildEffects(world_pos)
		print(CurrentHit)
		CurrentHit = 0
		HitId= CurrentID


	if event.is_action_pressed("House"):
		RemoveHelpTrees()
		print("Switched to People")
		curretnHouse = House.Normal;
	if event.is_action_pressed("WoodCutter"):
		if pointsDict[Points.people] >= PeopleAmountForWoodcutter:
			AddHelpTrees()
			curretnHouse = House.Woodcutter;
			print("Switched to wood")
	if event.is_action_pressed("WinHouse"):
		if pointsDict[Points.unusedWood] >= WoodAnoumtForWinHouse:
			RemoveHelpTrees()
			curretnHouse = House.Winhouse;
			print("switched to Winhose")
func _ready():
	#PrintOutputTiles()
	tree_tile_data = tilemap.get_cell_tile_data(Vector2i(-10,0))


func _on_timer_timeout():
	#Global.pointsDict = pointsDict
	
	get_tree().change_scene_to_file("res://Level/win_screen.tscn")


func _on_midi_player_midi_event(channel, event:SMF.MIDIEvent):
	CurrentHit = 0
	if  CurrentID != HitId:
		playEmitter(ParticelsOrder.Miss)
		playEmitter(ParticelsOrder.BadEffect)
		emit_signal("EarlyFullMiss")
	#This code gets called 2 Times and I can't find a better way to fix it
	#to bad
	if loop %2 == 0:
		CurrentID +=1;
	loop += 1
	

func playEmitter(order:ParticelsOrder)-> void:
	Emmiters[order].restart()
	#Emmiters[order].get_parent().move_child(Emmiters[order],0)
	Emmiters[order].emitting

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
