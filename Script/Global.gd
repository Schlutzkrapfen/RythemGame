extends Node

enum Points  {Miss,Early,Full,Okay,Good,Perfect,people,unemployed,wood,unusedWood,multiplaier}
var endPoints: int = 0
#var Houses:Dictionary = {"House":Vector2i(0,0),"WoodCutter":Vector2i(1,0),"WoodCutterHL":Vector2i(2,0),"WoodCutterWL":Vector2i(4,0),"WoodCutterHR":Vector2i(3,0),"WoodCutterWR":Vector2i(5,0),"Tree":Vector2i(1,0),"WinHouse":Vector2i(3,1)}
enum HouseID { Default = 0,Trees=1 ,WoodCutter= 2, WinHouse=3, Backery=4  }

var HouseSelected:Array[HouseID] = [HouseID.Default,HouseID.WoodCutter]
var house_registry: Dictionary = {
	HouseID.Default: preload("res://Houses/Default.tres"),
	HouseID.Trees: preload("res://Houses/Tree.tres"),
	HouseID.WoodCutter: preload("res://Houses/WoodCutter.tres")
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
}
var currentResources: Dictionary[Points, int] = {
	Points.unemployed:0,
	Points.multiplaier:0,
	Points.unusedWood:0
}
