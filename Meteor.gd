extends Node2D

var endPosition: Vector2 = Vector2(0,0)
##Says how long the metoer is in the air just half the time because it needs to calculate how far up it goes
var meterosInAirHalf: float = 1.0
var rotations:float
func _process(delta):
	rotations += delta
	self.rotation =rotations
	
func _ready():
	print(endPosition)
	var positions:Vector2 = Vector2(self.position.x ,position.y -1000)
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(self,"position",positions,meterosInAirHalf)
	tween.tween_property(self,"position",endPosition -get_parent().position,meterosInAirHalf)
