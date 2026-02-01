extends TabContainer

var TabGRaphic:PackedScene = preload("res://Scenes/TabGraphic.tscn")

func _ready():
	if !GlobalSettings.WebBuild:
		var Scene =TabGRaphic.instantiate()
		add_child(Scene)

func _input(event):
	if event.is_action_pressed("SwitchToLeftTab"):
		self.select_previous_available()
	if event.is_action_pressed("SwichToRightTab"):
		self.select_next_available()
