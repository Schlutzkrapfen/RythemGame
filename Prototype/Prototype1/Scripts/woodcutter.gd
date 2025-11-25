extends Node2D
@onready var CuttingZone:Area2D = $Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	var trees = CuttingZone.get_overlapping_areas()
	print(CuttingZone.has_overlapping_areas())
	print("Number of bodies found: ", trees.size())
	print("Bodies array: ", trees)
	
	for tree in trees:
		tree.get_parent().queue_free()
		GlobalValues.wood += 1
		print("Detected tree: ", tree.name)
		
	print(GlobalValues.wood)
