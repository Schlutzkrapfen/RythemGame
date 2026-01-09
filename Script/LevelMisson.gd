extends VBoxContainer
@onready var levelRegister =  Global.level_registery[Global.currentLevel]
@onready var unlocksneeded = levelRegister.UnlocksNeeded
@onready var unlockIcons = levelRegister.UnlockIcon

var Missions:PackedScene = preload("res://Scenes/mission.tscn")
signal missionsMade

func checkIfMissionFinished():
	for x in unlocksneeded:
		if Global.currentResources[x] < unlocksneeded[x]:
			return
	emit_signal("missionsMade")
			

func _ready():
	var i:int =0
	for x in unlocksneeded:
		var MissonNode:HBoxContainer = Missions.instantiate()
		var label:Label = MissonNode.get_child(1)
		label.text =  str(unlocksneeded[x])+ ":" 
		add_child(MissonNode)
		var icon:TextureRect = MissonNode.get_child(2)
		icon.texture =unlockIcons[i]
		i+=1
		


func _on_node_2d_update_values():
	checkIfMissionFinished()
