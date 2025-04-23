package XML


state XMLAttribute
{
	key: string,
	value: string,
}

state XMLTag
{
	tag: string,
	attributes: []XMLAttribute,
	children: []XMLElement
}

state XMLContent
{
	content: string
}

enum XMLElementKind
{
	Tag,
	Content,
	Comment,
	Prolog
}

state XMLElement
{
	kind: XMLElementKind
}

state XML
{
	declaration: XMLElement,
	root: XMLElement
}

bool IsXMLWhitespace(char: byte)
{
	return char == byte(0x20) || char == byte(0x09) || char == byte(0x0A) || char == byte(0x0D);
}

XMLEatWhitespace(view: StringView)
{
	while (IsXMLWhitespace(view[0]~)) view.Increment();
}

XML ParseXML(str: string)
{
	xml := XML();
	view := StringView(str);
	XMLEatWhitespace(view);


	return xml;
}

ParseXMLDeclaration(view: StringView, xml: XML)
{
	startCount := view.count;
	start := view[0];
	if (view.StartsWith("<"))
	{
		view.Increment();
		XMLEatWhitespace(view);
		
		if (view.StartsWith("?"))
		{

		}
		else
		{
			view.count = startCount;
			view.view = start;
		}
	}
}

