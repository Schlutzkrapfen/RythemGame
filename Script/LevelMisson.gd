extends VBoxContainer
@onready var levelRegister =  Global.level_registery[Global.currentLevel]
@onready var unlocksneeded = levelRegister.UnlocksNeeded
@onready var unlockIcons = levelRegister.UnlockIcon

var labels:Array[Label]
var Missions:PackedScene = preload("res://Scenes/mission.tscn")
signal missionsMade

func checkIfMissionFinished():
	var i:int = 0
	var checkifFinished = true
	for x in unlocksneeded:
		
		labels[i].text = str(unlocksneeded[x] - Global.currentResources[x])
		if Global.currentResources[x] < unlocksneeded[x]:
			checkifFinished = false
		i+= 1
		
		
	if checkifFinished:
		emit_signal("missionsMade")

func _ready():
	var i:int =0
	for x in unlocksneeded:
		var MissonNode:HBoxContainer = Missions.instantiate()
		labels.append(MissonNode.get_child(1))
		labels.back().text =  str(unlocksneeded[x])+ ":" 
		add_child(MissonNode)
		var icon:TextureRect = MissonNode.get_child(2)
		icon.texture =unlockIcons[i]
		i+=1
		


func _on_node_2d_update_values():
	checkIfMissionFinished()
