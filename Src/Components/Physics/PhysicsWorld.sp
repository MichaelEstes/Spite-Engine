package PhysicsComponent

import Fiber
import ECS
import Jolt
import Physics
import Transform

enum PhysicsLayers: uint32
{
    NonMoving,
    Moving
}

enum PhysicsBroadPhaseLayers: uint32
{
    NonMoving,
    Moving
}

state PhysicsWorld
{
    system: *JPH_PhysicsSystem,
    bodyInterface: *JPH_BodyInterface,
    objectLayerPairFilterTable: *JPH_ObjectLayerPairFilter,
    broadPhaseLayerInterfaceTable: *JPH_BroadPhaseLayerInterface,
    objectVsBroadPhaseLayerFilter: *JPH_ObjectVsBroadPhaseLayerFilter,

    jobSystem: *JPH_JobSystem,

    maxBodies: uint32 = 65536,
    numBodyMutexes: uint32 = 0,
    maxBodyPairs: uint32 = 65536,
    maxContactConstraints: uint32 = 65536
}

QueuePhysicsJob(scene: *Scene, job: ::(*void), arg: *void)
{
    Fiber.AddJob(job, arg);
}

QueuePhysicsJobs(scene: *Scene, job: ::(*void), args: **void, count: uint32)
{
    Fiber.AddJobMultipleData(job, make_array_from(#sizeof *void, count, args as *byte));
}

PhysicsWorldComponent := ECS.RegisterComponent<PhysicsWorld>(
	ComponentKind.Singleton,
    ::(entity: Entity, world: *PhysicsWorld, scene: Scene) {

	},
    ::(entity: Entity, world: *PhysicsWorld, scene: Scene) {
        if (world.system)
        {
            JPH_PhysicsSystem_Destroy(world.system);
            JPH_JobSystem_Destroy(world.jobSystem);
        }

	    world.objectLayerPairFilterTable = JPH_ObjectLayerPairFilterTable_Create(2);
	    JPH_ObjectLayerPairFilterTable_EnableCollision(world.objectLayerPairFilterTable, PhysicsLayers.NonMoving, PhysicsLayers.Moving);
	    JPH_ObjectLayerPairFilterTable_EnableCollision(world.objectLayerPairFilterTable, PhysicsLayers.Moving, PhysicsLayers.NonMoving);
	    JPH_ObjectLayerPairFilterTable_EnableCollision(world.objectLayerPairFilterTable, PhysicsLayers.Moving, PhysicsLayers.Moving);

	    world.broadPhaseLayerInterfaceTable = JPH_BroadPhaseLayerInterfaceTable_Create(2, 2);
	    JPH_BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(
            world.broadPhaseLayerInterfaceTable, PhysicsLayers.NonMoving, PhysicsBroadPhaseLayers.NonMoving
        );
	    JPH_BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(
            world.broadPhaseLayerInterfaceTable, PhysicsLayers.Moving, PhysicsBroadPhaseLayers.Moving
        );

	    world.objectVsBroadPhaseLayerFilter = JPH_ObjectVsBroadPhaseLayerFilterTable_Create(
            world.broadPhaseLayerInterfaceTable, 2, world.objectLayerPairFilterTable, 2
        );

        systemSettings := JPH_PhysicsSystemSettings();
        systemSettings.maxBodies = world.maxBodies;
        systemSettings.numBodyMutexes = world.numBodyMutexes;
        systemSettings.maxBodyPairs = world.maxBodyPairs;
        systemSettings.maxContactConstraints = world.maxContactConstraints;
        systemSettings.broadPhaseLayerInterface = world.broadPhaseLayerInterfaceTable;
        systemSettings.objectLayerPairFilter = world.objectLayerPairFilterTable;
        systemSettings.objectVsBroadPhaseLayerFilter = world.objectVsBroadPhaseLayerFilter;
        world.system = JPH_PhysicsSystem_Create(systemSettings@);
	    world.bodyInterface = JPH_PhysicsSystem_GetBodyInterface(world.system);

        world.jobSystem = JPH_JobSystemCallback_CreateParams(
            scene@
            QueuePhysicsJob,
            QueuePhysicsJobs,
            fibers.fiberCount,
            0
        );
	}
);

PhysicsSystem := ECS.RegisterSystem(::(scene: Scene, dt: float) {
    if (!scene.HasSingleton<PhysicsWorld>()) return;

    physicsWorld := scene.GetSingleton<PhysicsWorld>();
    bodyInterface := physicsWorld.bodyInterface;

    JPH_PhysicsSystem_Update(physicsWorld.system, dt, 1, physicsWorld.jobSystem);

    for (ec in scene.Iterate<PhysicsBody>())
    {
        entity := ec.entity;
        body := ec.component;
        if (!JPH_BodyInterface_IsActive(bodyInterface, body.id)) continue;

        transform := scene.GetComponent<Transform>(entity);
        JPH_BodyInterface_GetPositionAndRotation(
            bodyInterface, body.id, transform.position@, transform.rotation@
        );
        SetTransformDirty(scene, entity);
    }
}, SystemStep.Fixed);