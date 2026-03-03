shader_type canvas_item;


uniform vec2 deformation = vec2(0, 0);
uniform vec2 tileSize = vec2(32.0, 32.0);
void vertex() {
	vec2 world_pos;
	vec2 pointInTileMap;
    world_pos = (MODEL_MATRIX *vec4(VERTEX,0.0,1.0)).xy;
	float xValue;
	float yValue;
	if (VERTEX_ID == 0)
	{
		xValue = - tileSize.x/2.0;
		yValue =  + tileSize.y/2.0;
	}
	else if (VERTEX_ID == 1)
	{
		xValue = - tileSize.x/2.0;
		yValue = - tileSize.y/2.0;
	}
	else if (VERTEX_ID == 2)
	{
		xValue =  + tileSize.x/2.0;
		yValue =  - tileSize.y/2.0;
	}
	else if (VERTEX_ID == 3)
	{
		xValue =  + tileSize.x/2.0;
		yValue =  + tileSize.y/2.0;
	}
	VERTEX.x += (xValue*deformation.x);
	VERTEX.y += (yValue*deformation.y);

}

