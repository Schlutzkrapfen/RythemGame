# CityEditorPoC.gd
# Attach this script to your main 2D scene node.
extends Node2D

# --- Configuration ---
@onready var tilemap: TileMapLayer = $TileMapLayer



func _input(event):
	# Check specifically for a left mouse button press
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		# 1. Get the mouse position in the game world (pixel-based)
		var world_pos: Vector2 = get_global_mouse_position()
	
		var tile_coords: Vector2i = tilemap.local_to_map(world_pos)
		
		print("\n--- Mouse Click Recorded ---")
		print("1. Raw World Position (Pixels): ", world_pos)
		print("2. Converted Grid Coordinates (Cell ID): ", tile_coords)
