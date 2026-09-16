package PhysicsComponent

import ECS
import Jolt
import Physics
import Vec

state PhysicsSphere
{
    shape: *JPH_SphereShape,
    radius: float32 = 1.0,
    motionType: MotionMode = MotionMode.Dynamic,
}

PhysicsSphereComponent := ECS.RegisterComponent<PhysicsSphere>(
	ComponentKind.Sparse,
    ::(entity: Entity, sphere: *PhysicsSphere, scene: Scene) {

	},
    ::(entity: Entity, sphere: *PhysicsSphere, scene: Scene) {
        layer := PhysicsLayers.Moving;
        activation := ActivationMode.Activate;
        if (sphere.motionType == MotionMode.Static)
        {
            layer = PhysicsLayers.NonMoving;
            activation = ActivationMode.DontActivate;
        }

		sphere.shape = JPH_SphereShape_Create(sphere.radius);

        CreatePhysicsBody(
            scene@, entity, sphere.shape as *JPH_Shape,
            sphere.motionType, layer,
            activation
        );
	}
);
