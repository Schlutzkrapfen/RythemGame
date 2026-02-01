extends Control
@export var texture:Texture2D


@export var bpmbeat:float= Global.level_registery[Global.currentLevel].BPM
@export var beatuntildeleted:float = 3

@onready var time_to_reach_center = (60.0 / bpmbeat) * beatuntildeleted

@onready var parent: Control = get_parent()
@onready var speed = 1 / time_to_reach_center

@onready var timer = $Timer
func _ready():
	timer.wait_time = time_to_reach_center
	timer.start()
	
func _process(delta):
	self.scale -=  Vector2(speed * delta,speed*delta)


func _on_timer_timeout():
	self.queue_free()
