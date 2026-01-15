extends Node

enum Points  {Miss = 0,Early = 1,Full =2,Okay=3,Good=4 ,Perfect=5 ,people=6 ,unemployed=7,wood=8 ,unusedWood=9,time=10,multiplaier =11}
var endPoints: int = 0
enum HouseID { Default = 0,Trees=1 ,WoodCutter= 2, Market=3, Backery=4  }
enum HouseType {Trees = 0, Houses = 1, ConstroctionBuilding =2,CityBuildings = 3}

var BuildCostAmount: Array[int]
var BuildResources: Array[Points]
var MakeResources: Array[Points]
var PointsIcons: Array[Texture2D]
var ButtonIcons: Array[Texture2D]
var HouseUnlocked: Array[HouseID]
var AutomaticSwitcher:bool = false
var currentLevel:int= 0

var HouseSelected:Array[HouseID] = []
@onready var unlockedHouses:Array[HouseID] = HouseSelected
var house_registry: Dictionary = {
	HouseID.Default: preload("res://Houses/Default.tres"),
	HouseID.Trees: preload("res://Houses/Tree.tres"),
	HouseID.WoodCutter: preload("res://Houses/WoodCutter.tres"),
	HouseID.Market: preload("res://Houses/Market.tres"),
	HouseID.Backery: preload("res://Houses/Backery.tres")
}
var level_registery: Dictionary = {
	0: preload("res://Levels/LevelResources/Level0.tres"),
	1: preload("res://Levels/LevelResources/Level1.tres"),
	2: preload("res://Levels/LevelResources/Level2.tres"),
	3: preload("res://Levels/LevelResources/Level3.tres")
}

var pointsConnectDict: Dictionary[Points,Points] = {
	Points.people:Points.unemployed , 
	Points.wood:Points.unusedWood
}
var pointsDict: Dictionary[Points, int] = {
	Points.Miss: 0, 
	Points.Early: 0, 
	Points.Full: 0, 
	Points.Okay: 0, 
	Points.Good: 0, 
	Points.Perfect: 0, 
	Points.people: 0, 
	Points.wood: 0,
	Points.time:0,
	Points.multiplaier: 1, 
}
var labelRegistry: Dictionary = {
	Points.Miss: preload("res://Points/Miss.tres"),
	Points.Early: preload("res://Points/Early.tres"),
	Points.Full: preload("res://Points/Full.tres"),
	Points.Okay: preload("res://Points/Okay.tres"),
	Points.Good: preload("res://Points/Good.tres"),
	Points.Perfect: preload("res://Points/Perfect.tres"),
	Points.people: preload("res://Points/People.tres"),
	Points.wood: preload("res://Points/Wood.tres"),
	Points.time: preload("res://Points/Time.tres"),
	Points.multiplaier: preload("res://Points/multiplaier.tres")
}
var currentResources: Dictionary[Points, int] = {
	Points.unemployed:0,
	Points.multiplaier:1,
	Points.unusedWood:0
}
func ResetLevel():
	ResetVeriables()
	GetHousesVeriables()
func _ready():
	GetHousesVeriables()
	
func ResetVeriables():
	BuildCostAmount = []
	ButtonIcons = []
	BuildResources = []
	MakeResources = []
	PointsIcons = []
	currentResources=  {
	Points.unemployed:0,
	Points.multiplaier:1,
	Points.unusedWood:0
}

func GetHousesVeriables() -> void:
	for x in HouseSelected :
		BuildCostAmount.append(house_registry[x].buildCost)
		ButtonIcons.append(house_registry[x].buttonIcon)
		if pointsConnectDict.has(house_registry[x].buildType):
			BuildResources.append(pointsConnectDict[house_registry[x].buildType])
		if pointsConnectDict.has(house_registry[x].unitType):
			MakeResources.append(pointsConnectDict[house_registry[x].unitType])
		else:
			MakeResources.append(house_registry[x].unitType)
		PointsIcons.append(labelRegistry[house_registry[x].unitType].labelIcon)
