extends Control

##How many lines are displayed at one time on each side
@export var lines:int =3
@export var onMouse:bool = false
var rythemInvisible:int  =2 
var RythemSpawner:PackedScene = preload("res://Scenes/BPMLine.tscn")
var lineSizeX:int = 2

const BPMLineType = preload("res://Script/Ui/bpm_line.gd")
var BPMLinesL:Array[BPMLineType] 
var BPMLinesR:Array[BPMLineType] 
func _on_rhythm_notifier_beat(current_beat):
	SpanwLine(current_beat,false)
	SpanwLine(current_beat,true)

##Spawns a Line that than moves in the center of the object
func SpanwLine(beat,right):
	var BPMLine:BPMLineType =RythemSpawner.instantiate()
	BPMLine.visible = false
	BPMLine.beatNumber = beat
	if beat != 0:
		if beat % rythemInvisible == 0:
			BPMLine.visible = true
	if onMouse:
		BPMLine.custom_minimum_size.x = lineSizeX
	if right:
		BPMLine.set_ancher_right()
		BPMLinesR.append(BPMLine)
	else:
		BPMLinesL.append(BPMLine)
	BPMLine.beatuntildeleted = lines
	add_child(BPMLine)
	move_child(BPMLine,0)
##Stops the line and deletes it after the time is off
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
		

func _on_help_layer_current_position(pos):
	if onMouse:
		self.position = pos -self.size/2

func _on_backgorund_switch_house(House):
	var houseSpeed:Global.musicSpeed = Global.house_registry[Global.HouseSelected[House]].musicSpeed
	match(houseSpeed):
		Global.musicSpeed.slow:
			rythemInvisible = 4
		Global.musicSpeed.normal:
			rythemInvisible = 2
		Global.musicSpeed.fast:
			rythemInvisible = 1
	CheckIfLineShouldVisible()
func CheckIfLineShouldVisible():
	for line in BPMLinesL:
		if is_instance_valid(line):
			if line.beatNumber % rythemInvisible == 0:
				line.visible = true
			else:
				line.visible = false
	for line in BPMLinesR:
		if is_instance_valid(line):
			if line.beatNumber % rythemInvisible == 0:
				line.visible = true
			else:
				line.visible = false
