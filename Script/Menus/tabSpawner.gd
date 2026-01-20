extends TabContainer

var TabGRaphic:PackedScene = preload("res://Scenes/TabGraphic.tscn")

func _ready():
	if !GlobalSettings.WebBuild:
		var Scene =TabGRaphic.instantiate()
		add_child(Scene)
