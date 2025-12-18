extends TileMapLayer

@export_range(0, 1.0) var threshold := 0.5
@export var MainLayer2:TileMapLayer

var xsize:Vector2i = Vector2i(3,31)
var ysize:Vector2i = Vector2i(2,17)


func _ready():
	randomize()
	for x in range(xsize.x,xsize.y):
		for y in range(ysize.x,ysize.y):
			var n = randf_range(0,1.0)
			if n < threshold:
				continue
			if MainLayer2.get_cell_tile_data(Vector2i(x,y)) != null:
				continue
			self.set_cell(Vector2i(x,y),1,Vector2i(1,0))
