extends Node
@export var container: VBoxContainer
@onready var HighScorePath :String="user://highscores"+str(Global.currentLevel)+".json"

var name_input: LineEdit
var score_saved: bool = false
@onready var font = load("res://Font/PublicSans-VariableFont_wght.ttf")



# Called when the node enters the scene tree for the first time.
func startaddingPoints() -> void:
	if container==null:
		return

	var highscores = Deserialize()
	var player_position = find_player_position(highscores, Global.endPoints)
	var current_position = 0
	var display_number = 1

	for highscore in highscores:
		# Insert player input at the correct position (only if in top 10)
		if current_position == player_position and not score_saved and player_position < 10:
			add_name_input(display_number)
			display_number += 1

		# Only show top 10 entries
		if display_number > 10:
			break

		var lable :Label
		lable=Label.new()
		lable.add_theme_font_override("font", font)
		lable.text=str(display_number) + ". " + str(highscore)+": "+str(highscores[highscore])
		lable.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lable.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		container.add_child(lable)
		current_position += 1
		display_number += 1

	# If player score is lowest or list is empty, add input at the end (within top 10)
	if current_position == player_position and not score_saved and player_position < 10:
		add_name_input(display_number)
	# If player is not in top 10, show at position 11
	elif player_position >= 10 and not score_saved:
		add_name_input(11)
	pass

func add_name_input(position: int) -> void:
	var input_container = HBoxContainer.new()
	input_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input_container.alignment = BoxContainer.ALIGNMENT_CENTER

	var position_label = Label.new()
	position_label.text = str(position) + ". "

	name_input = LineEdit.new()
	name_input.add_theme_font_override("font", font)
	name_input.max_length = 20
	name_input.placeholder_text = "Enter your name"
	name_input.custom_minimum_size = Vector2(200, 0)
	name_input.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	name_input.alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_input.text_submitted.connect(_on_name_submitted)

	var score_label = Label.new()
	score_label.text = ": " + str(Global.endPoints)
	score_label.add_theme_font_override("font", font)
	input_container.add_child(position_label)
	input_container.add_child(name_input)
	input_container.add_child(score_label)
	container.add_child(input_container)

	# Focus the input so player can type immediately
	name_input.call_deferred("grab_focus")

func find_player_position(highscores: Dictionary, score: int) -> int:
	var position = 0
	for key in highscores:
		if score > highscores[key]:
			return position
		position += 1
	return position

func _on_name_submitted(player_name: String) -> void:
	if player_name.strip_edges() == "":
		return

	AddHighscore(player_name, Global.endPoints)
	score_saved = true

	# Refresh the display
	for child in container.get_children():
		child.queue_free()

	var highscores = Deserialize()
	var display_number = 1
	for highscore in highscores:
		if display_number > 10:
			break
		var lable :Label
		lable=Label.new()
		lable.add_theme_font_override("font", font)
		lable.text=str(display_number) + ". " + str(highscore)+": "+str(highscores[highscore])
		lable.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lable.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		container.add_child(lable)
		display_number += 1
	pass

func sort_dict_by_value(input_dict: Dictionary) -> Dictionary:
	var keys = input_dict.keys()
	# Sort keys by their corresponding values (descending order - highest first)
	keys.sort_custom(func(a, b): return input_dict[a] > input_dict[b])

	var sorted_dict = {}
	for key in keys:
		sorted_dict[key] = input_dict[key]
	return sorted_dict

func Deserialize()->Dictionary:
	if not FileAccess.file_exists(HighScorePath):
		return {}
	var file: FileAccess = FileAccess.open(HighScorePath, FileAccess.READ)
	if file == null:
		return {}

	var content: String = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(content)
	if error != OK:
		return {}
	return sort_dict_by_value(json.data)

func Serialize(values:Dictionary)->void:
	var json_string: String = JSON.stringify(values)
	var file: FileAccess = FileAccess.open(HighScorePath, FileAccess.WRITE)
	if file != null:
		file.store_string(json_string)
		file.close()
	pass

func AddHighscore(player_name: String, score: int)->void:
	var highscores: Dictionary = Deserialize()
	highscores[player_name] = score
	Serialize(highscores)
	pass


func _on_end_points_finished():
	startaddingPoints()
