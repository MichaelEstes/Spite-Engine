package Common

import Vec

state Color
{
	r: float32,
	g: float32,
	b: float32,
	a: float32,
}

Color::(r: float32, g: float32, b: float32, a: float32) 
{
	this.r = r;
	this.g = g;
	this.b = b;
	this.a = a;
}

[4]ubyte Color::AsByteArr()
{
	return ubyte:[
		(this.r * float32(255.0)) as ubyte,
		(this.g * float32(255.0)) as ubyte,
		(this.b * float32(255.0)) as ubyte,
		(this.a * float32(255.0)) as ubyte
	];
}