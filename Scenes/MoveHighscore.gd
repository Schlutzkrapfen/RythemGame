extends Button
@export var highscore:Control 
@onready var parent:Control = get_parent()
@onready var currentPosition:Vector2  = highscore.position
var clicked:bool = false
func _on_button_up():
	var tween = get_tree().create_tween()
	var buttonTween = get_tree().create_tween()
	if clicked:
		tween.tween_property(highscore, "position", Vector2(currentPosition.x, 0), 0.5).set_trans(Tween.TRANS_BOUNCE)
		buttonTween.tween_property(self, "position", Vector2(parent.size.x-self.size.x, 0), 0.5).set_trans(Tween.TRANS_BOUNCE)
	else:
		tween.tween_property(highscore , "position", Vector2(500, 0), 0.5).set_trans(Tween.TRANS_BOUNCE)
		buttonTween.tween_property(self, "position", Vector2(parent.size.x-self.size.x- 500, 0), 0.5).set_trans(Tween.TRANS_BOUNCE)
	clicked = !clicked


func _on_end_points_finished():
	self.visible = true
