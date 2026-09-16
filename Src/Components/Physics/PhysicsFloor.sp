package PhysicsComponent

import ECS
import Jolt
import Physics
import Vec

state PhysicsFloor
{
    shape: *JPH_BoxShape,
    extents: Vec2 
}

PhysicsFloorComponent := ECS.RegisterComponent<PhysicsFloor>(
	ComponentKind.Sparse,
    ::(entity: Entity, floor: *PhysicsFloor, scene: Scene) {

	},
    ::(entity: Entity, floor: *PhysicsFloor, scene: Scene) {
        halfExtents := Vec3(floor.extents.x, 1.0, floor.extents.y);
		floor.shape = JPH_BoxShape_Create(halfExtents@, 0.05);

        CreatePhysicsBody(
            scene@, entity, floor.shape as *JPH_Shape,
            MotionMode.Static, PhysicsLayers.NonMoving,
            ActivationMode.DontActivate
        );
	}
);