extends Node

#Ui Spawner needs always the fastest but the Main one needs 
#to have the current one
enum RythmRange {UiSpawner, Main}
##change the BPM of the RythemSpawner

@export var rythm:Array[RhythmNotifier]
var currentbeatSpeed:float
var nowHouse:Global.musicSpeed
var currentHouses: Array[Global.HouseID] = Global.HouseSelected
var BPM: int = Global.level_registery[Global.currentLevel].BPM 
func _ready():
	rythm[RythmRange.UiSpawner].bpm = BPM *2


func _on_backgorund_switch_house(House):
	match (Global.house_registry[currentHouses[House]].musicSpeed):
		Global.musicSpeed.slow:
			currentbeatSpeed = float(BPM) /2
		Global.musicSpeed.normal:
			currentbeatSpeed = BPM 
		Global.musicSpeed.fast:
			currentbeatSpeed= BPM *2
	nowHouse = Global.house_registry[currentHouses[House]].musicSpeed
	rythm[RythmRange.Main].current_position = 0
	rythm[RythmRange.Main].running = false
	


func _on_rhythm_notifier_beat(current_beat):
	match nowHouse:
		Global.musicSpeed.slow:
			if current_beat %4 != 0:
				return
		Global.musicSpeed.normal:
			if  current_beat %2 != 0:
				return
	rythm[RythmRange.Main].bpm = currentbeatSpeed
	rythm[RythmRange.Main].running = true
	
