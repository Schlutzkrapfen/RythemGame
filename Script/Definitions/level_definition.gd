class_name LevelDefinition extends Resource

@export_group("Visuals")
@export var labelIcon: Texture2D
@export var UnlockIcon: Array[Texture2D]

@export_group("Stats")
@export var Level: int = 0
@export_file("*.tscn") var levelPath: String
@export var PossibleHouseUnlocks:Global.HouseID
@export var MaxTime:int = 20
@export var UnlocksNeeded:Dictionary[Global.Points,int]
##Bigger means less (higher threshold = fewer trees)
@export_range(0, 1.0) var treeSpawnThreshold = 0.9

@export_group("Types")
@export var PointsPossible:Array[Global.Points]

@export_group("Music")
@export var BPM:float = 140
