extends Sprite2D

@export var rhythm:RhythmNotifier
@onready var time = rhythm.beat_length
signal spawnPoint
func VulkanAnimation(beat: int):
	var vulkanTween:Tween = get_tree().create_tween()
	if beat %2 == 0:
		vulkanTween.tween_property(self,"scale",Vector2(1.05,0.75),time)
		emit_signal("spawnPoint")
	else:
		vulkanTween.tween_property(self,"scale",Vector2(0.75,1.05),time)
	
