extends Node2D


@export var mob_scene: PackedScene
@export var Backround: TileMapLayer
@export var mainlayer: TileMapLayer
var backgroundTiles: Array[Vector2]
var floatTimeTillImpactHalf:float = 1
var spawnAmount:int = 3


func _on_vulkan_spawn_point():
	for i in spawnAmount:
		SpawnMeteor()
	
func SpawnMeteor():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()
	# Spawn the mob by adding it to the Main scene.
	var ranodmNummber =randi_range(0,backgroundTiles.size()-1)
	mob.endPosition =Backround.to_global(Backround.map_to_local(backgroundTiles[ranodmNummber]))
	mob.global_position = self.global_position
	mob.meterosInAirHalf = floatTimeTillImpactHalf
	get_parent().get_parent().add_child(mob)
	var unremovedtile = backgroundTiles[ranodmNummber]
	backgroundTiles.remove_at(ranodmNummber)
	await get_tree().create_timer(floatTimeTillImpactHalf*2).timeout
	mainlayer.set_cell(unremovedtile,4,Vector2i(5,5))

func _ready():
	FindSpawnLoacation()
func FindSpawnLoacation():
	var source_id = 0
	var atlas_coords:Vector2 = Vector2(1,1)
	var tile_set_source: TileSetAtlasSource = Backround.tile_set.get_source(source_id)
	var tile_data = tile_set_source.get_tile_data(atlas_coords, 0)
	for tiles in Backround.get_used_cells():
		if Backround.get_cell_tile_data(tiles) == tile_data:
			backgroundTiles.append(tiles)
