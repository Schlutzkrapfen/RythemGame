extends CanvasItem

var hue: float = 0.0

func _process(delta):
	hue += delta * 0.4
	if hue > 1:
		hue = 0
	
	self.self_modulate = Color.from_hsv(hue, 1.0, 1.0)
