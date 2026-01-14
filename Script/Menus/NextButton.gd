extends Button

@export var timeTillButtonAppears:float = 2

func _ready():
	self.visible = false
	var unlockedHouse = Global.level_registery[Global.currentLevel].PossibleHouseUnlocks
	if Global.HouseSelected.size() < 4:
		Global.HouseSelected.append(unlockedHouse)
	Global.HouseUnlocked.append(unlockedHouse)
	await get_tree().create_timer(timeTillButtonAppears).timeout
	self.visible = true
		
func _on_button_up():
		
	get_tree().change_scene_to_file("res://Scenes/EquipRoom.tscn")
	
