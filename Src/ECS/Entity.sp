package ECS

NullEntityID := uint32(0);
NullEntity := Entity(NullEntityID);

state Entity
{
	[value]
	id: uint32,
}

Entity::(id: uint32) => this.id = id;

bool Entity::operator::!()
{
	return this.id == NullEntityID;
}

state EntityComponent<Type>
{
	entity: Entity,
	component: *Type
}

EntityComponent::(entity: Entity, component: *Type)
{
	this.entity = entity;
	this.component = component;
}

state SceneEntity
{
	scene: *Scene,
	entity: Entity
}

SceneEntity::(scene: *Scene, entity: Entity)
{
	this.scene = scene;
	this.entity = entity;
}
