package PhysicsComponent

import ECS
import Jolt
import Physics
import Transform

state PhysicsBody
{
    id: uint32
}

PhysicsBodyComponent := ECS.RegisterComponent<PhysicsBody>(
	ComponentKind.Sparse,
    ::(entity: Entity, box: *PhysicsBody, scene: Scene) {

	},
    ::(entity: Entity, box: *PhysicsBody, scene: Scene) {

	}
);

CreatePhysicsBody(scene: *Scene, entity: Entity,
                  shape: *JPH_Shape,
                  motionMode: MotionMode, layer: uint32,
                  activation: ActivationMode
)
{
    transform := scene.GetComponent<Transform>(entity);
    assert transform, "CreatePhysicsBody :: No Transform created for entity";
    
    assert scene.HasSingleton<PhysicsWorld>(), "CreatePhysicsBody :: No PhysicsWorld created for scene";
    physicsWorld := scene.GetSingleton<PhysicsWorld>();
    bodyInterface := physicsWorld.bodyInterface;

    existing := scene.GetComponentDirect<PhysicsBody>(entity, PhysicsBodyComponent);
    if (existing)
    {
        JPH_BodyInterface_RemoveAndDestroyBody(bodyInterface, existing.id);
    }

    settings := JPH_BodyCreationSettings_Create3(
		shape,
		transform.position@,
		transform.rotation@,
		motionMode,
		layer
    );

    bodyID := JPH_BodyInterface_CreateAndAddBody(
        bodyInterface, settings, activation
    );

    scene.SetComponentDirect<PhysicsBody>(entity, { bodyID }, PhysicsBodyComponent);

    JPH_BodyCreationSettings_Destroy(settings);
}