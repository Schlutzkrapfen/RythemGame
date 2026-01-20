#This Script main Reason is for the Winscreen
class_name PointsDefinition extends Resource

@export_group("Visuals")
@export var labelIcon: Texture2D
@export var descript: String = "JUST FOR DEVELOPOR"
@export var CamershakeAmount: float = 0.2


@export_group("Sounds")
@export var Volume:float = 0

@export_group("Stats")
@export var stat:Global.Points
@export var color:Color = Color.WHITE
@export var IconColor:Color = Color.WHITE
@export var Rainbow:bool = false
@export var Multiplayer:float = 1.0
@export var needsFloat:bool = false


@export_group("Particel")
@export var ParticelTexure: Texture2D
@export var ProcessMatiral:ParticleProcessMaterial
@export var animationMatirial:Material
@export var LifeTime:float = 0.4
@export var Amount:int = 30
@export var inGameLifeTime:float = 0.2
@export var inGameAmount = 10
