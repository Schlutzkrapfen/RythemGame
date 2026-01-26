extends GridContainer

@onready var packedButtonScene:PackedScene = preload("res://Scenes/SelecetHouse.tscn")
@onready var packedFakeButtonScene:PackedScene = preload("res://Scenes/FakeButton.tscn")

var houseIcons:Array[TextureRect]
var badIcon:Array[TextureRect]
var goodIcon:Array[TextureRect]
var goodLabel:Array[Label]
var badLabel:Array[Label]
var spacer:Array[ColorRect]
var buttons:Array[Button]
var fakeButtons:Array[Button]
signal buttonPress(house: Global.HouseID,FakeButton:Button) 
signal moveButtonImidiatly(FakeButton:Button)


@export var overlaySpanwer:Control
#should be possible to divided true the amount of colums(At the moment 8) 
@export var maxButtons: int = 24
func _ready():
	
	for i in maxButtons:
		var button:Button = packedButtonScene.instantiate()
		button.button_up.connect(buttonPressed.bind(i))
		buttons.append(button)
		add_child(button)
	await get_tree().process_frame
	addFakeButton()

func addFakeButton():
	for button in buttons:
		var fakebutton:Button = packedFakeButtonScene.instantiate()
		houseIcons.append(fakebutton.get_node("./VBoxContainer/TextureRect"))
		goodIcon.append(fakebutton.get_node("./VBoxContainer/HBoxContainer/GoodPoints/TextureRect2"))
		goodLabel.append(fakebutton.get_node("./VBoxContainer/HBoxContainer/GoodPoints/Label"))
		
		badLabel.append(fakebutton.get_node("./VBoxContainer/HBoxContainer/BadPoints/Label2"))
		badIcon.append(fakebutton.get_node("./VBoxContainer/HBoxContainer/BadPoints/TextureRect3"))
		
		spacer.append(fakebutton.get_node("./VBoxContainer/HBoxContainer/ColorRect"))
		fakebutton.size = button.size
		fakebutton.position = button.get_global_rect().position
		fakeButtons.append(fakebutton)
		overlaySpanwer.add_child(fakebutton)
	for i in Global.HouseUnlocked.size():
		if i == 0:
			buttons[i].grab_focus()
		for house in Global.HouseSelected:
			if Global.HouseUnlocked[i] == house:
				emit_signal("moveButtonImidiatly",fakeButtons[i])
				break
		var currentstats = Global.house_registry[Global.HouseUnlocked[i]]
		houseIcons[i].texture = currentstats.buttonIconHD
		if currentstats.points != 0:
			goodStatsVisible(i)
			var goodstat =  Global.labelRegistry[currentstats.unitType]
			goodIcon[i].texture =goodstat.labelIcon 
			#TODO:CHANGE the X to a Picture
			var points = currentstats.points
			if !goodstat.needsFloat:
				points = int(currentstats.points)
			if currentstats.houseRange == 0:
				goodLabel[i].text =str(points)
			else:
				goodLabel[i].text = "X*"+str(points)
			if currentstats.buildCost == 0:
				continue
			spacer[i].visible = true
		if currentstats.buildCost != 0:
			badStatsVisible(i)
			var badstat = Global.labelRegistry[currentstats.buildType]
			badIcon[i].texture = badstat.labelIcon
		
		
		
func badStatsVisible(id:int):
	badIcon[id].get_parent().visible = true
func goodStatsVisible(id:int):
	goodIcon[id].get_parent().visible = true
	
func buttonPressed(id:int):
	if Global.HouseUnlocked.size() > id:
		emit_signal("buttonPress",Global.HouseUnlocked[id],fakeButtons[id])
	pass
