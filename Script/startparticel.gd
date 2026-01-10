extends Label

func _ready():
	var childre:Array[Node]  = get_children()
	var Particels:Array[GPUParticles2D]
	for child in childre:
		Particels.append(child)
	for par in Particels:
		par.emitting = true
		par.position = self.size /2 
	
