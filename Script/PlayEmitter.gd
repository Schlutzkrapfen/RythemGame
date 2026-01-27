extends Control

@export var Emmiters:Array[GPUParticles2D]
@export var moveToMouse:bool = false


enum ParticelsOrder {Miss,Early,Full,Okay,Good,Perfect,Confetti,BadEffect,GoodEffect}
var buildEffect:PackedScene = preload("res://ParticelEmmiters/buildEffect.tscn")



func _process(delta):
	if moveToMouse:
		self.position = get_global_mouse_position()

func playEmitter(order:ParticelsOrder)-> void:
	Emmiters[order].restart()


func _on_node_2d_perfect():
	playEmitter(ParticelsOrder.Perfect)
	playEmitter(ParticelsOrder.Confetti)


func _on_node_2d_okay():
	playEmitter(ParticelsOrder.Okay)


func _on_node_2d_good():
	playEmitter(ParticelsOrder.Good)
	playEmitter(ParticelsOrder.GoodEffect)


func _on_node_2d_early():
	playEmitter(ParticelsOrder.Early)
	playEmitter(ParticelsOrder.BadEffect)


func _on_node_2d_full():
	playEmitter(ParticelsOrder.Full)
	playEmitter(ParticelsOrder.BadEffect)


func _on_node_2d_miss():
	playEmitter(ParticelsOrder.Miss)
	playEmitter(ParticelsOrder.BadEffect)


#TODO: Don't Spawn these change. Make a pool out of them
func _on_node_2d_changed_house_at_position(House, _TilePosition,GlobalPosition):
	var Particel:GPUParticles2D =buildEffect.instantiate()
	var currentPointsStats = Global.labelRegistry[Global.house_registry[House].unitType]
	Particel.texture = currentPointsStats.ParticelTexure
	Particel.process_material = currentPointsStats.ProcessMatiral
	Particel.material = currentPointsStats.animationMatirial
	Particel.lifetime = currentPointsStats.inGameLifeTime
	Particel.amount = currentPointsStats.inGameAmount
	Particel.top_level = true
	#TODO:FIND A BETTER FIX
	if get_tree().current_scene:
		get_tree().current_scene.add_child(Particel)
	Particel.global_position = GlobalPosition
	Particel.emitting = true
