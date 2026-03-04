extends Node

@export var AudioSource: Array[AudioStreamPlayer]
@export var switchTime:float = 0.1
@onready var offset:float = Global.musicOffset

var music_tween: Tween
enum {MusicSlow,Music,MusicFast,Hit,Miss0,Miss1,Miss2,Kaching,PointsUp,startPoint}
var CurrentBadSound = 0
var rythemOffset

@export var musicVolume:float = 0

func stopMusic():
	for audio in AudioSource:
		audio.stop()

func _on_node_2d_perfect():
	if is_inside_tree():
		AudioSource[Hit].volume_db = -10
		AudioSource[Hit].play()

func _on_node_2d_okay():
	if is_inside_tree():
		AudioSource[Hit].volume_db = -20
		AudioSource[Hit].play()

func _on_node_2d_good():
	if is_inside_tree():
		AudioSource[Hit].volume_db = -15
		AudioSource[Hit].play()

func _on_node_2d_early_full_miss():
	if is_inside_tree():
		AudioSource[Music].volume_db = 0
		var random = randi_range(Miss0,Miss2)
		AudioSource[random].volume_db = -20
		AudioSource[random].play()
	
func _on_start_point_finished():
	if is_inside_tree():
		AudioSource[PointsUp].play()

func _on_win_point_spawner_good_sound(volume):
	if is_inside_tree():
		AudioSource[Hit].volume_db = volume
		AudioSource[Hit].play()


func _on_win_point_spawner_bad_sound(volume):
	if is_inside_tree():
		AudioSource[Miss0+CurrentBadSound].volume_db = volume
		AudioSource[Miss0+CurrentBadSound].play()
		CurrentBadSound=(CurrentBadSound +1) %3

func _on_end_points_kachinging():
	AudioSource[Kaching].play()

func _on_end_points_start_count_up():
	AudioSource[PointsUp].play()

func _on_end_points_stop_count_up():
	AudioSource[PointsUp].stop()
	AudioSource[startPoint].stop()

func _ready():
	#if $"../RhythmNotifier":
	
	#	var rythm:RhythmNotifier = $"../RhythmNotifier"
	#	rythemOffset = rythm.beat_length -offset/10
		
	await get_tree().create_timer(0.75).timeout
	#	for i in 10:
	#		print(rythm.beat_length *i)
	for i in 3:	
		AudioSource[i].play()


func _on_backgorund_switch_house(House):
	if music_tween:
		music_tween.kill()
	music_tween = get_tree().create_tween()
	var speed: int = Global.house_registry[Global.HouseSelected[House]].musicSpeed
	music_tween.tween_property(AudioSource[speed], "volume_db", musicVolume, switchTime).set_trans(Tween.TRANS_SINE)
	for i in 3:
		if i == speed:
			continue
		music_tween.tween_property(AudioSource[i], "volume_db", -80.0, switchTime).set_trans(Tween.TRANS_SINE)
