extends Sprite2D

@export var rhythm:RhythmNotifier
@export var addSize:float = 0.05
@export var removeSize:float = 0.25
@onready var time = rhythm.beat_length
@onready var size = self.global_scale

signal spawnPoint
func VulkanAnimation(beat: int):
	var vulkanTween:Tween = get_tree().create_tween()
	if beat %2 == 0:
		vulkanTween.tween_property(self,"scale",Vector2(size.x+addSize,size.y -removeSize),time)
		emit_signal("spawnPoint")
	else:
		vulkanTween.tween_property(self,"scale",Vector2(size.x-removeSize,size.y +addSize),time)
	
