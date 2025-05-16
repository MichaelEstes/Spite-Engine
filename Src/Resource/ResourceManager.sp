package Resource

import HandleSet

state ResourceManager
{
	resourceKeyToHandle := Map<string, ResourceHandle>(),
	resources := HandleSet<Resource>()
}