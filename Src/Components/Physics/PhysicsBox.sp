package PhysicsComponent

import ECS
import Jolt
import Physics
import Vec

state PhysicsBox
{
    shape: *JPH_BoxShape,
    extents: Vec3 = Vec3(0.5, 0.5, 0.5),
    motionType: MotionMode = MotionMode.Dynamic,
}

PhysicsBoxComponent := ECS.RegisterComponent<PhysicsBox>(
	ComponentKind.Sparse,
    ::(entity: Entity, box: *PhysicsBox, scene: Scene) {

	},
    ::(entity: Entity, box: *PhysicsBox, scene: Scene) {
        layer := PhysicsLayers.Moving;
        activation := ActivationMode.Activate;
        if (box.motionType == MotionMode.Static)
        {
            layer = PhysicsLayers.NonMoving;
            activation = ActivationMode.DontActivate;
        }

		box.shape = JPH_BoxShape_Create(box.extents@, JPH_DEFAULT_CONVEX_RADIUS);

        CreatePhysicsBody(
            scene@, entity, box.shape as *JPH_Shape,
            box.motionType, layer,
            activation
        );
	}
);
