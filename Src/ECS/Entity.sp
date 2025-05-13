package Entity

nullEntityID := uint32(0);
invalidEntityID := uint32(-1);

nullEntity := Entity(nullEntityID);

state EntityComponent<Type>
{
	entity: Entity,
	component: *Type
}

state Entity
{
	[value]
	id: uint32,
}

Entity::(id: uint32) => this.id = id;

bool Entity::operator::!()
{
	return this.id == nullEntityID;
}
