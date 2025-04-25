package Color

state Color
{
	r: float32,
	g: float32,
	b: float32,
	a: float32 = 1.0
}

Color::(r: float32, g: float32, b: float32, a: float32) 
{
	this.r = r;
	this.g = g;
	this.b = b;
	this.a = a;
}