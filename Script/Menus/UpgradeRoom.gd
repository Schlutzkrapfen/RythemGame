
extends Control

@export var canvasLayer:CanvasLayer
var maxSameHouses:int = 4
#Checks for if all the unlocks are requiered
var unlocksTake: Array[bool] = []
var unlocksCount = Global.level_registery[Global.currentLevel].UnlocksNeeded.size()

signal SelectedFinished

func _ready():
	if Global.HouseUnlocked.size() <= maxSameHouses:
		canvasLayer.visible = false
		emit_signal("SelectedFinished")
		return
	get_tree().paused = true
	unlocksTake.resize(unlocksCount)
	unlocksTake.fill(false)

##TODO:NEEDS MORE PLAYER FEEDBACK
func _on_button_button_up():
	#checks if any house is selecetde
	var notselected:int = 0
	#Looks if there is any building that needs no Resources to start
	var starteible:int = 0
	var currentHouses = Global.HouseSelected
	var unlockArray:Array[Global.HouseID] =  Global.level_registery[Global.currentLevel].UnlocksNeeded.keys()
	var alreadyUnlocked:Array[Global.HouseID] = []
	for i in currentHouses:
		if i == Global.HouseID.NONE:
			notselected += 1
			continue
		if Global.house_registry[i].buildCost == 0:
			starteible +=1
		for unlocks in unlocksCount:
			var breaks = false
			for alreadys in alreadyUnlocked:
				if alreadys == unlockArray[unlocks]:
					breaks = true
			print(breaks)
			if breaks:
				break
			if Global.pointsConnectDict.has(Global.house_registry[i].unitType):
				if unlockArray[unlocks] == Global.pointsConnectDict[Global.house_registry[i].unitType]:
					unlocksTake[unlocks] = true
					alreadyUnlocked.append(Global.house_registry[i].unitType)
			else:
				if Global.level_registery[Global.currentLevel].UnlocksNeeded.has(Global.house_registry[i].unitType):
					unlocksTake[unlocks] = true
					alreadyUnlocked.append(Global.house_registry[i].unitType)
	if notselected == maxSameHouses || Global.HouseSelected.size() == 0 || starteible == 0:
		return
	for i in unlocksTake:
		if i == false:
			return
	#Deletes the nulls out of the Array that no nullrefrences can be made
	#Next round the houses can be orded diffently which could be a frustation.
	#TObad
	for i in notselected:
		Global.HouseSelected.erase(Global.HouseID.NONE)
	canvasLayer.visible = false
	get_tree().paused = false
	Global.ResetLevel()
	emit_signal("SelectedFinished")
