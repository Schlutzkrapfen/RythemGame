extends Control

var RythemSpawner:PackedScene = preload("res://Scenes/BPMLine.tscn")
var RythemSpawner1:PackedScene = preload("res://Scenes/BPMLineRight.tscn")

func _on_rhythm_notifier_beat(_current_beat):
	var BPMLine:ColorRect =RythemSpawner.instantiate()
	add_child(BPMLine)
	BPMLine.set_anchor(SIDE_LEFT,6)
	move_child(BPMLine,0)
	BPMLine =RythemSpawner1.instantiate()
	add_child(BPMLine)
	BPMLine.set_anchor(SIDE_LEFT,6)
	move_child(BPMLine,0)
