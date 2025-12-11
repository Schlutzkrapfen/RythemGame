extends Control


@export var Labels:Array[Label] 


func _ready():
	var People:int = Global.People
	var unemployment:int = Global.unemployment
	var Wood:int = Global.UnusedWood
	var Multiplayer:int = Global.GoldMultiplayer
	Labels[0].text = str(People)
	Labels[1].text = str(unemployment)
	
	Labels[2].text = str(Wood)+ "*3= " + str(Wood*3)
	Labels[3].text = str(Multiplayer +1)
	Labels[4].text = str(((People-unemployment)+Wood*3)*(Multiplayer+1))
	
