class_name LevelDefinition extends Resource

@export_group("Visuals")
@export var labelIcon: Texture2D
@export var UnlockIcon: Array[Texture2D]

@export_group("Stats")
@export var Level: int = 0
@export var LevelPath:String = "res://Levels/LevelResources/Level1.tres"
@export var PossibleHouseUnlocks:Global.HouseID
@export var MaxTime:int = 20
@export var UnlocksNeeded:Dictionary[Global.Points,int]

@export_group("Types")
@export var PointsPossible:Array[Global.Points]
