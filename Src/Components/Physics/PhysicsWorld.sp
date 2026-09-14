package PhysicsComponent

state PhysicsWorld
{
    system: *JPH_PhysicsSystem,

    maxBodies: uint32,
    maxBodyPairs: uint32,
    maxContactConstraints: uint32
}

PhysicsWorldComponent := ECS.RegisterComponent<PhysicsWorld>(
	ComponentKind.Singleton,
    ::(entity: Entity, world: *PhysicsWorld, scene: Scene) {

	},
    ::(entity: Entity, world: *PhysicsWorld, scene: Scene) {

	}
);