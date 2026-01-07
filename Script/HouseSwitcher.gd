extends TileMapLayer

@onready var CostAmount: Array[int] = Global.BuildCostAmount


@onready var houseSelected:Array[Global.HouseID] = Global.HouseSelected
@onready var houseAmount:int = houseSelected.size()
@onready var  Resouces: Array[Global.Points] = Global.BuildResources

signal SwitchHouse(House)
	


func _input(event) -> void:
	if event.is_action_pressed("FirstHouse"):
		if houseAmount >= 1:
			if Global.currentResources[Resouces[0]] >=CostAmount[0]:
					emit_signal("SwitchHouse",houseSelected[0])
	if event.is_action_pressed("SecondHouse"):
		if houseAmount >= 2:
			
			if Global.currentResources[Resouces[1]] >=CostAmount[1]:
					emit_signal("SwitchHouse",houseSelected[1])
	if event.is_action_pressed("ThirdHouse"):
		if houseAmount >= 3:
			if Global.currentResources[Resouces[2]] >=CostAmount[2]:
					emit_signal("SwitchHouse",houseSelected[2])
	if event.is_action_pressed("FourthHouse"):
		if houseAmount >= 4:
			if Global.currentResources[Resouces[3]] >=CostAmount[4]:
					emit_signal("SwitchHouse",houseSelected[4])
