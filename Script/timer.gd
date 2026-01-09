extends Timer


func _ready():
	self.wait_time = Global.level_registery[Global.currentLevel].MaxTime
