extends TileMapLayer

#Switches the houses with input
@onready var CostAmount: Array[int] = Global.BuildCostAmount


@onready var houseSelected:Array[Global.HouseID] = Global.HouseSelected
@onready var houseAmount:int = houseSelected.size()
@onready var Resouces: Array[Global.Points] = Global.BuildResources
var currentHouse:int
##Gives the housenummer that is selected currently(need to do global.Houseselected to get the right one)
signal SwitchHouse(House)



func _ready():
	SwitchHouseWithPossible()
#Checks if the button is pressed to switch and if its possible
func _input(event) -> void:
	if event.is_action_pressed("FirstHouse"):
		if houseAmount >= 1:
			currentHouse = 0
			if Global.currentResources[Resouces[currentHouse]] >=CostAmount[currentHouse]:
					emit_signal("SwitchHouse",currentHouse)
					Global.currentHouse = currentHouse
	if event.is_action_pressed("SecondHouse"):
		if houseAmount >= 2:
			currentHouse = 1
			if Global.currentResources[Resouces[currentHouse]] >=CostAmount[currentHouse]:
					emit_signal("SwitchHouse",currentHouse)
					Global.currentHouse = currentHouse
	if event.is_action_pressed("ThirdHouse"):
		if houseAmount >= 3:
			currentHouse = 2
			if Global.currentResources[Resouces[currentHouse]] >=CostAmount[currentHouse]:
					emit_signal("SwitchHouse",currentHouse)
					Global.currentHouse = currentHouse
	if event.is_action_pressed("FourthHouse"):
		if houseAmount >= 4:
			currentHouse = 3
			if Global.currentResources[Resouces[currentHouse]] >=CostAmount[currentHouse]:
					emit_signal("SwitchHouse",currentHouse)
					Global.currentHouse = currentHouse
	
func _on_node_2d_update_values():
	if Global.CheckIfHouseEnoughResources() && GlobalSettings.autoSwitchOnDepletion || GlobalSettings.automaticSwitcher: 
		SwitchHouseWithPossible()
		

func SwitchHouseWithPossible():
		for x in houseAmount:
			if Global.currentResources[Resouces[x]] >=CostAmount[x]:
				emit_signal("SwitchHouse",x)
				Global.currentHouse =x



func _on_control_2_selected_finished():
	Resouces = Global.BuildResources
	houseSelected= Global.HouseSelected
	houseAmount = houseSelected.size()
	CostAmount = Global.BuildCostAmount
	_on_node_2d_update_values()
