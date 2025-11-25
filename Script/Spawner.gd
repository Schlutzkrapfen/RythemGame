extends Node2D

# We need a reference to the TileMap node.
@export var tilemap: TileMapLayer
var source
var Houses = {"Normal House":Vector2i(1,1),"WoodCutter":Vector2i(2,1),"Tree":Vector2i(11,6)}

func PrintOutputTiles():
	if is_instance_valid(tilemap):
		print("--- TileMap Cell Checker Initialized ---")
		print("TileMap Node Name: ", tilemap.name)
		
		var tile_set = tilemap.tile_set
		if tile_set == null:
			print("ERROR: No TileSet assigned!")
			return
		
		print("TileSet found!")
		print("Number of sources: ", tile_set.get_source_count())
		
		# Get the ACTUAL source IDs (don't assume 0, 1, 2...)
		print("\n--- Available Sources ---")
		var source_ids= tile_set.get_source_id(0)
	
		
		print("Source ID List: ", source_ids)
		


func _input(event):
	# Check specifically for a left mouse button press
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		
		# 1. Get the mouse position in the game world (pixel-based)
		var world_pos: Vector2 = get_global_mouse_position()
		
		# 2. Convert the world position (pixels) into the TileMap's grid coordinates (cell index)
		# This is the "ID" of the cell you clicked on.
		var tile_coords: Vector2i = tilemap.local_to_map(world_pos)
		var source_id = tilemap.get_cell_source_id(tile_coords)
		var atlas_coords = tilemap.get_cell_atlas_coords(tile_coords)

		print("Source ID: ", source_id)
		print("Atlas Coords: ", atlas_coords)
		
		print("\n--- Mouse Click Recorded ---")
		print("1. Raw World Position (Pixels): ", world_pos)
		print("2. Converted Grid Coordinates (Cell ID): ", tile_coords)
		var tile_data = tilemap.get_cell_tile_data(tile_coords)
		#I havent found a better way but one tile is spawned and than seen if there is equal to other
		var tree_tile_data = tilemap.get_cell_tile_data(Vector2i(-1,0))
		print(tile_data)
		print(tree_tile_data)
		if tile_data == null || tile_data == tree_tile_data :
			tilemap.set_cell(tile_coords,1, Houses.get("Normal House"))
		else:
			print("there is already Something There")
			return
		
func _ready():
	PrintOutputTiles()
	
