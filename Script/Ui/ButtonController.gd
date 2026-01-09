extends VBoxContainer

var TextureButtons:Resource = preload("res://Scenes/SwitchButtons.tscn")
var CurrentUnlocked:Array[bool]
var buttons: Array[TextureButton]
var IconSize: int 
@export var TweenDuration:float = 0.2
@export var ButtonsIcon: Array[Texture2D] 
@export var offset: int = 10

@onready var Resouces: Array[Global.Points] = Global.BuildResources
@onready var CostAmount: Array[int] = Global.BuildCostAmount

func _ready():
	for x in Global.HouseSelected.size():
		buttons.append(TextureButtons.instantiate())
		CurrentUnlocked.append(false)
		
		var buttonIcon:TextureRect = buttons[x].get_child(2)
		IconSize = int(buttonIcon.size.x)
		buttonIcon.texture = ButtonsIcon[x]
		buttonIcon= buttons[x].get_child(1)
		buttonIcon.texture = Global.ButtonIcons[x]
	
		add_child(buttons[x])
	var tween = create_tween()
	tween.tween_property(buttons[0],"position",Vector2(IconSize+offset,0),TweenDuration).set_trans(Tween.TRANS_BOUNCE)
	
		
func checkIfSomethingUnlocked():
	for currentHouse in buttons.size():
		var tween = create_tween()
		if Global.currentResources[Resouces[currentHouse]] >=CostAmount[currentHouse]:
			tween.tween_property(buttons[currentHouse],"position",Vector2(IconSize+offset,buttons[currentHouse].position.y),TweenDuration).set_trans(Tween.TRANS_BOUNCE)
		else:
			tween.tween_property(buttons[currentHouse],"position",Vector2(0,buttons[currentHouse].position.y),TweenDuration).set_trans(Tween.TRANS_BOUNCE)
	

func _on_node_2d_update_values():
	checkIfSomethingUnlocked()
