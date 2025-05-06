package Render

import Vec

state TextureMap
{
	texture: Texture,
	offset: Vec2,
	scale: Vec2
}

state Material
{
	color: TextureMap
}