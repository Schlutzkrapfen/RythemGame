extends Control
enum LabelOrder  {Miss,Early,Full,Okay,Good,Perfect,People ,Wood, multiplaier,Points}

var  startpoints:bool
signal Kachinging
signal startCountUp
signal stopCountUp
@export var Labels:Array[Label] 
@export var animPlayer:AnimationPlayer
@export var particelTexters:Array[CompressedTexture2D]
@export var partivelemitter:Array[GPUParticles2D]
var pointsDict: Dictionary[Global.Points, int] = {
	Global.Points.Miss: 0, 
	Global.Points.Early: 0, 
	Global.Points.Full: 0, 
	Global.Points.Okay: 0, 
	Global.Points.Good: 0, 
	Global.Points.Perfect: 0, 
	Global.Points.people: 0, 
	Global.Points.unemployed: 0, 
	Global.Points.wood: 0, 
	Global.Points.unusedWood: 0, 
	Global.Points.multiplaier: 0, 
}
var CurrentValue:Array[int]
var dictSize:int = 10
var TestVeriable: int = 10
var poinstAddedSpeed:float = 10
var currentpoints:float = 0
var nexpoints:int = 0
var currentmultiplayer:int 
var i:int =0
var switchDirection:bool =false
var skiped:bool = false

var multiplaier: Dictionary[LabelOrder, int] = {
	LabelOrder.Miss: -2, 
	LabelOrder.Early: -1, 
	LabelOrder.Full: -1, 
	LabelOrder.Okay: 1, 
	LabelOrder.Good: 2, 
	LabelOrder.Perfect: 3, 
	LabelOrder.People: 1, 
	LabelOrder.Wood: 3, 
	LabelOrder.multiplaier: 0,
}
func _ready():
	CurrentValue.resize(dictSize)
	pointsDict = Global.pointsDict
	Labels[LabelOrder.Miss].text = str(pointsDict[Global.Points.Miss])
	Labels[LabelOrder.Early].text = str(pointsDict[Global.Points.Early])
	Labels[LabelOrder.Full].text = str(pointsDict[Global.Points.Full])
	Labels[LabelOrder.Okay].text = str(pointsDict[Global.Points.Okay])
	Labels[LabelOrder.Good].text = str(pointsDict[Global.Points.Good])
	Labels[LabelOrder.Perfect].text = str(pointsDict[Global.Points.Perfect])
	Labels[LabelOrder.People].text = str(pointsDict[Global.Points.people])
	Labels[LabelOrder.Wood].text = str(pointsDict[Global.Points.wood])
	Labels[LabelOrder.multiplaier].text = str(pointsDict[Global.Points.multiplaier])
func _input(event):
	if event is InputEventKey && event.is_pressed():
		if !startpoints:
			animPlayer.play("Skip")
			startPoints()
		elif !skiped:
			startpoints= false
			skiped = true
			currentpoints = 0
			print(int(LabelOrder.Points))
			for n in int(LabelOrder.Points):
				currentpoints +=Labels[n].text.to_int()* multiplaier[n]
			currentpoints*= pointsDict[Global.Points.multiplaier]
			Labels[LabelOrder.Points].text = str(currentpoints)
			partivelemitter[0].emitting = false
			Global.endPoints = currentpoints
			emit_signal("stopCountUp")
			emit_signal("Kachinging")
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_file("res://Level/EndScene.tscn")
		
	
func _process(delta):
	if startpoints != true:
		return
	
	if currentpoints < nexpoints && multiplaier[i-1] >= 0 || currentpoints > nexpoints &&multiplaier[i-1] <0:
		currentpoints += delta*poinstAddedSpeed*multiplaier[i-1]
		Labels[LabelOrder.Points].text = str(int(currentpoints))
		partivelemitter[0].texture = particelTexters[i-1]
	else:
		match i:
			LabelOrder.Miss,LabelOrder.Early,LabelOrder.Full:
				emit_signal("startCountUp")
				partivelemitter[0].modulate = Color(1.0, 0.0, 0.0)
				nexpoints += Labels[i].text.to_int()* multiplaier[i]
				i += 1
			LabelOrder.Okay:
				if !switchDirection:
					
					switchDirection= true
					emit_signal("stopCountUp")
					await  get_tree().create_timer(0.5).timeout
					emit_signal("startCountUp")
					partivelemitter[0].modulate = Color(0.0, 1.0, 0.0, 1.0)
					nexpoints +=Labels[i].text.to_int()* multiplaier[i]
					i = LabelOrder.Good
			LabelOrder.Good:
				partivelemitter[0].modulate = Color(1.0, 1.0, 0.0, 1.0)
				nexpoints += Labels[i].text.to_int()* multiplaier[i]
				i += 1
			LabelOrder.Perfect:
				partivelemitter[0].modulate = Color(0.696, 0.0, 0.696, 1.0)
				nexpoints += Labels[i].text.to_int()* multiplaier[i]
				i += 1
			LabelOrder.People,LabelOrder.Wood,LabelOrder.multiplaier :
				partivelemitter[0].modulate = Color(1.0, 1.0, 1.0, 1.0)
				nexpoints += Labels[i].text.to_int()* multiplaier[i]
				i += 1
			LabelOrder.Points:
				partivelemitter[0].emitting = false
				currentpoints = round(currentpoints)
				await get_tree().create_timer(1.0).timeout
				if startpoints == true:
					startpoints = false
					currentpoints*= pointsDict[Global.Points.multiplaier]
					Labels[LabelOrder.Points].text = str(currentpoints)
					Global.endPoints = currentpoints
					emit_signal("stopCountUp")
					emit_signal("Kachinging")
					partivelemitter[0].emitting = false
					partivelemitter[1].emitting=true
					await get_tree().create_timer(0.8).timeout
					get_tree().change_scene_to_file("res://Level/EndScene.tscn")
				
		currentpoints = round(currentpoints)


func startPoints():
	startpoints = true
	partivelemitter[0].emitting = true
