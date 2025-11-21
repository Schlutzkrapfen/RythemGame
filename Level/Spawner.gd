extends Node2D

@onready var label:Label =$Control/Label/Label
@onready var label2:Label =$Control/Label2/Label
@onready var animationsPlayer:AnimationPlayer =$AnimationPlayer
@onready var Ui:ColorRect =$UiFeedback
@onready var particel:CPUParticles2D = $CPUParticles2D
var people:int =0;
var curretnPressed:int = 0;
var MouseIsOverSprite:bool = false;
var Housegruop = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@export var house_scene: PackedScene
@export var woodcutter_scene: PackedScene
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#print("Mouse Click/Unclick at: ", event.position)
		if Ui.visible && !MouseIsOverSprite:
			if curretnPressed == 0:
				_spawnhouse(get_viewport().get_mouse_position(),0)
			if curretnPressed == 1 && people > 4:
				_spawnhouse(get_viewport().get_mouse_position(),1)
			elif curretnPressed == 1 && people < 5:
				print("two few people")
		elif MouseIsOverSprite:
			print("Something is in the way")
	if event.is_action_pressed("House"):
		print("Switched to People")
		curretnPressed = 0;
	if event.is_action_pressed("Woodcuter"):
		curretnPressed = 1;
		print("Switched to wood")
	
func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	for sprite in Housegruop:
		var tex_size = sprite.get_child(0).texture.get_size() * sprite.get_child(0).scale
		var rect = Rect2(sprite.position - tex_size / 2, tex_size)
		if rect.has_point(mouse_pos):
			MouseIsOverSprite =true
		else:
			MouseIsOverSprite =false

func _spawnhouse(position,currentHouse):
	
	label.text = str(people)
	label2.text = str(5-people)
	var house = house_scene.instantiate()
	if currentHouse == 0:
		people += 1
	if currentHouse == 1:
		people -= 5
		house = woodcutter_scene.instantiate()
	Housegruop.append(house)

	# Set the house position (note: position, not positon)
	house.position = position
	house.add_to_group("spawned_sprites")

	particel.position = position
	particel.emitting =true
	# Spawn the mob by adding it to the Main scene.
	add_child(house)


func _on_midi_player_midi_event(channel: Variant, event: Variant) -> void:
	animationsPlayer.play("Tick")
