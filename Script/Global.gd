extends Node

enum Points  {Miss,Early,Full,Okay,Good,Perfect,people,unemployed,wood,unusedWood,multiplaier}
var endPoints: int = 0
var range:Array[int] =  [0,3,0,4];
var Houses:Dictionary = {"House":Vector2i(0,0),"WoodCutter":Vector2i(1,0),"WoodCutterHL":Vector2i(2,0),"WoodCutterWL":Vector2i(4,0),"WoodCutterHR":Vector2i(3,0),"WoodCutterWR":Vector2i(5,0),"Tree":Vector2i(1,0),"WinHouse":Vector2i(3,1)}
enum House { Normal = 0,Woodcutter= 1, Winhouse=2, Backery=3  }


var pointsDict: Dictionary[Global.Points, int] = {
	Global.Points.Miss: 0, 
	Global.Points.Early: 0, 
	Global.Points.Full: 0, 
	Global.Points.Okay: 0, 
	Global.Points.Good: 0, 
	Global.Points.Perfect: 0, 
	Global.Points.people: 0, 
	Global.Points.unemployed: 0, 
	Global.Points.wood: 0, 
	Global.Points.unusedWood: 0, 
	Global.Points.multiplaier: 0, 
}
