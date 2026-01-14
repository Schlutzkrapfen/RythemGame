extends HFlowContainer


@onready var HouseScene:PackedScene = preload("res://Scenes/SelecetHouse.tscn")
@onready var Spacer:PackedScene = preload("res://Scenes/spacer.tscn")

func _ready():
	for House in 30:
		var HouseButton:Button = HouseScene.instantiate()
		HouseButton.button_up.connect(_on_house_button_up.bind(House))
		add_child(HouseButton)

func _on_house_button_up(id:int):
	print("House button was pressed!",id)
