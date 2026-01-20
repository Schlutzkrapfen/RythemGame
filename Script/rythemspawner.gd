extends Control

var RythemSpawner:PackedScene = preload("res://Scenes/BPMLine.tscn")
const BPMLineType = preload("res://Script/Ui/bpm_line.gd")
var BPMLinesL:Array[BPMLineType] 
var BPMLinesR:Array[BPMLineType] 
func _on_rhythm_notifier_beat(_current_beat):
	var BPMLine:BPMLineType =RythemSpawner.instantiate()
	add_child(BPMLine)
	move_child(BPMLine,0)
	BPMLinesL.append(BPMLine)
	BPMLine = RythemSpawner.instantiate()
	BPMLine.set_ancher_right()
	add_child(BPMLine)
	move_child(BPMLine,0)
	BPMLinesR.append(BPMLine)
	
func stopLine():
	if BPMLinesL.size() == 0:
		return
	if !is_instance_valid(BPMLinesL[0]):
		BPMLinesL.remove_at(0)
		stopLine()
		return
	if !is_instance_valid(BPMLinesR[0]):
		BPMLinesR.remove_at(0)
		stopLine()
		return
	if BPMLinesL.size() >= 3:
		BPMLinesL[0].stop()
		BPMLinesR[0].stop()
	
func _input(event):
	if event.is_action_pressed("Controller_Input"):
		stopLine()
		
