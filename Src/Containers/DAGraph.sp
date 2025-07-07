package DAGraph

import Array

state DANode<Data>
{
	data: Data,

}

state DAGraph<Data>
{
	first: *DAGNode<Data>,
}