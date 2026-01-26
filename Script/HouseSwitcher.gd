extends TileMapLayer

@onready var CostAmount: Array[int] = Global.BuildCostAmount


@onready var houseSelected:Array[Global.HouseID] = Global.HouseSelected
@onready var houseAmount:int = houseSelected.size()
@onready var Resouces: Array[Global.Points] = Global.BuildResources
var currentHouse:int
signal SwitchHouse(House)


func _input(event) -> void:
	if event.is_action_pressed("FirstHouse"):
		if houseAmount >= 1:
			currentHouse = 0
			if Global.currentResources[Resouces[currentHouse]] >=CostAmount[currentHouse]:
					emit_signal("SwitchHouse",currentHouse)
	if event.is_action_pressed("SecondHouse"):
		if houseAmount >= 2:
			currentHouse = 1
			if Global.currentResources[Resouces[currentHouse]] >=CostAmount[currentHouse]:
					emit_signal("SwitchHouse",currentHouse)
	if event.is_action_pressed("ThirdHouse"):
		if houseAmount >= 3:
			currentHouse = 2
			if Global.currentResources[Resouces[currentHouse]] >=CostAmount[currentHouse]:
					emit_signal("SwitchHouse",currentHouse)
	if event.is_action_pressed("FourthHouse"):
		if houseAmount >= 4:
			currentHouse = 3
			if Global.currentResources[Resouces[currentHouse]] >=CostAmount[currentHouse]:
					emit_signal("SwitchHouse",currentHouse)
func _on_node_2d_update_values():
	if Global.currentResources[Resouces[currentHouse]] < CostAmount[currentHouse]:
		for x in houseAmount:
			if Global.currentResources[Resouces[x]] >=CostAmount[x]:
				emit_signal("SwitchHouse",x)
	elif GlobalSettings.automaticSwitcher:
		for x in houseAmount:
			if Global.currentResources[Resouces[x]] >=CostAmount[x]:
				emit_signal("SwitchHouse",x)
			


func _on_control_2_selected_finished():
	Resouces = Global.BuildResources
	houseSelected= Global.HouseSelected
	houseAmount = houseSelected.size()
	CostAmount = Global.BuildCostAmount
	_on_node_2d_update_values()
