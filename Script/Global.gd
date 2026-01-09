extends Node

enum Points  {Miss,Early,Full,Okay,Good,Perfect,people,unemployed,wood,unusedWood,multiplaier,time}
var endPoints: int = 0
#var Houses:Dictionary = {"House":Vector2i(0,0),"WoodCutter":Vector2i(1,0),"WoodCutterHL":Vector2i(2,0),"WoodCutterWL":Vector2i(4,0),"WoodCutterHR":Vector2i(3,0),"WoodCutterWR":Vector2i(5,0),"Tree":Vector2i(1,0),"WinHouse":Vector2i(3,1)}
enum HouseID { Default = 0,Trees=1 ,WoodCutter= 2, Market=3, Backery=4  }

var BuildCostAmount: Array[int]
var BuildResources: Array[Points]
var MakeResources: Array[Points]
var PointsIcons: Array[Texture2D]
var ButtonIcons: Array[Texture2D]
var HouseUnlocked: Array[HouseID]
var AutomaticSwitcher:bool = true
var currentLevel:int= 1

var HouseSelected:Array[HouseID] = [HouseID.Default]
var house_registry: Dictionary = {
	HouseID.Default: preload("res://Houses/Default.tres"),
	HouseID.Trees: preload("res://Houses/Tree.tres"),
	HouseID.WoodCutter: preload("res://Houses/WoodCutter.tres"),
	HouseID.Market: preload("res://Houses/Market.tres")
}
var level_registery: Dictionary = {
	1: preload("res://Levels/LevelResources/Level1.tres")
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
	Points.multiplaier: 0, 
	Points.time:0,
	
}
var currentResources: Dictionary[Points, int] = {
	Points.unemployed:0,
	Points.multiplaier:1,
	Points.unusedWood:0
}
func _ready():
	GetHousesVeriables()
	
#TODO:Implement a way to use multiple build Types(EVERY one that is a array needs to be 
#a different way)
func GetHousesVeriables() -> void:
	for x in HouseSelected :
		PointsIcons.append(house_registry[x].labelIcon)
		BuildCostAmount.append(house_registry[x].buildCost[0])
		ButtonIcons.append(house_registry[x].buttonIcon)
		if pointsConnectDict.has(house_registry[x].buildType[0]):
			BuildResources.append(pointsConnectDict[house_registry[x].buildType[0]])
		if pointsConnectDict.has(house_registry[x].unitType):
			MakeResources.append(pointsConnectDict[house_registry[x].unitType])
		else:
			MakeResources.append(house_registry[x].unitType)
