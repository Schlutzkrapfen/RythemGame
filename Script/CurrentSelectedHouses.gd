extends HBoxContainer

var houseIcons:Array[TextureRect]
var currentHouseStats = []

var goodLabelIcons:Array[TextureRect]
var badLabelIcons:Array[TextureRect]
var goodLabel:Array[Label]
var badLabel:Array[Label]
var VisualSpacer:Array[ColorRect]

@export var buttonsArray:Array[Button]
@export var SpaceArray:Array[Node]

@onready var CurrentSelectedHouses:Array[Global.HouseID] = Global.HouseSelected

#Load the current Houses to the buttons
func _ready():
	for i in CurrentSelectedHouses.size():
		buttonsArray[i].visible = true
		SpaceArray[i].visible = true
		houseIcons.append(buttonsArray[i].get_node("./VBoxContainer/TextureRect"))
		currentHouseStats.append(Global.house_registry[CurrentSelectedHouses[i]])
		houseIcons[i].texture =currentHouseStats[i].buttonIconHD
		#ShowGoodThings
		goodLabelIcons.append(buttonsArray[i].get_node("./VBoxContainer/HBoxContainer/GoodPoints/TextureRect2"))
		goodLabel.append(buttonsArray[i].get_node("./VBoxContainer/HBoxContainer/GoodPoints/Label"))
		goodLabelIcons[i].visible = true
		goodLabelIcons[i].texture = Global.labelRegistry[currentHouseStats[i].unitType].labelIcon
		goodLabel[i].visible = true
		if currentHouseStats[i].houseRange == 0:
			goodLabel[i].text = str(currentHouseStats[i].points)
		else:
			goodLabel[i].text = "X*" +str(currentHouseStats[i].points)
		#ShowBadThings(if there are any)
		VisualSpacer.append(buttonsArray[i].get_node("./VBoxContainer/HBoxContainer/ColorRect"))
		badLabelIcons.append(buttonsArray[i].get_node("./VBoxContainer/HBoxContainer/BadPoints/TextureRect3"))
		badLabel.append(buttonsArray[i].get_node("./VBoxContainer/HBoxContainer/BadPoints/Label2"))
		if currentHouseStats[i].buildCost == 0:
			continue
		VisualSpacer[i].visible = true
		badLabelIcons[i].visible = true
		badLabelIcons[i].texture = Global.labelRegistry[currentHouseStats[i].buildType].labelIcon
		badLabel[i].visible = true
		badLabel[i].text = str(currentHouseStats[i].buildCost)
	
func ButtonPressed(id: int):
	print(id)
