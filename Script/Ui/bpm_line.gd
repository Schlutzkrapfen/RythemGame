
extends ColorRect 

@export var beatuntildeleted:float = 3
@export var anim:AnimationPlayer 
@export var fadeTime:float = 0.1

var beatNumber: int = 0
@onready var bpmbeat:float= Global.level_registery[Global.currentLevel].BPM
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
	await get_tree().create_timer(fadeTime).timeout
	self.queue_free()

func stop():
	$Timer.wait_time = fadeTime
	speed = 0
	anim.play("FadeOut")
	
func set_ancher_right():
	set_anchors_preset(Control.PRESET_RIGHT_WIDE)
