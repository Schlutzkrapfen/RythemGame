extends Sprite2D
@export var currentSPritepoition:int

func _ready():
	if currentSPritepoition > vframes:
		currentSPritepoition = 0
	playanimation()

func playanimation():
	frame =currentSPritepoition*4+ ((frame + 1) % 4)
	await get_tree().create_timer(randf_range(0.1,0.2)).timeout
	playanimation()
