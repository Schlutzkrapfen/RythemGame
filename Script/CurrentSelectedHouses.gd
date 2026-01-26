extends HBoxContainer

var houseIcons:Array[TextureRect]



var currentused:Array[bool] = [false,false,false,false]
var oldButtonPosition:Array[Vector2] = [Vector2(),Vector2(),Vector2(),Vector2()]
var oldButtonSize:Array[Vector2] = [Vector2(),Vector2(),Vector2(),Vector2()]
@onready var fakeButton:Array[Button] = [Button.new(),Button.new(),Button.new(),Button.new()]

@export var buttonsArray:Array[Button]
@export var SpaceArray:Array[Node]
@export var animationtime:float = 0.2
var loop = 0
@onready var currentHouses:Array[Global.HouseID] = Global.HouseSelected

@onready var currentHouseStats:Array
#Load the current Houses to the buttons
func fillcurrentHousestats():
	currentHouseStats.clear()
	for houses in currentHouses:
		if houses == Global.HouseID.NONE:
			currentHouseStats.append(Global.house_registry[Global.HouseID.Default])
			return
		currentHouseStats.append(Global.house_registry[houses])

		#setHouses(i)
	

func setHouses(id:int):
	houseIcons[id].texture =currentHouseStats[id].buttonIconHD
	currentHouseStats.append(Global.house_registry[currentHouses[id]])
	if currentHouseStats[id].buildCost == 0:
		return
	
func ResetButton(id:int):
	currentused[id] = false
	var tween:Tween = get_tree().create_tween()
	var tween1:Tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween1.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(fakeButton[id], "position",oldButtonPosition[id], animationtime).set_trans(Tween.TRANS_SINE)
	tween1.tween_property(fakeButton[id], "size",oldButtonSize[id], animationtime).set_trans(Tween.TRANS_SINE)
	
		
	
func ButtonPressed(id: int):
	if !currentused[id]:
		return
	ResetButton(id)
	Global.HouseSelected[id] = Global.HouseID.NONE
#Showes Feedback for buttons or other things that are missing
func ShowError(id:int):
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(buttonsArray[id], "position", Vector2(), 1)
	tween.tween_property(houseIcons[id], "modulate", Color.RED, 1)
	tween.tween_callback(houseIcons[id].queue_free)
	
	

func _on_spawn_selecthouses_button_press(house,button):
	#Checks if House is already here 
	for i in currentHouses.size():
		if house == currentHouses[i]:
			return
	for i in currentused.size():
		if currentused[i]:
			continue
		currentused[i] = true
		if currentHouses.size() > i:
			Global.HouseSelected[i] = house
			currentHouses[i] = house
		else:
			Global.HouseSelected.append(house)
		oldButtonPosition[i] = button.position
		oldButtonSize[i] = button.size
		fakeButton[i] = button
		fillcurrentHousestats()
		var tween:Tween = get_tree().create_tween()
		var tween1:Tween = get_tree().create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween1.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(button, "position",buttonsArray[i].get_global_rect().position, animationtime).set_trans(Tween.TRANS_SINE)
		tween1.tween_property(button, "size",buttonsArray[i].size, animationtime)
		
		return


func _on_spawn_selecthouses_move_button_imidiatly(FakeButton):
	currentused[loop] = true
	buttonsArray[loop].visible = true
	SpaceArray[loop].visible = true
	fillcurrentHousestats()
	oldButtonPosition[loop] = FakeButton.position
	oldButtonSize[loop] = FakeButton.size
	fakeButton[loop] = FakeButton
	FakeButton.size = buttonsArray[loop].size
	FakeButton.position = buttonsArray[loop].get_global_rect().position
	loop += 1
