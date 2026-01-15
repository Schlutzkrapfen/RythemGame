class_name HouseDefinition extends Resource

@export_group("Visuals")
@export var buttonIcon: Texture2D
@export var buttonIconHD: Texture2D
@export var tileMapID: Array[int] = [0]
@export var tileMapPosition:Array[Vector2i] 


@export_group("Description")
@export var displayName: String
@export var descriptions: String
@export_group("Stats")
@export var houseRange: int = 0
@export var buildCost: int = 0
@export var points:int = 1
@export var usesType:Global.HouseType


@export_group("Types")
##TO know which to to spawn
@export var houseType:Global.HouseType
@export var destroyes:bool
@export var unitType:Global.Points = Global.Points.people
@export var buildType: Global.Points = Global.Points.people
