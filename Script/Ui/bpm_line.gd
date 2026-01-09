
extends ColorRect

@export var bpmbeat:float=140
@export var beatuntildeleted:float = 3

@onready var time_to_reach_center = (60.0 / bpmbeat) * beatuntildeleted

@onready var parent: Control = get_parent()
@onready var distance_to_center = parent.size.x / 2
@onready var speed = distance_to_center / time_to_reach_center
func _ready():
	$Timer.wait_time = time_to_reach_center
	$Timer.start()
	
func _process(delta):
	if distance_to_center > position.x:
		self.position.x += speed * delta
	else:
		self.position.x -= speed * delta
	

func _on_timer_timeout():
	self.queue_free()
