extends TileMapLayer


var xsize:Vector2i = Vector2i(3,31)
var ysize:Vector2i = Vector2i(2,17)
var treePositions:Array[Vector2i]
signal treesSpawned(Array)

#Spawns the trees
func _ready():
	randomize()
	for x in range(xsize.x,xsize.y):
		for y in range(ysize.x,ysize.y):
			var n = randf_range(0,1.0)
			if n < Global.level_registery[Global.currentLevel].treeSpawnThreshold:
				continue
			if self.get_cell_tile_data(Vector2i(x,y)) != null:
				continue
			if (x+y) %2   == 0:
				self.set_cell(Vector2i(x,y),1,Vector2i(1,0))
			else:
				self.set_cell(Vector2i(x,y),1,Vector2i(0,0))
			treePositions.append(Vector2i(x,y))
	emit_signal("treesSpawned",treePositions)
