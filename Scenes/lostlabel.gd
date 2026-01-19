extends Label
var particelEmmiter:Array[GPUParticles2D]
signal chamerashake(float)
signal playBadSound(float)

func _ready():
	self.pivot_offset = self.size/2
	for child in get_children():
		particelEmmiter.append(child)
		child.position = self.size/2



func _on_end_points_finished():
	if Global.currentLevelStatus == Global.LevelStatus.Lost ||  Global.currentLevelStatus == Global.LevelStatus.LostTime:
		self.visible = true
		for particelEmmite in particelEmmiter:
			particelEmmite.emitting = true
		emit_signal("chamerashake",0.8)
		emit_signal("playBadSound",12)
		
		
		
