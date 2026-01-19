extends Node

@export var AudioSource: Array[AudioStreamPlayer]

enum {Music,Hit,Miss0,Miss1,Miss2,Kaching,PointsUp,startPoint}
var CurrentBadSound = 0
@export var Volume:Curve

func _on_node_2d_perfect():
	AudioSource[Hit].volume_db = -10
	AudioSource[Hit].play()


func _on_node_2d_okay():
	AudioSource[Hit].volume_db = -20
	AudioSource[Hit].play()


func _on_node_2d_good():
	AudioSource[Hit].volume_db = -15
	AudioSource[Hit].play()

func _on_node_2d_early_full_miss():
	AudioSource[Music].volume_db = 0
	var random = randi_range(Miss0,Miss2)
	AudioSource[random].volume_db = -20
	AudioSource[random].play()
	

func _on_start_point_finished():
	AudioSource[PointsUp].play()

func _on_win_point_spawner_good_sound(volume):
	AudioSource[Hit].volume_db = volume
	AudioSource[Hit].play()


func _on_win_point_spawner_bad_sound(volume):
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
