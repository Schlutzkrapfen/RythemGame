extends Node2D

# We need a reference to the TileMap node.
@onready var tilemap: TileMapLayer = $TileMapLayer



func _ready():
	# Initialization and confirmation printouts
	if is_instance_valid(tilemap):
		print("--- TileMap Cell Checker Initialized ---")
		print("TileMap Node Name: ", tilemap.name)
		print("Left-click anywhere to check the cell status.")
		print("---------------------------------------------")
	else:
		print("ERROR: Could not find a TileMap node named 'CityMap'. Please check your scene tree.")

func _input(event):
	# Check specifically for a left mouse button press
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		# 1. Get the mouse position in the game world (pixel-based)
		var world_pos: Vector2 = get_global_mouse_position()
		
		# 2. Convert the world position (pixels) into the TileMap's grid coordinates (cell index)
		# This is the "ID" of the cell you clicked on.
		var tile_coords: Vector2i = tilemap.local_to_map(world_pos)
		
		print("\n--- Mouse Click Recorded ---")
		print("1. Raw World Position (Pixels): ", world_pos)
		print("2. Converted Grid Coordinates (Cell ID): ", tile_coords)
		print(tilemap.get_cell_tile_data(tile_coords))
