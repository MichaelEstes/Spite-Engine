package ECS

NullEntityID := uint32(0);
NullEntityVersion := uint16(0);
NullEntity := Entity(NullEntityID, NullEntityVersion);

state Entity
{
	[value]
	id: uint32,
	version: uint16,
	layers: uint16
}

Entity::(id: uint32, version: uint16)
{
	this.id = id;
	this.version = version;
}

bool Entity::operator::!()
{
	return this.id == NullEntityID;
}

state EntityIDComponent<Type>
{
	component: *Type,
	entityID: uint32
}

EntityIDComponent::(entityID: uint32, component: *Type)
{
	this.entityID = entityID;
	this.component = component;
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
