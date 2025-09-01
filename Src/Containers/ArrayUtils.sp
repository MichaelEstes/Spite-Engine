package ArrayUtils


[Count]Type FilledArray<Count, Type>(value: Type)
{
	arr := [Count]Type;

	for (i .. Count)
	{
		arr[i] = value;
	}

	return arr;
}