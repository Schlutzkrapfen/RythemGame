extends Control

@export var Emmiters:Array[GPUParticles2D]

enum ParticelsOrder {Miss,Early,Full,Okay,Good,Perfect,Confetti,BadEffect,GoodEffect}

func playEmitter(order:ParticelsOrder)-> void:
	Emmiters[order].restart()
	Emmiters[order].emitting


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
