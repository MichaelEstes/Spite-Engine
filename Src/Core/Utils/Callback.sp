package Callback

state Callback<Func, Type 
	: where(func: Func, data: Type) 
	{
		funcType := #typeof Func;
		dataType := #typeof Type;

		assert funcType.IsFunction();
		params := funcType.GetFunctionParams();
		assert params[params.count - 1] == dataType;
	}>
{
	Invoke: Func,
	data: Type
}

Callback::(func: Func, data: Type)
{
	this.Invoke = func;
	this.data = data;
}