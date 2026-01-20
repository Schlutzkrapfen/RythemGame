extends Control
#starting for when the ohter part the auflisting is finished
var starting:bool = false
var soundgoAgain:bool = false
var currentPoints:float = 0
var currentPointsSum:float = 0
var i:int =0  
var hue:float = 0
#MultiplayerAddedIstheLastStep
var MultiplayerAdded:bool
var Switching:bool =false
var RainbowTime:bool = false
signal Kachinging
signal startCountUp
signal stopCountUp
signal finished

@onready var pointsLabel:Label = $Points
@onready var labelRegistry = Global.labelRegistry
@onready var pointsDict: Dictionary[Global.Points, float] = Global.pointsDict

@export var ButtonNode:Control
@export var pointsAddingSpeed:float = 10
@export var waitTillSwitch:float = 0.5
@export var waitTillKatching:float = 0.5
@export var waitTillButtonShown:float = 0.5
@export var ParticelEmmiters:Array[GPUParticles2D]

func _process(delta):
	if !starting:
		return
	if Global.currentLevelStatus == Global.LevelStatus.Lost ||  Global.currentLevelStatus == Global.LevelStatus.LostTime:
		skip()
		return
	if MultiplayerAdded:
		return
	if RainbowTime:
		hue += delta * 0.4
		if hue > 1:
			hue = 0
		ParticelEmmiters[0].modulate = Color.from_hsv(hue, 1.0, 1.0)
	if labelRegistry[i].Multiplayer >= 0:
		if Switching:
			ParticelEmmiters[0].emitting =false
			emit_signal("stopCountUp")
			pointsLabel.text = str(roundf(currentPoints))
			await get_tree().create_timer(waitTillSwitch).timeout
			Switching =false
			if !soundgoAgain:
				soundgoAgain = true
				emit_signal("startCountUp")
				ParticelEmmiters[0].emitting =true
			return
		if currentPointsSum+ (pointsDict[labelRegistry[i].stat] * labelRegistry[i].Multiplayer) >= currentPoints:
			currentPoints += delta * pointsAddingSpeed
			pointsLabel.text = str(snapped(currentPoints,0.01))
		else:
			currentPointsSum += pointsDict[labelRegistry[i].stat]* labelRegistry[i].Multiplayer
			i = findNextpoint()
			if  i == Global.Points.multiplaier:
				addMultiplayer()
				return
			ChangeParticelEmmiter()
	else:
		Switching =true
		if currentPointsSum+ (pointsDict[labelRegistry[i].stat] * labelRegistry[i].Multiplayer) <= currentPoints:
			currentPoints -= delta * pointsAddingSpeed
			pointsLabel.text = str(snapped(currentPoints,0.01))
		else:
			currentPointsSum += pointsDict[labelRegistry[i].stat]* labelRegistry[i].Multiplayer
			i=findNextpoint()
			ChangeParticelEmmiter()
			

func ChangeParticelEmmiter():
	ParticelEmmiters[0].position = pointsLabel.size /2 
	ParticelEmmiters[0].texture = labelRegistry[i].labelIcon
	ParticelEmmiters[0].modulate = labelRegistry[i].color
	RainbowTime = labelRegistry[i].Rainbow
#Could Also be called last step in Pointsadding
func addMultiplayer():
	MultiplayerAdded = true
	pointsLabel.text = str(roundf(currentPoints))
	ParticelEmmiters[0].emitting = false
	emit_signal("stopCountUp")
	await get_tree().create_timer(waitTillKatching).timeout
	ParticelEmmiters[1].position = pointsLabel.size /2 
	ParticelEmmiters[1].emitting = true
	emit_signal("Kachinging")
	currentPoints *= pointsDict[Global.Points.multiplaier]
	Global.endPoints = int(currentPoints)
	pointsLabel.text = str(roundf(currentPoints))
	await get_tree().create_timer(waitTillButtonShown).timeout
	ButtonNode.visible = true
	emit_signal("finished")

func skip():
	currentPoints = 0
	for x in labelRegistry:
		currentPoints += pointsDict[labelRegistry[x].stat] * labelRegistry[x].Multiplayer
	if !MultiplayerAdded:
		addMultiplayer()

func _input(event):
	if event is InputEventKey && event.is_pressed() && starting || event is InputEventJoypadButton && event.is_pressed() && starting:
		skip()

func findNextpoint()-> int:
	var next:bool =false
	for x in labelRegistry:
		if next:
			return x
		if i == x:
			next = true
	return 0

func startPoints():
	self.visible = true
	starting = true
	ParticelEmmiters[0].emitting = true
	emit_signal("startCountUp") 
	ChangeParticelEmmiter()
	


func _on_win_point_spawner_finished():
	startPoints()
	
