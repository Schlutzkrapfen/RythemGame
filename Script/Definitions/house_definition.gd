class_name HouseDefinition extends Resource

@export_group("Visuals")
@export var buttonIcon: Texture2D
@export var buttonIconHD: Texture2D
@export var TileMapID: int = 0
@export var TileMapPosition:Vector2i 


@export_group("Description")
@export var displayName: String
@export var descriptions: String
@export_group("Stats")
@export var houseRange: int = 0
@export var buildCost: int = 0
@export var points:int = 1


@export_group("Types")
@export var unitType:Global.Points = Global.Points.people
@export var buildType: Global.Points = Global.Points.people
