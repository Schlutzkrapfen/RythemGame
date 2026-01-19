extends VBoxContainer
@export var timeDelaySinceNext:float = 0.5
@export var spawnPoint:int = 4
@export var ParticelTimeOffset:int = 20

@onready var pointsDict: Dictionary[Global.Points, int] = Global.pointsDict
@onready var labelRegistry = Global.labelRegistry


var RainbowColorNodes:Array[Control]
var PointLabels:Array[Label]
var PointsDisplayer:PackedScene = preload("res://Scenes/winscreenpoints.tscn")
var skip:bool =false


signal goodSound(Volume:float)
signal badSound(Volume:float)
signal finished
signal shakeCamera(Amount:float )

func _ready():
	if Global.currentLevelStatus == Global.LevelStatus.Lost ||  Global.currentLevelStatus == Global.LevelStatus.LostTime:
		skip = true
	for x in labelRegistry:
		if pointsDict[labelRegistry[x].stat] != 0:
			var PointShower:HBoxContainer =PointsDisplayer.instantiate()
			#Change the Icon
			var PointIcon:TextureRect = PointShower.get_node("./Icon")
			PointIcon.texture= labelRegistry[x].labelIcon
			PointIcon.self_modulate = labelRegistry[x].IconColor
			#Change the Text
			PointLabels.append(PointShower.get_node("./Label"))
			PointLabels[-1].modulate = labelRegistry[x].color
			PointLabels[-1].text = str(pointsDict[labelRegistry[x].stat])
			#addToRainbow
			if labelRegistry[x].Rainbow:
				RainbowColorNodes.append(PointIcon)
				RainbowColorNodes.append(PointLabels[-1])
			#Particels
			var ParticelEmiiter:GPUParticles2D = PointLabels[-1].get_node("./SpecialParticel")
			ParticelEmiiter.process_material = labelRegistry[x].ProcessMatiral
			ParticelEmiiter.material = labelRegistry[x].animationMatirial
			ParticelEmiiter.texture = labelRegistry[x].ParticelTexure
			ParticelEmiiter.amount = labelRegistry[x].Amount
			ParticelEmiiter.lifetime = labelRegistry[x].LifeTime
			
			
			if(x == Global.Points.time):
				PointLabels[-1].text = formatTimeText()
			#Sound and Camerashake
			if !skip:
				emit_signal("shakeCamera",labelRegistry[x].CamershakeAmount)
				if labelRegistry[x].Multiplayer >=0:
					emit_signal("goodSound",labelRegistry[x].Volume)
				else:
					emit_signal("badSound",labelRegistry[x].Volume)
			add_child(PointShower)
			move_child(PointShower,get_child_count()-spawnPoint)
			await get_tree().create_timer(timeDelaySinceNext).timeout
			if skip:
				timeDelaySinceNext = 0
			
	emit_signal("finished")
	
func _input(event):
	if event is InputEventKey && event.is_pressed() || event is InputEventJoypadButton && event.is_pressed():
		skipLoad()

var hue: float = 0.0

func _process(delta):
	hue += delta * 0.4
	if hue > 1:
		hue = 0
	for node in RainbowColorNodes:
		node.self_modulate = Color.from_hsv(hue, 1.0, 1.0)

func skipLoad():
	skip = true

func formatTimeText()->String:
	var inttime:int = pointsDict[Global.Points.time]
	var seconds:int = int(inttime / 100.0)
	var ms:int = inttime %100
	
	
	return "%02d:%02d" % [seconds, ms]
