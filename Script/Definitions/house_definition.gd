class_name HouseDefinition extends Resource

@export_group("Visuals")
@export var buttonIcon: Texture2D
@export var labelIcon: Texture2D
@export var TileMapID: int = 0
@export var TileMapPosition:Vector2i 


@export_group("Stats")
@export var displayName: String = "New House"
@export var discription: String = "Here is what the house does"
@export var houseRange: int = 0
@export var buildCost: Array[int] = [0]
@export var points:int = 1



@export_group("Types")
@export var unitType:Global.Points
@export var buildType: Array[Global.Points] = [Global.Points.people]
