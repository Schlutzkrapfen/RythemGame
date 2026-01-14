extends VBoxContainer

@export var Title:RichTextLabel
@export var Icon: TextureRect
@export var Text:RichTextLabel

@onready var UnlockHouse =Global.house_registry[Global.level_registery[Global.currentLevel].PossibleHouseUnlocks]



func _ready():

	Title.text = UnlockHouse.displayName 
	Icon.texture = UnlockHouse.buttonIconHD
	Text.text = UnlockHouse.descriptions
