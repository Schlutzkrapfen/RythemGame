class_name HouseDefinition extends Resource

@export_group("Visuals")
@export var buttonIcon: Texture2D
@export var buttonIconHD: Texture2D
@export var tileMapID: Array[int] = [0]
@export var tileMapPosition:Array[Vector2i] 
@export var size: Vector2i =  Vector2i(1,1)


@export_group("Description")
@export var displayName: String
@export var descriptions: String
@export_group("Stats")
@export var houseRange: int = 0
@export var buildCost: int = 0
@export var points:float = 1
@export var usesType:Array[Global.HouseType]
@export var musicSpeed:Global.musicSpeed = Global.musicSpeed.normal


@export_group("Types")
##TO know which house tyoe is influenced by the house 
@export var houseType:Global.HouseType
@export var destroyes:bool
## What type you get back from the Building 
@export var unitType:Global.Points = Global.Points.people
##What type is used to build the building
@export var buildType: Global.Points = Global.Points.people
