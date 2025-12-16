extends Node

enum Points  {Miss,Early,Full,Okay,Good,Perfect,people,unemployed,wood,unusedWood,multiplaier}
var endPoints: int = 0

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
