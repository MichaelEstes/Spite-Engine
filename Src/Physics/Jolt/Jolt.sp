package Jolt

extern
{
	#link windows "./extern/joltc";

	*JPH_JobSystem JPH_JobSystemThreadPool_Create(config: *JobSystemThreadPoolConfig);
	*JPH_JobSystem JPH_JobSystemCallback_Create(config: *JPH_JobSystemConfig);
	*JPH_JobSystem JPH_JobSystemCallback_CreateParams(
		context: *void, 
		queueJob: ::(*void, ::(*void), *void),
		queueJobs: ::(*void, ::(*void), **void, uint32),
		maxConcurrency: uint32, maxBarriers: uint32
	);
	void JPH_JobSystem_Destroy(jobSystem: *JPH_JobSystem);
	bool JPH_Init();
	void JPH_Shutdown();
	void JPH_SetTraceHandler(handler: ::(*byte));
	void JPH_SetAssertFailureHandler(handler: ::());
	void JPH_CollideShapeResult_FreeMembers(result: *JPH_CollideShapeResult);
	void JPH_CollisionEstimationResult_FreeMembers(result: *JPH_CollisionEstimationResult);
	void JPH_BroadPhaseLayerInterface_Destroy(bpInterface: *JPH_BroadPhaseLayerInterface);
	*JPH_BroadPhaseLayerInterface JPH_BroadPhaseLayerInterfaceMask_Create(numBroadPhaseLayers: uint32);
	void JPH_BroadPhaseLayerInterfaceMask_ConfigureLayer(bpInterface: *JPH_BroadPhaseLayerInterface, broadPhaseLayer: ubyte, groupsToInclude: uint32, groupsToExclude: uint32);
	*JPH_BroadPhaseLayerInterface JPH_BroadPhaseLayerInterfaceTable_Create(numObjectLayers: uint32, numBroadPhaseLayers: uint32);
	void JPH_BroadPhaseLayerInterfaceTable_MapObjectToBroadPhaseLayer(bpInterface: *JPH_BroadPhaseLayerInterface, objectLayer: uint32, broadPhaseLayer: ubyte);
	void JPH_ObjectLayerPairFilter_Destroy(filter: *JPH_ObjectLayerPairFilter);
	*JPH_ObjectLayerPairFilter JPH_ObjectLayerPairFilterMask_Create();
	uint32 JPH_ObjectLayerPairFilterMask_GetObjectLayer(group: uint32, mask: uint32);
	uint32 JPH_ObjectLayerPairFilterMask_GetGroup(layer: uint32);
	uint32 JPH_ObjectLayerPairFilterMask_GetMask(layer: uint32);
	*JPH_ObjectLayerPairFilter JPH_ObjectLayerPairFilterTable_Create(numObjectLayers: uint32);
	void JPH_ObjectLayerPairFilterTable_DisableCollision(objectFilter: *JPH_ObjectLayerPairFilter, layer1: uint32, layer2: uint32);
	void JPH_ObjectLayerPairFilterTable_EnableCollision(objectFilter: *JPH_ObjectLayerPairFilter, layer1: uint32, layer2: uint32);
	bool JPH_ObjectLayerPairFilterTable_ShouldCollide(objectFilter: *JPH_ObjectLayerPairFilter, layer1: uint32, layer2: uint32);
	void JPH_ObjectVsBroadPhaseLayerFilter_Destroy(filter: *JPH_ObjectVsBroadPhaseLayerFilter);
	*JPH_ObjectVsBroadPhaseLayerFilter JPH_ObjectVsBroadPhaseLayerFilterMask_Create(broadPhaseLayerInterface: *JPH_BroadPhaseLayerInterface);
	*JPH_ObjectVsBroadPhaseLayerFilter JPH_ObjectVsBroadPhaseLayerFilterTable_Create(broadPhaseLayerInterface: *JPH_BroadPhaseLayerInterface, numBroadPhaseLayers: uint32, objectLayerPairFilter: *JPH_ObjectLayerPairFilter, numObjectLayers: uint32);
	void JPH_DrawSettings_InitDefault(settings: *JPH_DrawSettings);
	*JPH_PhysicsSystem JPH_PhysicsSystem_Create(settings: *JPH_PhysicsSystemSettings);
	void JPH_PhysicsSystem_Destroy(system: *JPH_PhysicsSystem);
	void JPH_PhysicsSystem_SetPhysicsSettings(system: *JPH_PhysicsSystem, settings: *JPH_PhysicsSettings);
	void JPH_PhysicsSystem_GetPhysicsSettings(system: *JPH_PhysicsSystem, result: *JPH_PhysicsSettings);
	void JPH_PhysicsSystem_OptimizeBroadPhase(system: *JPH_PhysicsSystem);
	JPH_PhysicsUpdateError JPH_PhysicsSystem_Update(system: *JPH_PhysicsSystem, deltaTime: float32, collisionSteps: int32, jobSystem: *JPH_JobSystem);
	*JPH_BodyInterface JPH_PhysicsSystem_GetBodyInterface(system: *JPH_PhysicsSystem);
	*JPH_BodyInterface JPH_PhysicsSystem_GetBodyInterfaceNoLock(system: *JPH_PhysicsSystem);
	*JPH_BodyLockInterface JPH_PhysicsSystem_GetBodyLockInterface(system: *JPH_PhysicsSystem);
	*JPH_BodyLockInterface JPH_PhysicsSystem_GetBodyLockInterfaceNoLock(system: *JPH_PhysicsSystem);
	*JPH_BroadPhaseQuery JPH_PhysicsSystem_GetBroadPhaseQuery(system: *JPH_PhysicsSystem);
	*JPH_NarrowPhaseQuery JPH_PhysicsSystem_GetNarrowPhaseQuery(system: *JPH_PhysicsSystem);
	*JPH_NarrowPhaseQuery JPH_PhysicsSystem_GetNarrowPhaseQueryNoLock(system: *JPH_PhysicsSystem);
	void JPH_PhysicsSystem_SetContactListener(system: *JPH_PhysicsSystem, listener: *JPH_ContactListener);
	void JPH_PhysicsSystem_SetBodyActivationListener(system: *JPH_PhysicsSystem, listener: *JPH_BodyActivationListener);
	void JPH_PhysicsSystem_SetSimShapeFilter(system: *JPH_PhysicsSystem, filter: *JPH_SimShapeFilter);
	bool JPH_PhysicsSystem_WereBodiesInContact(system: *JPH_PhysicsSystem, body1: uint32, body2: uint32);
	uint32 JPH_PhysicsSystem_GetNumBodies(system: *JPH_PhysicsSystem);
	uint32 JPH_PhysicsSystem_GetNumActiveBodies(system: *JPH_PhysicsSystem, type: JPH_BodyType);
	uint32 JPH_PhysicsSystem_GetMaxBodies(system: *JPH_PhysicsSystem);
	uint32 JPH_PhysicsSystem_GetNumConstraints(system: *JPH_PhysicsSystem);
	void JPH_PhysicsSystem_SetGravity(system: *JPH_PhysicsSystem, value: *JPH_Vec3);
	void JPH_PhysicsSystem_GetGravity(system: *JPH_PhysicsSystem, result: *JPH_Vec3);
	void JPH_PhysicsSystem_AddConstraint(system: *JPH_PhysicsSystem, constraint: *JPH_Constraint);
	void JPH_PhysicsSystem_RemoveConstraint(system: *JPH_PhysicsSystem, constraint: *JPH_Constraint);
	void JPH_PhysicsSystem_AddConstraints(system: *JPH_PhysicsSystem, constraints: **JPH_Constraint, count: uint32);
	void JPH_PhysicsSystem_RemoveConstraints(system: *JPH_PhysicsSystem, constraints: **JPH_Constraint, count: uint32);
	void JPH_PhysicsSystem_AddStepListener(system: *JPH_PhysicsSystem, listener: *JPH_PhysicsStepListener);
	void JPH_PhysicsSystem_RemoveStepListener(system: *JPH_PhysicsSystem, listener: *JPH_PhysicsStepListener);
	void JPH_PhysicsSystem_GetBodies(system: *JPH_PhysicsSystem, ids: *uint32, count: uint32);
	void JPH_PhysicsSystem_GetActiveBodies(system: *JPH_PhysicsSystem, type: JPH_BodyType, ids: *uint32, count: uint32);
	*uint32 JPH_PhysicsSystem_GetActiveBodiesUnsafe(system: *JPH_PhysicsSystem, type: JPH_BodyType);
	void JPH_PhysicsSystem_GetConstraints(system: *JPH_PhysicsSystem, constraints: **JPH_Constraint, count: uint32);
	void JPH_PhysicsSystem_ActivateBodiesInAABox(system: *JPH_PhysicsSystem, box: *JPH_AABox, layer: uint32);
	void JPH_PhysicsSystem_DrawBodies(system: *JPH_PhysicsSystem, settings: *JPH_DrawSettings, renderer: *JPH_DebugRenderer, bodyFilter: *JPH_BodyDrawFilter);
	void JPH_PhysicsSystem_DrawConstraints(system: *JPH_PhysicsSystem, renderer: *JPH_DebugRenderer);
	void JPH_PhysicsSystem_DrawConstraintLimits(system: *JPH_PhysicsSystem, renderer: *JPH_DebugRenderer);
	void JPH_PhysicsSystem_DrawConstraintReferenceFrame(system: *JPH_PhysicsSystem, renderer: *JPH_DebugRenderer);
	void JPH_PhysicsStepListener_SetProcs(procs: *JPH_PhysicsStepListener_Procs);
	*JPH_PhysicsStepListener JPH_PhysicsStepListener_Create(userData: *void);
	void JPH_PhysicsStepListener_Destroy(listener: *JPH_PhysicsStepListener);
	float32 JPH_Math_Sin(value: float32);
	float32 JPH_Math_Cos(value: float32);
	void JPH_Quat_FromTo(from: *JPH_Vec3, to: *JPH_Vec3, quat: *JPH_Quat);
	void JPH_Quat_GetAxisAngle(quat: *JPH_Quat, outAxis: *JPH_Vec3, outAngle: *float32);
	void JPH_Quat_GetEulerAngles(quat: *JPH_Quat, result: *JPH_Vec3);
	void JPH_Quat_RotateAxisX(quat: *JPH_Quat, result: *JPH_Vec3);
	void JPH_Quat_RotateAxisY(quat: *JPH_Quat, result: *JPH_Vec3);
	void JPH_Quat_RotateAxisZ(quat: *JPH_Quat, result: *JPH_Vec3);
	void JPH_Quat_Inversed(quat: *JPH_Quat, result: *JPH_Quat);
	void JPH_Quat_GetPerpendicular(quat: *JPH_Quat, result: *JPH_Quat);
	float32 JPH_Quat_GetRotationAngle(quat: *JPH_Quat, axis: *JPH_Vec3);
	void JPH_Quat_FromEulerAngles(angles: *JPH_Vec3, result: *JPH_Quat);
	void JPH_Quat_Add(q1: *JPH_Quat, q2: *JPH_Quat, result: *JPH_Quat);
	void JPH_Quat_Subtract(q1: *JPH_Quat, q2: *JPH_Quat, result: *JPH_Quat);
	void JPH_Quat_Multiply(q1: *JPH_Quat, q2: *JPH_Quat, result: *JPH_Quat);
	void JPH_Quat_MultiplyScalar(q: *JPH_Quat, scalar: float32, result: *JPH_Quat);
	void JPH_Quat_DivideScalar(q: *JPH_Quat, scalar: float32, result: *JPH_Quat);
	void JPH_Quat_Dot(q1: *JPH_Quat, q2: *JPH_Quat, result: *float32);
	void JPH_Quat_Conjugated(quat: *JPH_Quat, result: *JPH_Quat);
	void JPH_Quat_GetTwist(quat: *JPH_Quat, axis: *JPH_Vec3, result: *JPH_Quat);
	void JPH_Quat_GetSwingTwist(quat: *JPH_Quat, outSwing: *JPH_Quat, outTwist: *JPH_Quat);
	void JPH_Quat_Lerp(from: *JPH_Quat, to: *JPH_Quat, fraction: float32, result: *JPH_Quat);
	void JPH_Quat_Slerp(from: *JPH_Quat, to: *JPH_Quat, fraction: float32, result: *JPH_Quat);
	void JPH_Quat_Rotate(quat: *JPH_Quat, vec: *JPH_Vec3, result: *JPH_Vec3);
	void JPH_Quat_InverseRotate(quat: *JPH_Quat, vec: *JPH_Vec3, result: *JPH_Vec3);
	void JPH_Vec3_AxisX(result: *JPH_Vec3);
	void JPH_Vec3_AxisY(result: *JPH_Vec3);
	void JPH_Vec3_AxisZ(result: *JPH_Vec3);
	bool JPH_Vec3_IsClose(v1: *JPH_Vec3, v2: *JPH_Vec3, maxDistSq: float32);
	bool JPH_Vec3_IsNearZero(v: *JPH_Vec3, maxDistSq: float32);
	bool JPH_Vec3_IsNormalized(v: *JPH_Vec3, tolerance: float32);
	bool JPH_Vec3_IsNaN(v: *JPH_Vec3);
	void JPH_Vec3_Negate(v: *JPH_Vec3, result: *JPH_Vec3);
	void JPH_Vec3_Normalized(v: *JPH_Vec3, result: *JPH_Vec3);
	void JPH_Vec3_Cross(v1: *JPH_Vec3, v2: *JPH_Vec3, result: *JPH_Vec3);
	void JPH_Vec3_Abs(v: *JPH_Vec3, result: *JPH_Vec3);
	float32 JPH_Vec3_Length(v: *JPH_Vec3);
	float32 JPH_Vec3_LengthSquared(v: *JPH_Vec3);
	void JPH_Vec3_DotProduct(v1: *JPH_Vec3, v2: *JPH_Vec3, result: *float32);
	void JPH_Vec3_Normalize(v: *JPH_Vec3, result: *JPH_Vec3);
	void JPH_Vec3_Add(v1: *JPH_Vec3, v2: *JPH_Vec3, result: *JPH_Vec3);
	void JPH_Vec3_Subtract(v1: *JPH_Vec3, v2: *JPH_Vec3, result: *JPH_Vec3);
	void JPH_Vec3_Multiply(v1: *JPH_Vec3, v2: *JPH_Vec3, result: *JPH_Vec3);
	void JPH_Vec3_MultiplyScalar(v: *JPH_Vec3, scalar: float32, result: *JPH_Vec3);
	void JPH_Vec3_MultiplyMatrix(left: *JPH_Mat4, right: *JPH_Vec3, result: *JPH_Vec3);
	void JPH_Vec3_Divide(v1: *JPH_Vec3, v2: *JPH_Vec3, result: *JPH_Vec3);
	void JPH_Vec3_DivideScalar(v: *JPH_Vec3, scalar: float32, result: *JPH_Vec3);
	void JPH_Vec3_GetNormalizedPerpendicular(v: *JPH_Vec3, result: *JPH_Vec3);
	void JPH_Mat4_Add(m1: *JPH_Mat4, m2: *JPH_Mat4, result: *JPH_Mat4);
	void JPH_Mat4_Subtract(m1: *JPH_Mat4, m2: *JPH_Mat4, result: *JPH_Mat4);
	void JPH_Mat4_Multiply(m1: *JPH_Mat4, m2: *JPH_Mat4, result: *JPH_Mat4);
	void JPH_Mat4_MultiplyScalar(m: *JPH_Mat4, scalar: float32, result: *JPH_Mat4);
	void JPH_Mat4_Zero(result: *JPH_Mat4);
	void JPH_Mat4_Identity(result: *JPH_Mat4);
	void JPH_Mat4_Rotation(result: *JPH_Mat4, rotation: *JPH_Quat);
	void JPH_Mat4_Rotation2(result: *JPH_Mat4, axis: *JPH_Vec3, angle: float32);
	void JPH_Mat4_Translation(result: *JPH_Mat4, translation: *JPH_Vec3);
	void JPH_Mat4_RotationTranslation(result: *JPH_Mat4, rotation: *JPH_Quat, translation: *JPH_Vec3);
	void JPH_Mat4_InverseRotationTranslation(result: *JPH_Mat4, rotation: *JPH_Quat, translation: *JPH_Vec3);
	void JPH_Mat4_Scale(result: *JPH_Mat4, scale: *JPH_Vec3);
	void JPH_Mat4_Transposed(m: *JPH_Mat4, result: *JPH_Mat4);
	void JPH_Mat4_Inversed(matrix: *JPH_Mat4, result: *JPH_Mat4);
	void JPH_Mat4_GetAxisX(matrix: *JPH_Mat4, result: *JPH_Vec3);
	void JPH_Mat4_GetAxisY(matrix: *JPH_Mat4, result: *JPH_Vec3);
	void JPH_Mat4_GetAxisZ(matrix: *JPH_Mat4, result: *JPH_Vec3);
	void JPH_Mat4_GetTranslation(matrix: *JPH_Mat4, result: *JPH_Vec3);
	void JPH_Mat4_GetQuaternion(matrix: *JPH_Mat4, result: *JPH_Quat);
	*JPH_PhysicsMaterial JPH_PhysicsMaterial_Create(name: *byte, color: uint32);
	void JPH_PhysicsMaterial_Destroy(material: *JPH_PhysicsMaterial);
	*byte JPH_PhysicsMaterial_GetDebugName(material: *JPH_PhysicsMaterial);
	uint32 JPH_PhysicsMaterial_GetDebugColor(material: *JPH_PhysicsMaterial);
	void JPH_GroupFilter_Destroy(groupFilter: *JPH_GroupFilter);
	bool JPH_GroupFilter_CanCollide(groupFilter: *JPH_GroupFilter, group1: *JPH_CollisionGroup, group2: *JPH_CollisionGroup);
	*JPH_GroupFilterTable JPH_GroupFilterTable_Create(numSubGroups: uint32);
	void JPH_GroupFilterTable_DisableCollision(table: *JPH_GroupFilterTable, subGroup1: uint32, subGroup2: uint32);
	void JPH_GroupFilterTable_EnableCollision(table: *JPH_GroupFilterTable, subGroup1: uint32, subGroup2: uint32);
	bool JPH_GroupFilterTable_IsCollisionEnabled(table: *JPH_GroupFilterTable, subGroup1: uint32, subGroup2: uint32);
	void JPH_ShapeSettings_Destroy(settings: *JPH_ShapeSettings);
	uint64 JPH_ShapeSettings_GetUserData(settings: *JPH_ShapeSettings);
	void JPH_ShapeSettings_SetUserData(settings: *JPH_ShapeSettings, userData: uint64);
	void JPH_Shape_Draw(shape: *JPH_Shape, renderer: *JPH_DebugRenderer, centerOfMassTransform: *JPH_Mat4, scale: *JPH_Vec3, color: uint32, useMaterialColors: bool, drawWireframe: bool);
	void JPH_Shape_Destroy(shape: *JPH_Shape);
	JPH_ShapeType JPH_Shape_GetType(shape: *JPH_Shape);
	JPH_ShapeSubType JPH_Shape_GetSubType(shape: *JPH_Shape);
	uint64 JPH_Shape_GetUserData(shape: *JPH_Shape);
	void JPH_Shape_SetUserData(shape: *JPH_Shape, userData: uint64);
	bool JPH_Shape_MustBeStatic(shape: *JPH_Shape);
	void JPH_Shape_GetCenterOfMass(shape: *JPH_Shape, result: *JPH_Vec3);
	void JPH_Shape_GetLocalBounds(shape: *JPH_Shape, result: *JPH_AABox);
	uint32 JPH_Shape_GetSubShapeIDBitsRecursive(shape: *JPH_Shape);
	void JPH_Shape_GetWorldSpaceBounds(shape: *JPH_Shape, centerOfMassTransform: *JPH_Mat4, scale: *JPH_Vec3, result: *JPH_AABox);
	float32 JPH_Shape_GetInnerRadius(shape: *JPH_Shape);
	void JPH_Shape_GetMassProperties(shape: *JPH_Shape, result: *JPH_MassProperties);
	*JPH_Shape JPH_Shape_GetLeafShape(shape: *JPH_Shape, subShapeID: uint32, remainder: *uint32);
	*JPH_PhysicsMaterial JPH_Shape_GetMaterial(shape: *JPH_Shape, subShapeID: uint32);
	void JPH_Shape_GetSurfaceNormal(shape: *JPH_Shape, subShapeID: uint32, localPosition: *JPH_Vec3, normal: *JPH_Vec3);
	void JPH_Shape_GetSupportingFace(shape: *JPH_Shape, subShapeID: uint32, direction: *JPH_Vec3, scale: *JPH_Vec3, centerOfMassTransform: *JPH_Mat4, outVertices: *JPH_SupportingFace);
	float32 JPH_Shape_GetVolume(shape: *JPH_Shape);
	bool JPH_Shape_IsValidScale(shape: *JPH_Shape, scale: *JPH_Vec3);
	void JPH_Shape_MakeScaleValid(shape: *JPH_Shape, scale: *JPH_Vec3, result: *JPH_Vec3);
	*JPH_Shape JPH_Shape_ScaleShape(shape: *JPH_Shape, scale: *JPH_Vec3);
	bool JPH_Shape_CastRay(shape: *JPH_Shape, origin: *JPH_Vec3, direction: *JPH_Vec3, hit: *JPH_RayCastResult);
	bool JPH_Shape_CastRay2(shape: *JPH_Shape, origin: *JPH_Vec3, direction: *JPH_Vec3, rayCastSettings: *JPH_RayCastSettings, collectorType: JPH_CollisionCollectorType, callback: ::(), userData: *void, shapeFilter: *JPH_ShapeFilter);
	bool JPH_Shape_CollidePoint(shape: *JPH_Shape, point: *JPH_Vec3, shapeFilter: *JPH_ShapeFilter);
	bool JPH_Shape_CollidePoint2(shape: *JPH_Shape, point: *JPH_Vec3, collectorType: JPH_CollisionCollectorType, callback: ::(), userData: *void, shapeFilter: *JPH_ShapeFilter);
	float32 JPH_ConvexShapeSettings_GetDensity(shape: *JPH_ConvexShapeSettings);
	void JPH_ConvexShapeSettings_SetDensity(shape: *JPH_ConvexShapeSettings, value: float32);
	float32 JPH_ConvexShape_GetDensity(shape: *JPH_ConvexShape);
	void JPH_ConvexShape_SetDensity(shape: *JPH_ConvexShape, inDensity: float32);
	*JPH_BoxShapeSettings JPH_BoxShapeSettings_Create(halfExtent: *JPH_Vec3, convexRadius: float32);
	*JPH_BoxShape JPH_BoxShapeSettings_CreateShape(settings: *JPH_BoxShapeSettings);
	*JPH_BoxShape JPH_BoxShape_Create(halfExtent: *JPH_Vec3, convexRadius: float32);
	void JPH_BoxShape_GetHalfExtent(shape: *JPH_BoxShape, halfExtent: *JPH_Vec3);
	float32 JPH_BoxShape_GetConvexRadius(shape: *JPH_BoxShape);
	*JPH_SphereShapeSettings JPH_SphereShapeSettings_Create(radius: float32);
	*JPH_SphereShape JPH_SphereShapeSettings_CreateShape(settings: *JPH_SphereShapeSettings);
	float32 JPH_SphereShapeSettings_GetRadius(settings: *JPH_SphereShapeSettings);
	void JPH_SphereShapeSettings_SetRadius(settings: *JPH_SphereShapeSettings, radius: float32);
	*JPH_SphereShape JPH_SphereShape_Create(radius: float32);
	float32 JPH_SphereShape_GetRadius(shape: *JPH_SphereShape);
	*JPH_PlaneShapeSettings JPH_PlaneShapeSettings_Create(plane: *JPH_Plane, material: *JPH_PhysicsMaterial, halfExtent: float32);
	*JPH_PlaneShape JPH_PlaneShapeSettings_CreateShape(settings: *JPH_PlaneShapeSettings);
	*JPH_PlaneShape JPH_PlaneShape_Create(plane: *JPH_Plane, material: *JPH_PhysicsMaterial, halfExtent: float32);
	void JPH_PlaneShape_GetPlane(shape: *JPH_PlaneShape, result: *JPH_Plane);
	float32 JPH_PlaneShape_GetHalfExtent(shape: *JPH_PlaneShape);
	*JPH_TriangleShapeSettings JPH_TriangleShapeSettings_Create(v1: *JPH_Vec3, v2: *JPH_Vec3, v3: *JPH_Vec3, convexRadius: float32);
	*JPH_TriangleShape JPH_TriangleShapeSettings_CreateShape(settings: *JPH_TriangleShapeSettings);
	*JPH_TriangleShape JPH_TriangleShape_Create(v1: *JPH_Vec3, v2: *JPH_Vec3, v3: *JPH_Vec3, convexRadius: float32);
	float32 JPH_TriangleShape_GetConvexRadius(shape: *JPH_TriangleShape);
	void JPH_TriangleShape_GetVertex1(shape: *JPH_TriangleShape, result: *JPH_Vec3);
	void JPH_TriangleShape_GetVertex2(shape: *JPH_TriangleShape, result: *JPH_Vec3);
	void JPH_TriangleShape_GetVertex3(shape: *JPH_TriangleShape, result: *JPH_Vec3);
	*JPH_CapsuleShapeSettings JPH_CapsuleShapeSettings_Create(halfHeightOfCylinder: float32, radius: float32);
	*JPH_CapsuleShape JPH_CapsuleShapeSettings_CreateShape(settings: *JPH_CapsuleShapeSettings);
	*JPH_CapsuleShape JPH_CapsuleShape_Create(halfHeightOfCylinder: float32, radius: float32);
	float32 JPH_CapsuleShape_GetRadius(shape: *JPH_CapsuleShape);
	float32 JPH_CapsuleShape_GetHalfHeightOfCylinder(shape: *JPH_CapsuleShape);
	*JPH_CylinderShapeSettings JPH_CylinderShapeSettings_Create(halfHeight: float32, radius: float32, convexRadius: float32);
	*JPH_CylinderShape JPH_CylinderShapeSettings_CreateShape(settings: *JPH_CylinderShapeSettings);
	*JPH_CylinderShape JPH_CylinderShape_Create(halfHeight: float32, radius: float32);
	float32 JPH_CylinderShape_GetRadius(shape: *JPH_CylinderShape);
	float32 JPH_CylinderShape_GetHalfHeight(shape: *JPH_CylinderShape);
	*JPH_TaperedCylinderShapeSettings JPH_TaperedCylinderShapeSettings_Create(halfHeightOfTaperedCylinder: float32, topRadius: float32, bottomRadius: float32, convexRadius: float32, material: *JPH_PhysicsMaterial);
	*JPH_TaperedCylinderShape JPH_TaperedCylinderShapeSettings_CreateShape(settings: *JPH_TaperedCylinderShapeSettings);
	float32 JPH_TaperedCylinderShape_GetTopRadius(shape: *JPH_TaperedCylinderShape);
	float32 JPH_TaperedCylinderShape_GetBottomRadius(shape: *JPH_TaperedCylinderShape);
	float32 JPH_TaperedCylinderShape_GetConvexRadius(shape: *JPH_TaperedCylinderShape);
	float32 JPH_TaperedCylinderShape_GetHalfHeight(shape: *JPH_TaperedCylinderShape);
	*JPH_ConvexHullShapeSettings JPH_ConvexHullShapeSettings_Create(points: *JPH_Vec3, pointsCount: uint32, maxConvexRadius: float32);
	*JPH_ConvexHullShape JPH_ConvexHullShapeSettings_CreateShape(settings: *JPH_ConvexHullShapeSettings);
	uint32 JPH_ConvexHullShape_GetNumPoints(shape: *JPH_ConvexHullShape);
	void JPH_ConvexHullShape_GetPoint(shape: *JPH_ConvexHullShape, index: uint32, result: *JPH_Vec3);
	uint32 JPH_ConvexHullShape_GetNumFaces(shape: *JPH_ConvexHullShape);
	uint32 JPH_ConvexHullShape_GetNumVerticesInFace(shape: *JPH_ConvexHullShape, faceIndex: uint32);
	uint32 JPH_ConvexHullShape_GetFaceVertices(shape: *JPH_ConvexHullShape, faceIndex: uint32, maxVertices: uint32, vertices: *uint32);
	*JPH_MeshShapeSettings JPH_MeshShapeSettings_Create(triangles: *JPH_Triangle, triangleCount: uint32);
	*JPH_MeshShapeSettings JPH_MeshShapeSettings_Create2(vertices: *JPH_Vec3, verticesCount: uint32, triangles: *JPH_IndexedTriangle, triangleCount: uint32);
	uint32 JPH_MeshShapeSettings_GetMaxTrianglesPerLeaf(settings: *JPH_MeshShapeSettings);
	void JPH_MeshShapeSettings_SetMaxTrianglesPerLeaf(settings: *JPH_MeshShapeSettings, value: uint32);
	float32 JPH_MeshShapeSettings_GetActiveEdgeCosThresholdAngle(settings: *JPH_MeshShapeSettings);
	void JPH_MeshShapeSettings_SetActiveEdgeCosThresholdAngle(settings: *JPH_MeshShapeSettings, value: float32);
	bool JPH_MeshShapeSettings_GetPerTriangleUserData(settings: *JPH_MeshShapeSettings);
	void JPH_MeshShapeSettings_SetPerTriangleUserData(settings: *JPH_MeshShapeSettings, value: bool);
	JPH_Mesh_Shape_BuildQuality JPH_MeshShapeSettings_GetBuildQuality(settings: *JPH_MeshShapeSettings);
	void JPH_MeshShapeSettings_SetBuildQuality(settings: *JPH_MeshShapeSettings, value: JPH_Mesh_Shape_BuildQuality);
	void JPH_MeshShapeSettings_Sanitize(settings: *JPH_MeshShapeSettings);
	*JPH_MeshShape JPH_MeshShapeSettings_CreateShape(settings: *JPH_MeshShapeSettings);
	uint32 JPH_MeshShape_GetTriangleUserData(shape: *JPH_MeshShape, id: uint32);
	*JPH_HeightFieldShapeSettings JPH_HeightFieldShapeSettings_Create(samples: *float32, offset: *JPH_Vec3, scale: *JPH_Vec3, sampleCount: uint32, materialIndices: *ubyte);
	void JPH_HeightFieldShapeSettings_DetermineMinAndMaxSample(settings: *JPH_HeightFieldShapeSettings, pOutMinValue: *float32, pOutMaxValue: *float32, pOutQuantizationScale: *float32);
	uint32 JPH_HeightFieldShapeSettings_CalculateBitsPerSampleForError(settings: *JPH_HeightFieldShapeSettings, maxError: float32);
	void JPH_HeightFieldShapeSettings_GetOffset(shape: *JPH_HeightFieldShapeSettings, result: *JPH_Vec3);
	void JPH_HeightFieldShapeSettings_SetOffset(settings: *JPH_HeightFieldShapeSettings, value: *JPH_Vec3);
	void JPH_HeightFieldShapeSettings_GetScale(shape: *JPH_HeightFieldShapeSettings, result: *JPH_Vec3);
	void JPH_HeightFieldShapeSettings_SetScale(settings: *JPH_HeightFieldShapeSettings, value: *JPH_Vec3);
	uint32 JPH_HeightFieldShapeSettings_GetSampleCount(settings: *JPH_HeightFieldShapeSettings);
	void JPH_HeightFieldShapeSettings_SetSampleCount(settings: *JPH_HeightFieldShapeSettings, value: uint32);
	float32 JPH_HeightFieldShapeSettings_GetMinHeightValue(settings: *JPH_HeightFieldShapeSettings);
	void JPH_HeightFieldShapeSettings_SetMinHeightValue(settings: *JPH_HeightFieldShapeSettings, value: float32);
	float32 JPH_HeightFieldShapeSettings_GetMaxHeightValue(settings: *JPH_HeightFieldShapeSettings);
	void JPH_HeightFieldShapeSettings_SetMaxHeightValue(settings: *JPH_HeightFieldShapeSettings, value: float32);
	uint32 JPH_HeightFieldShapeSettings_GetBlockSize(settings: *JPH_HeightFieldShapeSettings);
	void JPH_HeightFieldShapeSettings_SetBlockSize(settings: *JPH_HeightFieldShapeSettings, value: uint32);
	uint32 JPH_HeightFieldShapeSettings_GetBitsPerSample(settings: *JPH_HeightFieldShapeSettings);
	void JPH_HeightFieldShapeSettings_SetBitsPerSample(settings: *JPH_HeightFieldShapeSettings, value: uint32);
	float32 JPH_HeightFieldShapeSettings_GetActiveEdgeCosThresholdAngle(settings: *JPH_HeightFieldShapeSettings);
	void JPH_HeightFieldShapeSettings_SetActiveEdgeCosThresholdAngle(settings: *JPH_HeightFieldShapeSettings, value: float32);
	*JPH_HeightFieldShape JPH_HeightFieldShapeSettings_CreateShape(settings: *JPH_HeightFieldShapeSettings);
	uint32 JPH_HeightFieldShape_GetSampleCount(shape: *JPH_HeightFieldShape);
	uint32 JPH_HeightFieldShape_GetBlockSize(shape: *JPH_HeightFieldShape);
	*JPH_PhysicsMaterial JPH_HeightFieldShape_GetMaterial(shape: *JPH_HeightFieldShape, x: uint32, y: uint32);
	void JPH_HeightFieldShape_GetPosition(shape: *JPH_HeightFieldShape, x: uint32, y: uint32, result: *JPH_Vec3);
	bool JPH_HeightFieldShape_IsNoCollision(shape: *JPH_HeightFieldShape, x: uint32, y: uint32);
	bool JPH_HeightFieldShape_ProjectOntoSurface(shape: *JPH_HeightFieldShape, localPosition: *JPH_Vec3, outSurfacePosition: *JPH_Vec3, outSubShapeID: *uint32);
	float32 JPH_HeightFieldShape_GetMinHeightValue(shape: *JPH_HeightFieldShape);
	float32 JPH_HeightFieldShape_GetMaxHeightValue(shape: *JPH_HeightFieldShape);
	*JPH_TaperedCapsuleShapeSettings JPH_TaperedCapsuleShapeSettings_Create(halfHeightOfTaperedCylinder: float32, topRadius: float32, bottomRadius: float32);
	*JPH_TaperedCapsuleShape JPH_TaperedCapsuleShapeSettings_CreateShape(settings: *JPH_TaperedCapsuleShapeSettings);
	float32 JPH_TaperedCapsuleShape_GetTopRadius(shape: *JPH_TaperedCapsuleShape);
	float32 JPH_TaperedCapsuleShape_GetBottomRadius(shape: *JPH_TaperedCapsuleShape);
	float32 JPH_TaperedCapsuleShape_GetHalfHeight(shape: *JPH_TaperedCapsuleShape);
	void JPH_CompoundShapeSettings_AddShape(settings: *JPH_CompoundShapeSettings, position: *JPH_Vec3, rotation: *JPH_Quat, shapeSettings: *JPH_ShapeSettings, userData: uint32);
	void JPH_CompoundShapeSettings_AddShape2(settings: *JPH_CompoundShapeSettings, position: *JPH_Vec3, rotation: *JPH_Quat, shape: *JPH_Shape, userData: uint32);
	uint32 JPH_CompoundShape_GetNumSubShapes(shape: *JPH_CompoundShape);
	void JPH_CompoundShape_GetSubShape(shape: *JPH_CompoundShape, index: uint32, subShape: **JPH_Shape, positionCOM: *JPH_Vec3, rotation: *JPH_Quat, userData: *uint32);
	uint32 JPH_CompoundShape_GetSubShapeIndexFromID(shape: *JPH_CompoundShape, id: uint32, remainder: *uint32);
	*JPH_StaticCompoundShapeSettings JPH_StaticCompoundShapeSettings_Create();
	*JPH_StaticCompoundShape JPH_StaticCompoundShape_Create(settings: *JPH_StaticCompoundShapeSettings);
	*JPH_MutableCompoundShapeSettings JPH_MutableCompoundShapeSettings_Create();
	*JPH_MutableCompoundShape JPH_MutableCompoundShape_Create(settings: *JPH_MutableCompoundShapeSettings);
	uint32 JPH_MutableCompoundShape_AddShape(shape: *JPH_MutableCompoundShape, position: *JPH_Vec3, rotation: *JPH_Quat, child: *JPH_Shape, userData: uint32, index: uint32);
	void JPH_MutableCompoundShape_RemoveShape(shape: *JPH_MutableCompoundShape, index: uint32);
	void JPH_MutableCompoundShape_ModifyShape(shape: *JPH_MutableCompoundShape, index: uint32, position: *JPH_Vec3, rotation: *JPH_Quat);
	void JPH_MutableCompoundShape_ModifyShape2(shape: *JPH_MutableCompoundShape, index: uint32, position: *JPH_Vec3, rotation: *JPH_Quat, newShape: *JPH_Shape);
	void JPH_MutableCompoundShape_AdjustCenterOfMass(shape: *JPH_MutableCompoundShape);
	*JPH_Shape JPH_DecoratedShape_GetInnerShape(shape: *JPH_DecoratedShape);
	*JPH_RotatedTranslatedShapeSettings JPH_RotatedTranslatedShapeSettings_Create(position: *JPH_Vec3, rotation: *JPH_Quat, shapeSettings: *JPH_ShapeSettings);
	*JPH_RotatedTranslatedShapeSettings JPH_RotatedTranslatedShapeSettings_Create2(position: *JPH_Vec3, rotation: *JPH_Quat, shape: *JPH_Shape);
	*JPH_RotatedTranslatedShape JPH_RotatedTranslatedShapeSettings_CreateShape(settings: *JPH_RotatedTranslatedShapeSettings);
	*JPH_RotatedTranslatedShape JPH_RotatedTranslatedShape_Create(position: *JPH_Vec3, rotation: *JPH_Quat, shape: *JPH_Shape);
	void JPH_RotatedTranslatedShape_GetPosition(shape: *JPH_RotatedTranslatedShape, position: *JPH_Vec3);
	void JPH_RotatedTranslatedShape_GetRotation(shape: *JPH_RotatedTranslatedShape, rotation: *JPH_Quat);
	*JPH_ScaledShapeSettings JPH_ScaledShapeSettings_Create(shapeSettings: *JPH_ShapeSettings, scale: *JPH_Vec3);
	*JPH_ScaledShapeSettings JPH_ScaledShapeSettings_Create2(shape: *JPH_Shape, scale: *JPH_Vec3);
	*JPH_ScaledShape JPH_ScaledShapeSettings_CreateShape(settings: *JPH_ScaledShapeSettings);
	*JPH_ScaledShape JPH_ScaledShape_Create(shape: *JPH_Shape, scale: *JPH_Vec3);
	void JPH_ScaledShape_GetScale(shape: *JPH_ScaledShape, result: *JPH_Vec3);
	*JPH_OffsetCenterOfMassShapeSettings JPH_OffsetCenterOfMassShapeSettings_Create(offset: *JPH_Vec3, shapeSettings: *JPH_ShapeSettings);
	*JPH_OffsetCenterOfMassShapeSettings JPH_OffsetCenterOfMassShapeSettings_Create2(offset: *JPH_Vec3, shape: *JPH_Shape);
	*JPH_OffsetCenterOfMassShape JPH_OffsetCenterOfMassShapeSettings_CreateShape(settings: *JPH_OffsetCenterOfMassShapeSettings);
	*JPH_OffsetCenterOfMassShape JPH_OffsetCenterOfMassShape_Create(offset: *JPH_Vec3, shape: *JPH_Shape);
	void JPH_OffsetCenterOfMassShape_GetOffset(shape: *JPH_OffsetCenterOfMassShape, result: *JPH_Vec3);
	*JPH_EmptyShapeSettings JPH_EmptyShapeSettings_Create(centerOfMass: *JPH_Vec3);
	*JPH_EmptyShape JPH_EmptyShapeSettings_CreateShape(settings: *JPH_EmptyShapeSettings);
	*JPH_BodyCreationSettings JPH_BodyCreationSettings_Create();
	*JPH_BodyCreationSettings JPH_BodyCreationSettings_Create2(settings: *JPH_ShapeSettings, position: *JPH_Vec3, rotation: *JPH_Quat, motionType: JPH_MotionType, objectLayer: uint32);
	*JPH_BodyCreationSettings JPH_BodyCreationSettings_Create3(shape: *JPH_Shape, position: *JPH_Vec3, rotation: *JPH_Quat, motionType: JPH_MotionType, objectLayer: uint32);
	void JPH_BodyCreationSettings_Destroy(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_GetPosition(settings: *JPH_BodyCreationSettings, result: *JPH_Vec3);
	void JPH_BodyCreationSettings_SetPosition(settings: *JPH_BodyCreationSettings, value: *JPH_Vec3);
	void JPH_BodyCreationSettings_GetRotation(settings: *JPH_BodyCreationSettings, result: *JPH_Quat);
	void JPH_BodyCreationSettings_SetRotation(settings: *JPH_BodyCreationSettings, value: *JPH_Quat);
	void JPH_BodyCreationSettings_GetLinearVelocity(settings: *JPH_BodyCreationSettings, velocity: *JPH_Vec3);
	void JPH_BodyCreationSettings_SetLinearVelocity(settings: *JPH_BodyCreationSettings, velocity: *JPH_Vec3);
	void JPH_BodyCreationSettings_GetAngularVelocity(settings: *JPH_BodyCreationSettings, velocity: *JPH_Vec3);
	void JPH_BodyCreationSettings_SetAngularVelocity(settings: *JPH_BodyCreationSettings, velocity: *JPH_Vec3);
	uint64 JPH_BodyCreationSettings_GetUserData(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetUserData(settings: *JPH_BodyCreationSettings, value: uint64);
	uint32 JPH_BodyCreationSettings_GetObjectLayer(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetObjectLayer(settings: *JPH_BodyCreationSettings, value: uint32);
	void JPH_BodyCreationSettings_GetCollisionGroup(settings: *JPH_BodyCreationSettings, result: *JPH_CollisionGroup);
	void JPH_BodyCreationSettings_SetCollisionGroup(settings: *JPH_BodyCreationSettings, value: *JPH_CollisionGroup);
	JPH_MotionType JPH_BodyCreationSettings_GetMotionType(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetMotionType(settings: *JPH_BodyCreationSettings, value: JPH_MotionType);
	JPH_AllowedDOFs JPH_BodyCreationSettings_GetAllowedDOFs(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetAllowedDOFs(settings: *JPH_BodyCreationSettings, value: JPH_AllowedDOFs);
	bool JPH_BodyCreationSettings_GetAllowDynamicOrKinematic(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetAllowDynamicOrKinematic(settings: *JPH_BodyCreationSettings, value: bool);
	bool JPH_BodyCreationSettings_GetIsSensor(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetIsSensor(settings: *JPH_BodyCreationSettings, value: bool);
	bool JPH_BodyCreationSettings_GetCollideKinematicVsNonDynamic(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetCollideKinematicVsNonDynamic(settings: *JPH_BodyCreationSettings, value: bool);
	bool JPH_BodyCreationSettings_GetUseManifoldReduction(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetUseManifoldReduction(settings: *JPH_BodyCreationSettings, value: bool);
	bool JPH_BodyCreationSettings_GetApplyGyroscopicForce(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetApplyGyroscopicForce(settings: *JPH_BodyCreationSettings, value: bool);
	JPH_MotionQuality JPH_BodyCreationSettings_GetMotionQuality(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetMotionQuality(settings: *JPH_BodyCreationSettings, value: JPH_MotionQuality);
	bool JPH_BodyCreationSettings_GetEnhancedInternalEdgeRemoval(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetEnhancedInternalEdgeRemoval(settings: *JPH_BodyCreationSettings, value: bool);
	bool JPH_BodyCreationSettings_GetAllowSleeping(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetAllowSleeping(settings: *JPH_BodyCreationSettings, value: bool);
	float32 JPH_BodyCreationSettings_GetFriction(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetFriction(settings: *JPH_BodyCreationSettings, value: float32);
	float32 JPH_BodyCreationSettings_GetRestitution(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetRestitution(settings: *JPH_BodyCreationSettings, value: float32);
	float32 JPH_BodyCreationSettings_GetLinearDamping(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetLinearDamping(settings: *JPH_BodyCreationSettings, value: float32);
	float32 JPH_BodyCreationSettings_GetAngularDamping(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetAngularDamping(settings: *JPH_BodyCreationSettings, value: float32);
	float32 JPH_BodyCreationSettings_GetMaxLinearVelocity(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetMaxLinearVelocity(settings: *JPH_BodyCreationSettings, value: float32);
	float32 JPH_BodyCreationSettings_GetMaxAngularVelocity(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetMaxAngularVelocity(settings: *JPH_BodyCreationSettings, value: float32);
	float32 JPH_BodyCreationSettings_GetGravityFactor(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetGravityFactor(settings: *JPH_BodyCreationSettings, value: float32);
	uint32 JPH_BodyCreationSettings_GetNumVelocityStepsOverride(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetNumVelocityStepsOverride(settings: *JPH_BodyCreationSettings, value: uint32);
	uint32 JPH_BodyCreationSettings_GetNumPositionStepsOverride(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetNumPositionStepsOverride(settings: *JPH_BodyCreationSettings, value: uint32);
	JPH_OverrideMassProperties JPH_BodyCreationSettings_GetOverrideMassProperties(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetOverrideMassProperties(settings: *JPH_BodyCreationSettings, value: JPH_OverrideMassProperties);
	float32 JPH_BodyCreationSettings_GetInertiaMultiplier(settings: *JPH_BodyCreationSettings);
	void JPH_BodyCreationSettings_SetInertiaMultiplier(settings: *JPH_BodyCreationSettings, value: float32);
	void JPH_BodyCreationSettings_GetMassPropertiesOverride(settings: *JPH_BodyCreationSettings, result: *JPH_MassProperties);
	void JPH_BodyCreationSettings_SetMassPropertiesOverride(settings: *JPH_BodyCreationSettings, massProperties: *JPH_MassProperties);
	*JPH_SoftBodySharedSettings JPH_SoftBodySharedSettings_Create();
	void JPH_SoftBodySharedSettings_Destroy(settings: *JPH_SoftBodySharedSettings);
	void JPH_SoftBodySharedSettings_AddVertex(settings: *JPH_SoftBodySharedSettings, vertex: *JPH_SoftVertex);
	void JPH_SoftBodySharedSettings_AddVertices(settings: *JPH_SoftBodySharedSettings, vertices: *JPH_SoftVertex, count: uint32);
	bool JPH_SoftBodySharedSettings_RemoveVertex(settings: *JPH_SoftBodySharedSettings, index: uint32);
	uint32 JPH_SoftBodySharedSettings_GetVertexCount(settings: *JPH_SoftBodySharedSettings);
	bool JPH_SoftBodySharedSettings_GetVertex(settings: *JPH_SoftBodySharedSettings, index: uint32, outVertex: *JPH_SoftVertex);
	void JPH_SoftBodySharedSettings_AddFace(settings: *JPH_SoftBodySharedSettings, face: *JPH_SoftFace);
	void JPH_SoftBodySharedSettings_AddFaces(settings: *JPH_SoftBodySharedSettings, faces: *JPH_SoftFace, count: uint32);
	bool JPH_SoftBodySharedSettings_RemoveFace(settings: *JPH_SoftBodySharedSettings, index: uint32);
	uint32 JPH_SoftBodySharedSettings_GetFaceCount(settings: *JPH_SoftBodySharedSettings);
	bool JPH_SoftBodySharedSettings_GetFace(settings: *JPH_SoftBodySharedSettings, index: uint32, outFace: *JPH_SoftFace);
	void JPH_SoftBodySharedSettings_CreateConstraints(settings: *JPH_SoftBodySharedSettings, compliance: float32, bendType: JPH_SoftBodyBendType);
	void JPH_SoftBodySharedSettings_Optimize(settings: *JPH_SoftBodySharedSettings);
	*JPH_SoftBodyCreationSettings JPH_SoftBodyCreationSettings_Create();
	*JPH_SoftBodyCreationSettings JPH_SoftBodyCreationSettings_Create2(settings: *JPH_SoftBodySharedSettings, position: *JPH_Vec3, rotation: *JPH_Quat, objectLayer: uint32);
	void JPH_SoftBodyCreationSettings_Destroy(settings: *JPH_SoftBodyCreationSettings);
	*JPH_SoftBodySharedSettings JPH_SoftBodyCreationSettings_GetSettings(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetSettings(settings: *JPH_SoftBodyCreationSettings, sharedSettings: *JPH_SoftBodySharedSettings);
	void JPH_SoftBodyCreationSettings_GetPosition(settings: *JPH_SoftBodyCreationSettings, result: *JPH_Vec3);
	void JPH_SoftBodyCreationSettings_SetPosition(settings: *JPH_SoftBodyCreationSettings, value: *JPH_Vec3);
	void JPH_SoftBodyCreationSettings_GetRotation(settings: *JPH_SoftBodyCreationSettings, result: *JPH_Quat);
	void JPH_SoftBodyCreationSettings_SetRotation(settings: *JPH_SoftBodyCreationSettings, value: *JPH_Quat);
	uint64 JPH_SoftBodyCreationSettings_GetUserData(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetUserData(settings: *JPH_SoftBodyCreationSettings, userData: uint64);
	uint32 JPH_SoftBodyCreationSettings_GetObjectLayer(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetObjectLayer(settings: *JPH_SoftBodyCreationSettings, value: uint32);
	void JPH_SoftBodyCreationSettings_GetCollisionGroup(settings: *JPH_SoftBodyCreationSettings, result: *JPH_CollisionGroup);
	void JPH_SoftBodyCreationSettings_SetCollisionGroup(settings: *JPH_SoftBodyCreationSettings, group: *JPH_CollisionGroup);
	uint32 JPH_SoftBodyCreationSettings_GetNumIterations(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetNumIterations(settings: *JPH_SoftBodyCreationSettings, iterations: uint32);
	float32 JPH_SoftBodyCreationSettings_GetLinearDamping(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetLinearDamping(settings: *JPH_SoftBodyCreationSettings, value: float32);
	float32 JPH_SoftBodyCreationSettings_GetMaxLinearVelocity(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetMaxLinearVelocity(settings: *JPH_SoftBodyCreationSettings, value: float32);
	float32 JPH_SoftBodyCreationSettings_GetRestitution(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetRestitution(settings: *JPH_SoftBodyCreationSettings, value: float32);
	float32 JPH_SoftBodyCreationSettings_GetFriction(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetFriction(settings: *JPH_SoftBodyCreationSettings, value: float32);
	float32 JPH_SoftBodyCreationSettings_GetPressure(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetPressure(settings: *JPH_SoftBodyCreationSettings, value: float32);
	float32 JPH_SoftBodyCreationSettings_GetGravityFactor(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetGravityFactor(settings: *JPH_SoftBodyCreationSettings, value: float32);
	float32 JPH_SoftBodyCreationSettings_GetVertexRadius(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetVertexRadius(settings: *JPH_SoftBodyCreationSettings, value: float32);
	bool JPH_SoftBodyCreationSettings_GetUpdatePosition(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetUpdatePosition(settings: *JPH_SoftBodyCreationSettings, value: bool);
	bool JPH_SoftBodyCreationSettings_GetMakeRotationIdentity(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetMakeRotationIdentity(settings: *JPH_SoftBodyCreationSettings, value: bool);
	bool JPH_SoftBodyCreationSettings_GetAllowSleeping(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetAllowSleeping(settings: *JPH_SoftBodyCreationSettings, value: bool);
	bool JPH_SoftBodyCreationSettings_GetFacesDoubleSided(settings: *JPH_SoftBodyCreationSettings);
	void JPH_SoftBodyCreationSettings_SetFacesDoubleSided(settings: *JPH_SoftBodyCreationSettings, value: bool);
	void JPH_Constraint_Destroy(constraint: *JPH_Constraint);
	JPH_ConstraintType JPH_Constraint_GetType(constraint: *JPH_Constraint);
	JPH_ConstraintSubType JPH_Constraint_GetSubType(constraint: *JPH_Constraint);
	uint32 JPH_Constraint_GetConstraintPriority(constraint: *JPH_Constraint);
	void JPH_Constraint_SetConstraintPriority(constraint: *JPH_Constraint, priority: uint32);
	uint32 JPH_Constraint_GetNumVelocityStepsOverride(constraint: *JPH_Constraint);
	void JPH_Constraint_SetNumVelocityStepsOverride(constraint: *JPH_Constraint, value: uint32);
	uint32 JPH_Constraint_GetNumPositionStepsOverride(constraint: *JPH_Constraint);
	void JPH_Constraint_SetNumPositionStepsOverride(constraint: *JPH_Constraint, value: uint32);
	bool JPH_Constraint_GetEnabled(constraint: *JPH_Constraint);
	void JPH_Constraint_SetEnabled(constraint: *JPH_Constraint, enabled: bool);
	uint64 JPH_Constraint_GetUserData(constraint: *JPH_Constraint);
	void JPH_Constraint_SetUserData(constraint: *JPH_Constraint, userData: uint64);
	void JPH_Constraint_NotifyShapeChanged(constraint: *JPH_Constraint, bodyID: uint32, deltaCOM: *JPH_Vec3);
	void JPH_Constraint_ResetWarmStart(constraint: *JPH_Constraint);
	bool JPH_Constraint_IsActive(constraint: *JPH_Constraint);
	void JPH_Constraint_SetupVelocityConstraint(constraint: *JPH_Constraint, deltaTime: float32);
	void JPH_Constraint_WarmStartVelocityConstraint(constraint: *JPH_Constraint, warmStartImpulseRatio: float32);
	bool JPH_Constraint_SolveVelocityConstraint(constraint: *JPH_Constraint, deltaTime: float32);
	bool JPH_Constraint_SolvePositionConstraint(constraint: *JPH_Constraint, deltaTime: float32, baumgarte: float32);
	*JPH_Body JPH_TwoBodyConstraint_GetBody1(constraint: *JPH_TwoBodyConstraint);
	*JPH_Body JPH_TwoBodyConstraint_GetBody2(constraint: *JPH_TwoBodyConstraint);
	void JPH_TwoBodyConstraint_GetConstraintToBody1Matrix(constraint: *JPH_TwoBodyConstraint, result: *JPH_Mat4);
	void JPH_TwoBodyConstraint_GetConstraintToBody2Matrix(constraint: *JPH_TwoBodyConstraint, result: *JPH_Mat4);
	void JPH_FixedConstraintSettings_Init(settings: *JPH_FixedConstraintSettings);
	*JPH_FixedConstraint JPH_FixedConstraint_Create(settings: *JPH_FixedConstraintSettings, body1: *JPH_Body, body2: *JPH_Body);
	void JPH_FixedConstraint_GetSettings(constraint: *JPH_FixedConstraint, settings: *JPH_FixedConstraintSettings);
	void JPH_FixedConstraint_GetTotalLambdaPosition(constraint: *JPH_FixedConstraint, result: *JPH_Vec3);
	void JPH_FixedConstraint_GetTotalLambdaRotation(constraint: *JPH_FixedConstraint, result: *JPH_Vec3);
	void JPH_DistanceConstraintSettings_Init(settings: *JPH_DistanceConstraintSettings);
	*JPH_DistanceConstraint JPH_DistanceConstraint_Create(settings: *JPH_DistanceConstraintSettings, body1: *JPH_Body, body2: *JPH_Body);
	void JPH_DistanceConstraint_GetSettings(constraint: *JPH_DistanceConstraint, settings: *JPH_DistanceConstraintSettings);
	void JPH_DistanceConstraint_SetDistance(constraint: *JPH_DistanceConstraint, minDistance: float32, maxDistance: float32);
	float32 JPH_DistanceConstraint_GetMinDistance(constraint: *JPH_DistanceConstraint);
	float32 JPH_DistanceConstraint_GetMaxDistance(constraint: *JPH_DistanceConstraint);
	void JPH_DistanceConstraint_GetLimitsSpringSettings(constraint: *JPH_DistanceConstraint, result: *JPH_SpringSettings);
	void JPH_DistanceConstraint_SetLimitsSpringSettings(constraint: *JPH_DistanceConstraint, settings: *JPH_SpringSettings);
	float32 JPH_DistanceConstraint_GetTotalLambdaPosition(constraint: *JPH_DistanceConstraint);
	void JPH_PointConstraintSettings_Init(settings: *JPH_PointConstraintSettings);
	*JPH_PointConstraint JPH_PointConstraint_Create(settings: *JPH_PointConstraintSettings, body1: *JPH_Body, body2: *JPH_Body);
	void JPH_PointConstraint_GetSettings(constraint: *JPH_PointConstraint, settings: *JPH_PointConstraintSettings);
	void JPH_PointConstraint_SetPoint1(constraint: *JPH_PointConstraint, space: JPH_ConstraintSpace, value: *JPH_Vec3);
	void JPH_PointConstraint_SetPoint2(constraint: *JPH_PointConstraint, space: JPH_ConstraintSpace, value: *JPH_Vec3);
	void JPH_PointConstraint_GetLocalSpacePoint1(constraint: *JPH_PointConstraint, result: *JPH_Vec3);
	void JPH_PointConstraint_GetLocalSpacePoint2(constraint: *JPH_PointConstraint, result: *JPH_Vec3);
	void JPH_PointConstraint_GetTotalLambdaPosition(constraint: *JPH_PointConstraint, result: *JPH_Vec3);
	void JPH_HingeConstraintSettings_Init(settings: *JPH_HingeConstraintSettings);
	*JPH_HingeConstraint JPH_HingeConstraint_Create(settings: *JPH_HingeConstraintSettings, body1: *JPH_Body, body2: *JPH_Body);
	void JPH_HingeConstraint_GetSettings(constraint: *JPH_HingeConstraint, settings: *JPH_HingeConstraintSettings);
	void JPH_HingeConstraint_GetLocalSpacePoint1(constraint: *JPH_HingeConstraint, result: *JPH_Vec3);
	void JPH_HingeConstraint_GetLocalSpacePoint2(constraint: *JPH_HingeConstraint, result: *JPH_Vec3);
	void JPH_HingeConstraint_GetLocalSpaceHingeAxis1(constraint: *JPH_HingeConstraint, result: *JPH_Vec3);
	void JPH_HingeConstraint_GetLocalSpaceHingeAxis2(constraint: *JPH_HingeConstraint, result: *JPH_Vec3);
	void JPH_HingeConstraint_GetLocalSpaceNormalAxis1(constraint: *JPH_HingeConstraint, result: *JPH_Vec3);
	void JPH_HingeConstraint_GetLocalSpaceNormalAxis2(constraint: *JPH_HingeConstraint, result: *JPH_Vec3);
	float32 JPH_HingeConstraint_GetCurrentAngle(constraint: *JPH_HingeConstraint);
	void JPH_HingeConstraint_SetMaxFrictionTorque(constraint: *JPH_HingeConstraint, frictionTorque: float32);
	float32 JPH_HingeConstraint_GetMaxFrictionTorque(constraint: *JPH_HingeConstraint);
	void JPH_HingeConstraint_SetMotorSettings(constraint: *JPH_HingeConstraint, settings: *JPH_MotorSettings);
	void JPH_HingeConstraint_GetMotorSettings(constraint: *JPH_HingeConstraint, result: *JPH_MotorSettings);
	void JPH_HingeConstraint_SetMotorState(constraint: *JPH_HingeConstraint, motorState: JPH_MotorState);
	JPH_MotorState JPH_HingeConstraint_GetMotorState(constraint: *JPH_HingeConstraint);
	void JPH_HingeConstraint_SetTargetAngularVelocity(constraint: *JPH_HingeConstraint, angularVelocity: float32);
	float32 JPH_HingeConstraint_GetTargetAngularVelocity(constraint: *JPH_HingeConstraint);
	void JPH_HingeConstraint_SetTargetAngle(constraint: *JPH_HingeConstraint, angle: float32);
	float32 JPH_HingeConstraint_GetTargetAngle(constraint: *JPH_HingeConstraint);
	void JPH_HingeConstraint_SetLimits(constraint: *JPH_HingeConstraint, inLimitsMin: float32, inLimitsMax: float32);
	float32 JPH_HingeConstraint_GetLimitsMin(constraint: *JPH_HingeConstraint);
	float32 JPH_HingeConstraint_GetLimitsMax(constraint: *JPH_HingeConstraint);
	bool JPH_HingeConstraint_HasLimits(constraint: *JPH_HingeConstraint);
	void JPH_HingeConstraint_GetLimitsSpringSettings(constraint: *JPH_HingeConstraint, result: *JPH_SpringSettings);
	void JPH_HingeConstraint_SetLimitsSpringSettings(constraint: *JPH_HingeConstraint, settings: *JPH_SpringSettings);
	void JPH_HingeConstraint_GetTotalLambdaPosition(constraint: *JPH_HingeConstraint, result: *JPH_Vec3);
	void JPH_HingeConstraint_GetTotalLambdaRotation(constraint: *JPH_HingeConstraint, rotation: [2]float32);
	float32 JPH_HingeConstraint_GetTotalLambdaRotationLimits(constraint: *JPH_HingeConstraint);
	float32 JPH_HingeConstraint_GetTotalLambdaMotor(constraint: *JPH_HingeConstraint);
	void JPH_SliderConstraintSettings_Init(settings: *JPH_SliderConstraintSettings);
	void JPH_SliderConstraintSettings_SetSliderAxis(settings: *JPH_SliderConstraintSettings, axis: *JPH_Vec3);
	*JPH_SliderConstraint JPH_SliderConstraint_Create(settings: *JPH_SliderConstraintSettings, body1: *JPH_Body, body2: *JPH_Body);
	void JPH_SliderConstraint_GetSettings(constraint: *JPH_SliderConstraint, settings: *JPH_SliderConstraintSettings);
	float32 JPH_SliderConstraint_GetCurrentPosition(constraint: *JPH_SliderConstraint);
	void JPH_SliderConstraint_SetMaxFrictionForce(constraint: *JPH_SliderConstraint, frictionForce: float32);
	float32 JPH_SliderConstraint_GetMaxFrictionForce(constraint: *JPH_SliderConstraint);
	void JPH_SliderConstraint_SetMotorSettings(constraint: *JPH_SliderConstraint, settings: *JPH_MotorSettings);
	void JPH_SliderConstraint_GetMotorSettings(constraint: *JPH_SliderConstraint, result: *JPH_MotorSettings);
	void JPH_SliderConstraint_SetMotorState(constraint: *JPH_SliderConstraint, motorState: JPH_MotorState);
	JPH_MotorState JPH_SliderConstraint_GetMotorState(constraint: *JPH_SliderConstraint);
	void JPH_SliderConstraint_SetTargetVelocity(constraint: *JPH_SliderConstraint, velocity: float32);
	float32 JPH_SliderConstraint_GetTargetVelocity(constraint: *JPH_SliderConstraint);
	void JPH_SliderConstraint_SetTargetPosition(constraint: *JPH_SliderConstraint, position: float32);
	float32 JPH_SliderConstraint_GetTargetPosition(constraint: *JPH_SliderConstraint);
	void JPH_SliderConstraint_SetLimits(constraint: *JPH_SliderConstraint, inLimitsMin: float32, inLimitsMax: float32);
	float32 JPH_SliderConstraint_GetLimitsMin(constraint: *JPH_SliderConstraint);
	float32 JPH_SliderConstraint_GetLimitsMax(constraint: *JPH_SliderConstraint);
	bool JPH_SliderConstraint_HasLimits(constraint: *JPH_SliderConstraint);
	void JPH_SliderConstraint_GetLimitsSpringSettings(constraint: *JPH_SliderConstraint, result: *JPH_SpringSettings);
	void JPH_SliderConstraint_SetLimitsSpringSettings(constraint: *JPH_SliderConstraint, settings: *JPH_SpringSettings);
	void JPH_SliderConstraint_GetTotalLambdaPosition(constraint: *JPH_SliderConstraint, position: [2]float32);
	float32 JPH_SliderConstraint_GetTotalLambdaPositionLimits(constraint: *JPH_SliderConstraint);
	void JPH_SliderConstraint_GetTotalLambdaRotation(constraint: *JPH_SliderConstraint, result: *JPH_Vec3);
	float32 JPH_SliderConstraint_GetTotalLambdaMotor(constraint: *JPH_SliderConstraint);
	void JPH_ConeConstraintSettings_Init(settings: *JPH_ConeConstraintSettings);
	*JPH_ConeConstraint JPH_ConeConstraint_Create(settings: *JPH_ConeConstraintSettings, body1: *JPH_Body, body2: *JPH_Body);
	void JPH_ConeConstraint_GetSettings(constraint: *JPH_ConeConstraint, settings: *JPH_ConeConstraintSettings);
	void JPH_ConeConstraint_SetHalfConeAngle(constraint: *JPH_ConeConstraint, halfConeAngle: float32);
	float32 JPH_ConeConstraint_GetCosHalfConeAngle(constraint: *JPH_ConeConstraint);
	void JPH_ConeConstraint_GetTotalLambdaPosition(constraint: *JPH_ConeConstraint, result: *JPH_Vec3);
	float32 JPH_ConeConstraint_GetTotalLambdaRotation(constraint: *JPH_ConeConstraint);
	void JPH_SwingTwistConstraintSettings_Init(settings: *JPH_SwingTwistConstraintSettings);
	*JPH_SwingTwistConstraint JPH_SwingTwistConstraint_Create(settings: *JPH_SwingTwistConstraintSettings, body1: *JPH_Body, body2: *JPH_Body);
	void JPH_SwingTwistConstraint_GetSettings(constraint: *JPH_SwingTwistConstraint, settings: *JPH_SwingTwistConstraintSettings);
	float32 JPH_SwingTwistConstraint_GetNormalHalfConeAngle(constraint: *JPH_SwingTwistConstraint);
	void JPH_SwingTwistConstraint_GetTotalLambdaPosition(constraint: *JPH_SwingTwistConstraint, result: *JPH_Vec3);
	float32 JPH_SwingTwistConstraint_GetTotalLambdaTwist(constraint: *JPH_SwingTwistConstraint);
	float32 JPH_SwingTwistConstraint_GetTotalLambdaSwingY(constraint: *JPH_SwingTwistConstraint);
	float32 JPH_SwingTwistConstraint_GetTotalLambdaSwingZ(constraint: *JPH_SwingTwistConstraint);
	void JPH_SwingTwistConstraint_GetTotalLambdaMotor(constraint: *JPH_SwingTwistConstraint, result: *JPH_Vec3);
	void JPH_SixDOFConstraintSettings_Init(settings: *JPH_SixDOFConstraintSettings);
	void JPH_SixDOFConstraintSettings_MakeFreeAxis(settings: *JPH_SixDOFConstraintSettings, axis: JPH_SixDOFConstraintAxis);
	bool JPH_SixDOFConstraintSettings_IsFreeAxis(settings: *JPH_SixDOFConstraintSettings, axis: JPH_SixDOFConstraintAxis);
	void JPH_SixDOFConstraintSettings_MakeFixedAxis(settings: *JPH_SixDOFConstraintSettings, axis: JPH_SixDOFConstraintAxis);
	bool JPH_SixDOFConstraintSettings_IsFixedAxis(settings: *JPH_SixDOFConstraintSettings, axis: JPH_SixDOFConstraintAxis);
	void JPH_SixDOFConstraintSettings_SetLimitedAxis(settings: *JPH_SixDOFConstraintSettings, axis: JPH_SixDOFConstraintAxis, min: float32, max: float32);
	*JPH_SixDOFConstraint JPH_SixDOFConstraint_Create(settings: *JPH_SixDOFConstraintSettings, body1: *JPH_Body, body2: *JPH_Body);
	void JPH_SixDOFConstraint_GetSettings(constraint: *JPH_SixDOFConstraint, settings: *JPH_SixDOFConstraintSettings);
	float32 JPH_SixDOFConstraint_GetLimitsMin(constraint: *JPH_SixDOFConstraint, axis: JPH_SixDOFConstraintAxis);
	float32 JPH_SixDOFConstraint_GetLimitsMax(constraint: *JPH_SixDOFConstraint, axis: JPH_SixDOFConstraintAxis);
	void JPH_SixDOFConstraint_GetTotalLambdaPosition(constraint: *JPH_SixDOFConstraint, result: *JPH_Vec3);
	void JPH_SixDOFConstraint_GetTotalLambdaRotation(constraint: *JPH_SixDOFConstraint, result: *JPH_Vec3);
	void JPH_SixDOFConstraint_GetTotalLambdaMotorTranslation(constraint: *JPH_SixDOFConstraint, result: *JPH_Vec3);
	void JPH_SixDOFConstraint_GetTotalLambdaMotorRotation(constraint: *JPH_SixDOFConstraint, result: *JPH_Vec3);
	void JPH_SixDOFConstraint_GetTranslationLimitsMin(constraint: *JPH_SixDOFConstraint, result: *JPH_Vec3);
	void JPH_SixDOFConstraint_GetTranslationLimitsMax(constraint: *JPH_SixDOFConstraint, result: *JPH_Vec3);
	void JPH_SixDOFConstraint_GetRotationLimitsMin(constraint: *JPH_SixDOFConstraint, result: *JPH_Vec3);
	void JPH_SixDOFConstraint_GetRotationLimitsMax(constraint: *JPH_SixDOFConstraint, result: *JPH_Vec3);
	bool JPH_SixDOFConstraint_IsFixedAxis(constraint: *JPH_SixDOFConstraint, axis: JPH_SixDOFConstraintAxis);
	bool JPH_SixDOFConstraint_IsFreeAxis(constraint: *JPH_SixDOFConstraint, axis: JPH_SixDOFConstraintAxis);
	void JPH_SixDOFConstraint_GetLimitsSpringSettings(constraint: *JPH_SixDOFConstraint, result: *JPH_SpringSettings, axis: JPH_SixDOFConstraintAxis);
	void JPH_SixDOFConstraint_SetLimitsSpringSettings(constraint: *JPH_SixDOFConstraint, settings: *JPH_SpringSettings, axis: JPH_SixDOFConstraintAxis);
	void JPH_SixDOFConstraint_SetMaxFriction(constraint: *JPH_SixDOFConstraint, axis: JPH_SixDOFConstraintAxis, inFriction: float32);
	float32 JPH_SixDOFConstraint_GetMaxFriction(constraint: *JPH_SixDOFConstraint, axis: JPH_SixDOFConstraintAxis);
	void JPH_SixDOFConstraint_GetRotationInConstraintSpace(constraint: *JPH_SixDOFConstraint, result: *JPH_Quat);
	void JPH_SixDOFConstraint_GetMotorSettings(constraint: *JPH_SixDOFConstraint, axis: JPH_SixDOFConstraintAxis, settings: *JPH_MotorSettings);
	void JPH_SixDOFConstraint_SetMotorState(constraint: *JPH_SixDOFConstraint, axis: JPH_SixDOFConstraintAxis, motorState: JPH_MotorState);
	JPH_MotorState JPH_SixDOFConstraint_GetMotorState(constraint: *JPH_SixDOFConstraint, axis: JPH_SixDOFConstraintAxis);
	void JPH_SixDOFConstraint_SetTargetVelocityCS(constraint: *JPH_SixDOFConstraint, inVelocity: *JPH_Vec3);
	void JPH_SixDOFConstraint_GetTargetVelocityCS(constraint: *JPH_SixDOFConstraint, result: *JPH_Vec3);
	void JPH_SixDOFConstraint_SetTargetAngularVelocityCS(constraint: *JPH_SixDOFConstraint, inAngularVelocity: *JPH_Vec3);
	void JPH_SixDOFConstraint_GetTargetAngularVelocityCS(constraint: *JPH_SixDOFConstraint, result: *JPH_Vec3);
	void JPH_SixDOFConstraint_SetTargetPositionCS(constraint: *JPH_SixDOFConstraint, inPosition: *JPH_Vec3);
	void JPH_SixDOFConstraint_GetTargetPositionCS(constraint: *JPH_SixDOFConstraint, result: *JPH_Vec3);
	void JPH_SixDOFConstraint_SetTargetOrientationCS(constraint: *JPH_SixDOFConstraint, inOrientation: *JPH_Quat);
	void JPH_SixDOFConstraint_GetTargetOrientationCS(constraint: *JPH_SixDOFConstraint, result: *JPH_Quat);
	void JPH_SixDOFConstraint_SetTargetOrientationBS(constraint: *JPH_SixDOFConstraint, inOrientation: *JPH_Quat);
	void JPH_GearConstraintSettings_Init(settings: *JPH_GearConstraintSettings);
	*JPH_GearConstraint JPH_GearConstraint_Create(settings: *JPH_GearConstraintSettings, body1: *JPH_Body, body2: *JPH_Body);
	void JPH_GearConstraint_GetSettings(constraint: *JPH_GearConstraint, settings: *JPH_GearConstraintSettings);
	void JPH_GearConstraint_SetConstraints(constraint: *JPH_GearConstraint, gear1: *JPH_Constraint, gear2: *JPH_Constraint);
	float32 JPH_GearConstraint_GetTotalLambda(constraint: *JPH_GearConstraint);
	void JPH_BodyInterface_DestroyBody(bodyInterface: *JPH_BodyInterface, bodyID: uint32);
	uint32 JPH_BodyInterface_CreateAndAddBody(bodyInterface: *JPH_BodyInterface, settings: *JPH_BodyCreationSettings, activationMode: JPH_Activation);
	*JPH_Body JPH_BodyInterface_CreateBody(bodyInterface: *JPH_BodyInterface, settings: *JPH_BodyCreationSettings);
	*JPH_Body JPH_BodyInterface_CreateBodyWithID(bodyInterface: *JPH_BodyInterface, bodyID: uint32, settings: *JPH_BodyCreationSettings);
	*JPH_Body JPH_BodyInterface_CreateBodyWithoutID(bodyInterface: *JPH_BodyInterface, settings: *JPH_BodyCreationSettings);
	void JPH_BodyInterface_DestroyBodyWithoutID(bodyInterface: *JPH_BodyInterface, body: *JPH_Body);
	bool JPH_BodyInterface_AssignBodyID(bodyInterface: *JPH_BodyInterface, body: *JPH_Body);
	bool JPH_BodyInterface_AssignBodyID2(bodyInterface: *JPH_BodyInterface, body: *JPH_Body, bodyID: uint32);
	*JPH_Body JPH_BodyInterface_UnassignBodyID(bodyInterface: *JPH_BodyInterface, bodyID: uint32);
	*JPH_Body JPH_BodyInterface_CreateSoftBody(bodyInterface: *JPH_BodyInterface, settings: *JPH_SoftBodyCreationSettings);
	*JPH_Body JPH_BodyInterface_CreateSoftBodyWithID(bodyInterface: *JPH_BodyInterface, bodyID: uint32, settings: *JPH_SoftBodyCreationSettings);
	*JPH_Body JPH_BodyInterface_CreateSoftBodyWithoutID(bodyInterface: *JPH_BodyInterface, settings: *JPH_SoftBodyCreationSettings);
	uint32 JPH_BodyInterface_CreateAndAddSoftBody(bodyInterface: *JPH_BodyInterface, settings: *JPH_SoftBodyCreationSettings, activationMode: JPH_Activation);
	void JPH_BodyInterface_AddBody(bodyInterface: *JPH_BodyInterface, bodyID: uint32, activationMode: JPH_Activation);
	void JPH_BodyInterface_RemoveBody(bodyInterface: *JPH_BodyInterface, bodyID: uint32);
	void JPH_BodyInterface_RemoveAndDestroyBody(bodyInterface: *JPH_BodyInterface, bodyID: uint32);
	bool JPH_BodyInterface_IsAdded(bodyInterface: *JPH_BodyInterface, bodyID: uint32);
	JPH_BodyType JPH_BodyInterface_GetBodyType(bodyInterface: *JPH_BodyInterface, bodyID: uint32);
	*JPH_Body JPH_PhysicsSystem_GetBodyPtr(system: *JPH_PhysicsSystem, bodyID: uint32);
	void JPH_BodyInterface_SetLinearVelocity(bodyInterface: *JPH_BodyInterface, bodyID: uint32, velocity: *JPH_Vec3);
	void JPH_BodyInterface_GetLinearVelocity(bodyInterface: *JPH_BodyInterface, bodyID: uint32, velocity: *JPH_Vec3);
	void JPH_BodyInterface_GetCenterOfMassPosition(bodyInterface: *JPH_BodyInterface, bodyID: uint32, position: *JPH_Vec3);
	JPH_MotionType JPH_BodyInterface_GetMotionType(bodyInterface: *JPH_BodyInterface, bodyID: uint32);
	void JPH_BodyInterface_SetMotionType(bodyInterface: *JPH_BodyInterface, bodyID: uint32, motionType: JPH_MotionType, activationMode: JPH_Activation);
	float32 JPH_BodyInterface_GetRestitution(bodyInterface: *JPH_BodyInterface, bodyID: uint32);
	void JPH_BodyInterface_SetRestitution(bodyInterface: *JPH_BodyInterface, bodyID: uint32, restitution: float32);
	float32 JPH_BodyInterface_GetFriction(bodyInterface: *JPH_BodyInterface, bodyID: uint32);
	void JPH_BodyInterface_SetFriction(bodyInterface: *JPH_BodyInterface, bodyID: uint32, friction: float32);
	void JPH_BodyInterface_SetPosition(bodyInterface: *JPH_BodyInterface, bodyId: uint32, position: *JPH_Vec3, activationMode: JPH_Activation);
	void JPH_BodyInterface_GetPosition(bodyInterface: *JPH_BodyInterface, bodyId: uint32, result: *JPH_Vec3);
	void JPH_BodyInterface_SetRotation(bodyInterface: *JPH_BodyInterface, bodyId: uint32, rotation: *JPH_Quat, activationMode: JPH_Activation);
	void JPH_BodyInterface_GetRotation(bodyInterface: *JPH_BodyInterface, bodyId: uint32, result: *JPH_Quat);
	void JPH_BodyInterface_SetPositionAndRotation(bodyInterface: *JPH_BodyInterface, bodyId: uint32, position: *JPH_Vec3, rotation: *JPH_Quat, activationMode: JPH_Activation);
	void JPH_BodyInterface_SetPositionAndRotationWhenChanged(bodyInterface: *JPH_BodyInterface, bodyId: uint32, position: *JPH_Vec3, rotation: *JPH_Quat, activationMode: JPH_Activation);
	void JPH_BodyInterface_GetPositionAndRotation(bodyInterface: *JPH_BodyInterface, bodyId: uint32, position: *JPH_Vec3, rotation: *JPH_Quat);
	void JPH_BodyInterface_SetPositionRotationAndVelocity(bodyInterface: *JPH_BodyInterface, bodyId: uint32, position: *JPH_Vec3, rotation: *JPH_Quat, linearVelocity: *JPH_Vec3, angularVelocity: *JPH_Vec3);
	void JPH_BodyInterface_GetCollisionGroup(bodyInterface: *JPH_BodyInterface, bodyId: uint32, result: *JPH_CollisionGroup);
	void JPH_BodyInterface_SetCollisionGroup(bodyInterface: *JPH_BodyInterface, bodyId: uint32, group: *JPH_CollisionGroup);
	*JPH_Shape JPH_BodyInterface_GetShape(bodyInterface: *JPH_BodyInterface, bodyId: uint32);
	void JPH_BodyInterface_SetShape(bodyInterface: *JPH_BodyInterface, bodyId: uint32, shape: *JPH_Shape, updateMassProperties: bool, activationMode: JPH_Activation);
	void JPH_BodyInterface_NotifyShapeChanged(bodyInterface: *JPH_BodyInterface, bodyId: uint32, previousCenterOfMass: *JPH_Vec3, updateMassProperties: bool, activationMode: JPH_Activation);
	void JPH_BodyInterface_ActivateBody(bodyInterface: *JPH_BodyInterface, bodyId: uint32);
	void JPH_BodyInterface_ActivateBodies(bodyInterface: *JPH_BodyInterface, bodyIDs: *uint32, count: uint32);
	void JPH_BodyInterface_ActivateBodiesInAABox(bodyInterface: *JPH_BodyInterface, box: *JPH_AABox, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter);
	void JPH_BodyInterface_DeactivateBody(bodyInterface: *JPH_BodyInterface, bodyId: uint32);
	void JPH_BodyInterface_DeactivateBodies(bodyInterface: *JPH_BodyInterface, bodyIDs: *uint32, count: uint32);
	bool JPH_BodyInterface_IsActive(bodyInterface: *JPH_BodyInterface, bodyID: uint32);
	void JPH_BodyInterface_ResetSleepTimer(bodyInterface: *JPH_BodyInterface, bodyID: uint32);
	uint32 JPH_BodyInterface_GetObjectLayer(bodyInterface: *JPH_BodyInterface, bodyId: uint32);
	void JPH_BodyInterface_SetObjectLayer(bodyInterface: *JPH_BodyInterface, bodyId: uint32, layer: uint32);
	void JPH_BodyInterface_GetWorldTransform(bodyInterface: *JPH_BodyInterface, bodyId: uint32, result: *JPH_Mat4);
	void JPH_BodyInterface_GetCenterOfMassTransform(bodyInterface: *JPH_BodyInterface, bodyId: uint32, result: *JPH_Mat4);
	void JPH_BodyInterface_MoveKinematic(bodyInterface: *JPH_BodyInterface, bodyId: uint32, targetPosition: *JPH_Vec3, targetRotation: *JPH_Quat, deltaTime: float32);
	bool JPH_BodyInterface_ApplyBuoyancyImpulse(bodyInterface: *JPH_BodyInterface, bodyId: uint32, surfacePosition: *JPH_Vec3, surfaceNormal: *JPH_Vec3, buoyancy: float32, linearDrag: float32, angularDrag: float32, fluidVelocity: *JPH_Vec3, gravity: *JPH_Vec3, deltaTime: float32);
	void JPH_BodyInterface_SetLinearAndAngularVelocity(bodyInterface: *JPH_BodyInterface, bodyId: uint32, linearVelocity: *JPH_Vec3, angularVelocity: *JPH_Vec3);
	void JPH_BodyInterface_GetLinearAndAngularVelocity(bodyInterface: *JPH_BodyInterface, bodyId: uint32, linearVelocity: *JPH_Vec3, angularVelocity: *JPH_Vec3);
	void JPH_BodyInterface_AddLinearVelocity(bodyInterface: *JPH_BodyInterface, bodyId: uint32, linearVelocity: *JPH_Vec3);
	void JPH_BodyInterface_AddLinearAndAngularVelocity(bodyInterface: *JPH_BodyInterface, bodyId: uint32, linearVelocity: *JPH_Vec3, angularVelocity: *JPH_Vec3);
	void JPH_BodyInterface_SetAngularVelocity(bodyInterface: *JPH_BodyInterface, bodyId: uint32, angularVelocity: *JPH_Vec3);
	void JPH_BodyInterface_GetAngularVelocity(bodyInterface: *JPH_BodyInterface, bodyId: uint32, angularVelocity: *JPH_Vec3);
	void JPH_BodyInterface_GetPointVelocity(bodyInterface: *JPH_BodyInterface, bodyId: uint32, point: *JPH_Vec3, velocity: *JPH_Vec3);
	void JPH_BodyInterface_AddForce(bodyInterface: *JPH_BodyInterface, bodyId: uint32, force: *JPH_Vec3);
	void JPH_BodyInterface_AddForce2(bodyInterface: *JPH_BodyInterface, bodyId: uint32, force: *JPH_Vec3, point: *JPH_Vec3);
	void JPH_BodyInterface_AddTorque(bodyInterface: *JPH_BodyInterface, bodyId: uint32, torque: *JPH_Vec3);
	void JPH_BodyInterface_AddForceAndTorque(bodyInterface: *JPH_BodyInterface, bodyId: uint32, force: *JPH_Vec3, torque: *JPH_Vec3);
	void JPH_BodyInterface_AddImpulse(bodyInterface: *JPH_BodyInterface, bodyId: uint32, impulse: *JPH_Vec3);
	void JPH_BodyInterface_AddImpulse2(bodyInterface: *JPH_BodyInterface, bodyId: uint32, impulse: *JPH_Vec3, point: *JPH_Vec3);
	void JPH_BodyInterface_AddAngularImpulse(bodyInterface: *JPH_BodyInterface, bodyId: uint32, angularImpulse: *JPH_Vec3);
	void JPH_BodyInterface_SetMotionQuality(bodyInterface: *JPH_BodyInterface, bodyId: uint32, quality: JPH_MotionQuality);
	JPH_MotionQuality JPH_BodyInterface_GetMotionQuality(bodyInterface: *JPH_BodyInterface, bodyId: uint32);
	void JPH_BodyInterface_GetInverseInertia(bodyInterface: *JPH_BodyInterface, bodyId: uint32, result: *JPH_Mat4);
	void JPH_BodyInterface_SetGravityFactor(bodyInterface: *JPH_BodyInterface, bodyId: uint32, value: float32);
	float32 JPH_BodyInterface_GetGravityFactor(bodyInterface: *JPH_BodyInterface, bodyId: uint32);
	void JPH_BodyInterface_SetUseManifoldReduction(bodyInterface: *JPH_BodyInterface, bodyId: uint32, value: bool);
	bool JPH_BodyInterface_GetUseManifoldReduction(bodyInterface: *JPH_BodyInterface, bodyId: uint32);
	void JPH_BodyInterface_SetUserData(bodyInterface: *JPH_BodyInterface, bodyId: uint32, inUserData: uint64);
	uint64 JPH_BodyInterface_GetUserData(bodyInterface: *JPH_BodyInterface, bodyId: uint32);
	void JPH_BodyInterface_SetIsSensor(bodyInterface: *JPH_BodyInterface, bodyId: uint32, value: bool);
	bool JPH_BodyInterface_IsSensor(bodyInterface: *JPH_BodyInterface, bodyId: uint32);
	*JPH_PhysicsMaterial JPH_BodyInterface_GetMaterial(bodyInterface: *JPH_BodyInterface, bodyId: uint32, subShapeID: uint32);
	void JPH_BodyInterface_InvalidateContactCache(bodyInterface: *JPH_BodyInterface, bodyId: uint32);
	void JPH_BodyLockInterface_LockRead(lockInterface: *JPH_BodyLockInterface, bodyID: uint32, outLock: *JPH_BodyLockRead);
	void JPH_BodyLockInterface_UnlockRead(lockInterface: *JPH_BodyLockInterface, ioLock: *JPH_BodyLockRead);
	void JPH_BodyLockInterface_LockWrite(lockInterface: *JPH_BodyLockInterface, bodyID: uint32, outLock: *JPH_BodyLockWrite);
	void JPH_BodyLockInterface_UnlockWrite(lockInterface: *JPH_BodyLockInterface, ioLock: *JPH_BodyLockWrite);
	*JPH_BodyLockMultiRead JPH_BodyLockInterface_LockMultiRead(lockInterface: *JPH_BodyLockInterface, bodyIDs: *uint32, count: uint32);
	void JPH_BodyLockMultiRead_Destroy(ioLock: *JPH_BodyLockMultiRead);
	*JPH_Body JPH_BodyLockMultiRead_GetBody(ioLock: *JPH_BodyLockMultiRead, bodyIndex: uint32);
	*JPH_BodyLockMultiWrite JPH_BodyLockInterface_LockMultiWrite(lockInterface: *JPH_BodyLockInterface, bodyIDs: *uint32, count: uint32);
	void JPH_BodyLockMultiWrite_Destroy(ioLock: *JPH_BodyLockMultiWrite);
	*JPH_Body JPH_BodyLockMultiWrite_GetBody(ioLock: *JPH_BodyLockMultiWrite, bodyIndex: uint32);
	JPH_AllowedDOFs JPH_MotionProperties_GetAllowedDOFs(properties: *JPH_MotionProperties);
	void JPH_MotionProperties_SetLinearDamping(properties: *JPH_MotionProperties, damping: float32);
	float32 JPH_MotionProperties_GetLinearDamping(properties: *JPH_MotionProperties);
	void JPH_MotionProperties_SetAngularDamping(properties: *JPH_MotionProperties, damping: float32);
	float32 JPH_MotionProperties_GetAngularDamping(properties: *JPH_MotionProperties);
	void JPH_MotionProperties_SetMassProperties(properties: *JPH_MotionProperties, allowedDOFs: JPH_AllowedDOFs, massProperties: *JPH_MassProperties);
	float32 JPH_MotionProperties_GetInverseMassUnchecked(properties: *JPH_MotionProperties);
	void JPH_MotionProperties_SetInverseMass(properties: *JPH_MotionProperties, inverseMass: float32);
	void JPH_MotionProperties_GetInverseInertiaDiagonal(properties: *JPH_MotionProperties, result: *JPH_Vec3);
	void JPH_MotionProperties_GetInertiaRotation(properties: *JPH_MotionProperties, result: *JPH_Quat);
	void JPH_MotionProperties_SetInverseInertia(properties: *JPH_MotionProperties, diagonal: *JPH_Vec3, rot: *JPH_Quat);
	void JPH_MotionProperties_ScaleToMass(properties: *JPH_MotionProperties, mass: float32);
	void JPH_RayCast_GetPointOnRay(origin: *JPH_Vec3, direction: *JPH_Vec3, fraction: float32, result: *JPH_Vec3);
	void JPH_RRayCast_GetPointOnRay(origin: *JPH_Vec3, direction: *JPH_Vec3, fraction: float32, result: *JPH_Vec3);
	void JPH_MassProperties_DecomposePrincipalMomentsOfInertia(properties: *JPH_MassProperties, rotation: *JPH_Mat4, diagonal: *JPH_Vec3);
	void JPH_MassProperties_ScaleToMass(properties: *JPH_MassProperties, mass: float32);
	void JPH_MassProperties_GetEquivalentSolidBoxSize(mass: float32, inertiaDiagonal: *JPH_Vec3, result: *JPH_Vec3);
	void JPH_CollideShapeSettings_Init(settings: *JPH_CollideShapeSettings);
	void JPH_ShapeCastSettings_Init(settings: *JPH_ShapeCastSettings);
	bool JPH_BroadPhaseQuery_CastRay(query: *JPH_BroadPhaseQuery, origin: *JPH_Vec3, direction: *JPH_Vec3, callback: ::(), userData: *void, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter);
	bool JPH_BroadPhaseQuery_CastRay2(query: *JPH_BroadPhaseQuery, origin: *JPH_Vec3, direction: *JPH_Vec3, collectorType: JPH_CollisionCollectorType, callback: ::(), userData: *void, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter);
	bool JPH_BroadPhaseQuery_CollideAABox(query: *JPH_BroadPhaseQuery, box: *JPH_AABox, callback: ::(), userData: *void, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter);
	bool JPH_BroadPhaseQuery_CollideSphere(query: *JPH_BroadPhaseQuery, center: *JPH_Vec3, radius: float32, callback: ::(), userData: *void, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter);
	bool JPH_BroadPhaseQuery_CollidePoint(query: *JPH_BroadPhaseQuery, point: *JPH_Vec3, callback: ::(), userData: *void, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter);
	bool JPH_NarrowPhaseQuery_CastRay(query: *JPH_NarrowPhaseQuery, origin: *JPH_Vec3, direction: *JPH_Vec3, hit: *JPH_RayCastResult, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter, bodyFilter: *JPH_BodyFilter);
	bool JPH_NarrowPhaseQuery_CastRay2(query: *JPH_NarrowPhaseQuery, origin: *JPH_Vec3, direction: *JPH_Vec3, rayCastSettings: *JPH_RayCastSettings, callback: ::(), userData: *void, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter, bodyFilter: *JPH_BodyFilter, shapeFilter: *JPH_ShapeFilter);
	bool JPH_NarrowPhaseQuery_CastRay3(query: *JPH_NarrowPhaseQuery, origin: *JPH_Vec3, direction: *JPH_Vec3, rayCastSettings: *JPH_RayCastSettings, collectorType: JPH_CollisionCollectorType, callback: ::(), userData: *void, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter, bodyFilter: *JPH_BodyFilter, shapeFilter: *JPH_ShapeFilter);
	bool JPH_NarrowPhaseQuery_CollidePoint(query: *JPH_NarrowPhaseQuery, point: *JPH_Vec3, callback: ::(), userData: *void, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter, bodyFilter: *JPH_BodyFilter, shapeFilter: *JPH_ShapeFilter);
	bool JPH_NarrowPhaseQuery_CollidePoint2(query: *JPH_NarrowPhaseQuery, point: *JPH_Vec3, collectorType: JPH_CollisionCollectorType, callback: ::(), userData: *void, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter, bodyFilter: *JPH_BodyFilter, shapeFilter: *JPH_ShapeFilter);
	bool JPH_NarrowPhaseQuery_CollideShape(query: *JPH_NarrowPhaseQuery, shape: *JPH_Shape, scale: *JPH_Vec3, centerOfMassTransform: *JPH_Mat4, settings: *JPH_CollideShapeSettings, baseOffset: *JPH_Vec3, callback: ::(), userData: *void, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter, bodyFilter: *JPH_BodyFilter, shapeFilter: *JPH_ShapeFilter);
	bool JPH_NarrowPhaseQuery_CollideShape2(query: *JPH_NarrowPhaseQuery, shape: *JPH_Shape, scale: *JPH_Vec3, centerOfMassTransform: *JPH_Mat4, settings: *JPH_CollideShapeSettings, baseOffset: *JPH_Vec3, collectorType: JPH_CollisionCollectorType, callback: ::(), userData: *void, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter, bodyFilter: *JPH_BodyFilter, shapeFilter: *JPH_ShapeFilter);
	bool JPH_NarrowPhaseQuery_CastShape(query: *JPH_NarrowPhaseQuery, shape: *JPH_Shape, worldTransform: *JPH_Mat4, direction: *JPH_Vec3, settings: *JPH_ShapeCastSettings, baseOffset: *JPH_Vec3, callback: ::(), userData: *void, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter, bodyFilter: *JPH_BodyFilter, shapeFilter: *JPH_ShapeFilter);
	bool JPH_NarrowPhaseQuery_CastShape2(query: *JPH_NarrowPhaseQuery, shape: *JPH_Shape, worldTransform: *JPH_Mat4, direction: *JPH_Vec3, settings: *JPH_ShapeCastSettings, baseOffset: *JPH_Vec3, collectorType: JPH_CollisionCollectorType, callback: ::(), userData: *void, broadPhaseLayerFilter: *JPH_BroadPhaseLayerFilter, objectLayerFilter: *JPH_ObjectLayerFilter, bodyFilter: *JPH_BodyFilter, shapeFilter: *JPH_ShapeFilter);
	uint32 JPH_Body_GetID(body: *JPH_Body);
	JPH_BodyType JPH_Body_GetBodyType(body: *JPH_Body);
	bool JPH_Body_IsRigidBody(body: *JPH_Body);
	bool JPH_Body_IsSoftBody(body: *JPH_Body);
	bool JPH_Body_IsActive(body: *JPH_Body);
	bool JPH_Body_IsStatic(body: *JPH_Body);
	bool JPH_Body_IsKinematic(body: *JPH_Body);
	bool JPH_Body_IsDynamic(body: *JPH_Body);
	bool JPH_Body_CanBeKinematicOrDynamic(body: *JPH_Body);
	void JPH_Body_SetIsSensor(body: *JPH_Body, value: bool);
	bool JPH_Body_IsSensor(body: *JPH_Body);
	void JPH_Body_SetCollideKinematicVsNonDynamic(body: *JPH_Body, value: bool);
	bool JPH_Body_GetCollideKinematicVsNonDynamic(body: *JPH_Body);
	void JPH_Body_SetUseManifoldReduction(body: *JPH_Body, value: bool);
	bool JPH_Body_GetUseManifoldReduction(body: *JPH_Body);
	bool JPH_Body_GetUseManifoldReductionWithBody(body: *JPH_Body, other: *JPH_Body);
	void JPH_Body_SetApplyGyroscopicForce(body: *JPH_Body, value: bool);
	bool JPH_Body_GetApplyGyroscopicForce(body: *JPH_Body);
	void JPH_Body_SetEnhancedInternalEdgeRemoval(body: *JPH_Body, value: bool);
	bool JPH_Body_GetEnhancedInternalEdgeRemoval(body: *JPH_Body);
	bool JPH_Body_GetEnhancedInternalEdgeRemovalWithBody(body: *JPH_Body, other: *JPH_Body);
	JPH_MotionType JPH_Body_GetMotionType(body: *JPH_Body);
	void JPH_Body_SetMotionType(body: *JPH_Body, motionType: JPH_MotionType);
	ubyte JPH_Body_GetBroadPhaseLayer(body: *JPH_Body);
	uint32 JPH_Body_GetObjectLayer(body: *JPH_Body);
	void JPH_Body_GetCollisionGroup(body: *JPH_Body, result: *JPH_CollisionGroup);
	void JPH_Body_SetCollisionGroup(body: *JPH_Body, value: *JPH_CollisionGroup);
	bool JPH_Body_GetAllowSleeping(body: *JPH_Body);
	void JPH_Body_SetAllowSleeping(body: *JPH_Body, allowSleeping: bool);
	void JPH_Body_ResetSleepTimer(body: *JPH_Body);
	float32 JPH_Body_GetFriction(body: *JPH_Body);
	void JPH_Body_SetFriction(body: *JPH_Body, friction: float32);
	float32 JPH_Body_GetRestitution(body: *JPH_Body);
	void JPH_Body_SetRestitution(body: *JPH_Body, restitution: float32);
	void JPH_Body_GetLinearVelocity(body: *JPH_Body, velocity: *JPH_Vec3);
	void JPH_Body_SetLinearVelocity(body: *JPH_Body, velocity: *JPH_Vec3);
	void JPH_Body_SetLinearVelocityClamped(body: *JPH_Body, velocity: *JPH_Vec3);
	void JPH_Body_GetAngularVelocity(body: *JPH_Body, velocity: *JPH_Vec3);
	void JPH_Body_SetAngularVelocity(body: *JPH_Body, velocity: *JPH_Vec3);
	void JPH_Body_SetAngularVelocityClamped(body: *JPH_Body, velocity: *JPH_Vec3);
	void JPH_Body_GetPointVelocityCOM(body: *JPH_Body, pointRelativeToCOM: *JPH_Vec3, velocity: *JPH_Vec3);
	void JPH_Body_GetPointVelocity(body: *JPH_Body, point: *JPH_Vec3, velocity: *JPH_Vec3);
	void JPH_Body_AddForce(body: *JPH_Body, force: *JPH_Vec3);
	void JPH_Body_AddForceAtPosition(body: *JPH_Body, force: *JPH_Vec3, position: *JPH_Vec3);
	void JPH_Body_AddTorque(body: *JPH_Body, force: *JPH_Vec3);
	void JPH_Body_GetAccumulatedForce(body: *JPH_Body, force: *JPH_Vec3);
	void JPH_Body_GetAccumulatedTorque(body: *JPH_Body, force: *JPH_Vec3);
	void JPH_Body_ResetForce(body: *JPH_Body);
	void JPH_Body_ResetTorque(body: *JPH_Body);
	void JPH_Body_ResetMotion(body: *JPH_Body);
	void JPH_Body_GetInverseInertia(body: *JPH_Body, result: *JPH_Mat4);
	void JPH_Body_AddImpulse(body: *JPH_Body, impulse: *JPH_Vec3);
	void JPH_Body_AddImpulseAtPosition(body: *JPH_Body, impulse: *JPH_Vec3, position: *JPH_Vec3);
	void JPH_Body_AddAngularImpulse(body: *JPH_Body, angularImpulse: *JPH_Vec3);
	void JPH_Body_MoveKinematic(body: *JPH_Body, targetPosition: *JPH_Vec3, targetRotation: *JPH_Quat, deltaTime: float32);
	bool JPH_Body_ApplyBuoyancyImpulse(body: *JPH_Body, surfacePosition: *JPH_Vec3, surfaceNormal: *JPH_Vec3, buoyancy: float32, linearDrag: float32, angularDrag: float32, fluidVelocity: *JPH_Vec3, gravity: *JPH_Vec3, deltaTime: float32);
	bool JPH_Body_IsInBroadPhase(body: *JPH_Body);
	bool JPH_Body_IsCollisionCacheInvalid(body: *JPH_Body);
	*JPH_Shape JPH_Body_GetShape(body: *JPH_Body);
	void JPH_Body_GetPosition(body: *JPH_Body, result: *JPH_Vec3);
	void JPH_Body_GetRotation(body: *JPH_Body, result: *JPH_Quat);
	void JPH_Body_GetWorldTransform(body: *JPH_Body, result: *JPH_Mat4);
	void JPH_Body_GetCenterOfMassPosition(body: *JPH_Body, result: *JPH_Vec3);
	void JPH_Body_GetCenterOfMassTransform(body: *JPH_Body, result: *JPH_Mat4);
	void JPH_Body_GetInverseCenterOfMassTransform(body: *JPH_Body, result: *JPH_Mat4);
	void JPH_Body_GetWorldSpaceBounds(body: *JPH_Body, result: *JPH_AABox);
	void JPH_Body_GetWorldSpaceSurfaceNormal(body: *JPH_Body, subShapeID: uint32, position: *JPH_Vec3, normal: *JPH_Vec3);
	*JPH_MotionProperties JPH_Body_GetMotionProperties(body: *JPH_Body);
	*JPH_MotionProperties JPH_Body_GetMotionPropertiesUnchecked(body: *JPH_Body);
	void JPH_Body_SetUserData(body: *JPH_Body, userData: uint64);
	uint64 JPH_Body_GetUserData(body: *JPH_Body);
	*JPH_Body JPH_Body_GetFixedToWorldBody();
	uint32 JPH_Body_GetSoftBodyVertexCount(body: *JPH_Body);
	void JPH_Body_GetSoftBodyVertexPosition(body: *JPH_Body, index: uint32, outPos: *JPH_Vec3);
	void JPH_Body_GetSoftBodyVertexPositions(body: *JPH_Body, outPositions: *JPH_Vec3, capacity: uint32, outCount: *uint32);
	void JPH_BroadPhaseLayerFilter_SetProcs(procs: *JPH_BroadPhaseLayerFilter_Procs);
	*JPH_BroadPhaseLayerFilter JPH_BroadPhaseLayerFilter_Create(userData: *void);
	void JPH_BroadPhaseLayerFilter_Destroy(filter: *JPH_BroadPhaseLayerFilter);
	void JPH_ObjectLayerFilter_SetProcs(procs: *JPH_ObjectLayerFilter_Procs);
	*JPH_ObjectLayerFilter JPH_ObjectLayerFilter_Create(userData: *void);
	void JPH_ObjectLayerFilter_Destroy(filter: *JPH_ObjectLayerFilter);
	void JPH_BodyFilter_SetProcs(procs: *JPH_BodyFilter_Procs);
	*JPH_BodyFilter JPH_BodyFilter_Create(userData: *void);
	void JPH_BodyFilter_Destroy(filter: *JPH_BodyFilter);
	void JPH_ShapeFilter_SetProcs(procs: *JPH_ShapeFilter_Procs);
	*JPH_ShapeFilter JPH_ShapeFilter_Create(userData: *void);
	void JPH_ShapeFilter_Destroy(filter: *JPH_ShapeFilter);
	uint32 JPH_ShapeFilter_GetBodyID2(filter: *JPH_ShapeFilter);
	void JPH_ShapeFilter_SetBodyID2(filter: *JPH_ShapeFilter, id: uint32);
	void JPH_SimShapeFilter_SetProcs(procs: *JPH_SimShapeFilter_Procs);
	*JPH_SimShapeFilter JPH_SimShapeFilter_Create(userData: *void);
	void JPH_SimShapeFilter_Destroy(filter: *JPH_SimShapeFilter);
	void JPH_ContactListener_SetProcs(procs: *JPH_ContactListener_Procs);
	*JPH_ContactListener JPH_ContactListener_Create(userData: *void);
	void JPH_ContactListener_Destroy(listener: *JPH_ContactListener);
	void JPH_BodyActivationListener_SetProcs(procs: *JPH_BodyActivationListener_Procs);
	*JPH_BodyActivationListener JPH_BodyActivationListener_Create(userData: *void);
	void JPH_BodyActivationListener_Destroy(listener: *JPH_BodyActivationListener);
	void JPH_BodyDrawFilter_SetProcs(procs: *JPH_BodyDrawFilter_Procs);
	*JPH_BodyDrawFilter JPH_BodyDrawFilter_Create(userData: *void);
	void JPH_BodyDrawFilter_Destroy(filter: *JPH_BodyDrawFilter);
	void JPH_ContactManifold_GetWorldSpaceNormal(manifold: *JPH_ContactManifold, result: *JPH_Vec3);
	float32 JPH_ContactManifold_GetPenetrationDepth(manifold: *JPH_ContactManifold);
	uint32 JPH_ContactManifold_GetSubShapeID1(manifold: *JPH_ContactManifold);
	uint32 JPH_ContactManifold_GetSubShapeID2(manifold: *JPH_ContactManifold);
	uint32 JPH_ContactManifold_GetPointCount(manifold: *JPH_ContactManifold);
	void JPH_ContactManifold_GetWorldSpaceContactPointOn1(manifold: *JPH_ContactManifold, index: uint32, result: *JPH_Vec3);
	void JPH_ContactManifold_GetWorldSpaceContactPointOn2(manifold: *JPH_ContactManifold, index: uint32, result: *JPH_Vec3);
	void JPH_CharacterBase_Destroy(character: *JPH_CharacterBase);
	float32 JPH_CharacterBase_GetCosMaxSlopeAngle(character: *JPH_CharacterBase);
	void JPH_CharacterBase_SetMaxSlopeAngle(character: *JPH_CharacterBase, maxSlopeAngle: float32);
	void JPH_CharacterBase_GetUp(character: *JPH_CharacterBase, result: *JPH_Vec3);
	void JPH_CharacterBase_SetUp(character: *JPH_CharacterBase, value: *JPH_Vec3);
	bool JPH_CharacterBase_IsSlopeTooSteep(character: *JPH_CharacterBase, value: *JPH_Vec3);
	*JPH_Shape JPH_CharacterBase_GetShape(character: *JPH_CharacterBase);
	JPH_GroundState JPH_CharacterBase_GetGroundState(character: *JPH_CharacterBase);
	bool JPH_CharacterBase_IsSupported(character: *JPH_CharacterBase);
	void JPH_CharacterBase_GetGroundPosition(character: *JPH_CharacterBase, position: *JPH_Vec3);
	void JPH_CharacterBase_GetGroundNormal(character: *JPH_CharacterBase, normal: *JPH_Vec3);
	void JPH_CharacterBase_GetGroundVelocity(character: *JPH_CharacterBase, velocity: *JPH_Vec3);
	*JPH_PhysicsMaterial JPH_CharacterBase_GetGroundMaterial(character: *JPH_CharacterBase);
	uint32 JPH_CharacterBase_GetGroundBodyId(character: *JPH_CharacterBase);
	uint32 JPH_CharacterBase_GetGroundSubShapeId(character: *JPH_CharacterBase);
	uint64 JPH_CharacterBase_GetGroundUserData(character: *JPH_CharacterBase);
	void JPH_CharacterSettings_Init(settings: *JPH_CharacterSettings);
	*JPH_Character JPH_Character_Create(settings: *JPH_CharacterSettings, position: *JPH_Vec3, rotation: *JPH_Quat, userData: uint64, system: *JPH_PhysicsSystem);
	void JPH_Character_AddToPhysicsSystem(character: *JPH_Character, activationMode: JPH_Activation, lockBodies: bool);
	void JPH_Character_RemoveFromPhysicsSystem(character: *JPH_Character, lockBodies: bool);
	void JPH_Character_Activate(character: *JPH_Character, lockBodies: bool);
	void JPH_Character_PostSimulation(character: *JPH_Character, maxSeparationDistance: float32, lockBodies: bool);
	void JPH_Character_SetLinearAndAngularVelocity(character: *JPH_Character, linearVelocity: *JPH_Vec3, angularVelocity: *JPH_Vec3, lockBodies: bool);
	void JPH_Character_GetLinearVelocity(character: *JPH_Character, result: *JPH_Vec3);
	void JPH_Character_SetLinearVelocity(character: *JPH_Character, value: *JPH_Vec3, lockBodies: bool);
	void JPH_Character_AddLinearVelocity(character: *JPH_Character, value: *JPH_Vec3, lockBodies: bool);
	void JPH_Character_AddImpulse(character: *JPH_Character, value: *JPH_Vec3, lockBodies: bool);
	uint32 JPH_Character_GetBodyID(character: *JPH_Character);
	void JPH_Character_GetPositionAndRotation(character: *JPH_Character, position: *JPH_Vec3, rotation: *JPH_Quat, lockBodies: bool);
	void JPH_Character_SetPositionAndRotation(character: *JPH_Character, position: *JPH_Vec3, rotation: *JPH_Quat, activationMode: JPH_Activation, lockBodies: bool);
	void JPH_Character_GetPosition(character: *JPH_Character, position: *JPH_Vec3, lockBodies: bool);
	void JPH_Character_SetPosition(character: *JPH_Character, position: *JPH_Vec3, activationMode: JPH_Activation, lockBodies: bool);
	void JPH_Character_GetRotation(character: *JPH_Character, rotation: *JPH_Quat, lockBodies: bool);
	void JPH_Character_SetRotation(character: *JPH_Character, rotation: *JPH_Quat, activationMode: JPH_Activation, lockBodies: bool);
	void JPH_Character_GetCenterOfMassPosition(character: *JPH_Character, result: *JPH_Vec3, lockBodies: bool);
	void JPH_Character_GetWorldTransform(character: *JPH_Character, result: *JPH_Mat4, lockBodies: bool);
	uint32 JPH_Character_GetLayer(character: *JPH_Character);
	void JPH_Character_SetLayer(character: *JPH_Character, value: uint32, lockBodies: bool);
	void JPH_Character_SetShape(character: *JPH_Character, shape: *JPH_Shape, maxPenetrationDepth: float32, lockBodies: bool);
	void JPH_CharacterVirtualSettings_Init(settings: *JPH_CharacterVirtualSettings);
	*JPH_CharacterVirtual JPH_CharacterVirtual_Create(settings: *JPH_CharacterVirtualSettings, position: *JPH_Vec3, rotation: *JPH_Quat, userData: uint64, system: *JPH_PhysicsSystem);
	uint32 JPH_CharacterVirtual_GetID(character: *JPH_CharacterVirtual);
	void JPH_CharacterVirtual_SetListener(character: *JPH_CharacterVirtual, listener: *JPH_CharacterContactListener);
	void JPH_CharacterVirtual_SetCharacterVsCharacterCollision(character: *JPH_CharacterVirtual, characterVsCharacterCollision: *JPH_CharacterVsCharacterCollision);
	void JPH_CharacterVirtual_GetLinearVelocity(character: *JPH_CharacterVirtual, velocity: *JPH_Vec3);
	void JPH_CharacterVirtual_SetLinearVelocity(character: *JPH_CharacterVirtual, velocity: *JPH_Vec3);
	void JPH_CharacterVirtual_GetPosition(character: *JPH_CharacterVirtual, position: *JPH_Vec3);
	void JPH_CharacterVirtual_SetPosition(character: *JPH_CharacterVirtual, position: *JPH_Vec3);
	void JPH_CharacterVirtual_GetRotation(character: *JPH_CharacterVirtual, rotation: *JPH_Quat);
	void JPH_CharacterVirtual_SetRotation(character: *JPH_CharacterVirtual, rotation: *JPH_Quat);
	void JPH_CharacterVirtual_GetWorldTransform(character: *JPH_CharacterVirtual, result: *JPH_Mat4);
	void JPH_CharacterVirtual_GetCenterOfMassTransform(character: *JPH_CharacterVirtual, result: *JPH_Mat4);
	float32 JPH_CharacterVirtual_GetMass(character: *JPH_CharacterVirtual);
	void JPH_CharacterVirtual_SetMass(character: *JPH_CharacterVirtual, value: float32);
	float32 JPH_CharacterVirtual_GetMaxStrength(character: *JPH_CharacterVirtual);
	void JPH_CharacterVirtual_SetMaxStrength(character: *JPH_CharacterVirtual, value: float32);
	float32 JPH_CharacterVirtual_GetPenetrationRecoverySpeed(character: *JPH_CharacterVirtual);
	void JPH_CharacterVirtual_SetPenetrationRecoverySpeed(character: *JPH_CharacterVirtual, value: float32);
	bool JPH_CharacterVirtual_GetEnhancedInternalEdgeRemoval(character: *JPH_CharacterVirtual);
	void JPH_CharacterVirtual_SetEnhancedInternalEdgeRemoval(character: *JPH_CharacterVirtual, value: bool);
	float32 JPH_CharacterVirtual_GetCharacterPadding(character: *JPH_CharacterVirtual);
	uint32 JPH_CharacterVirtual_GetMaxNumHits(character: *JPH_CharacterVirtual);
	void JPH_CharacterVirtual_SetMaxNumHits(character: *JPH_CharacterVirtual, value: uint32);
	float32 JPH_CharacterVirtual_GetHitReductionCosMaxAngle(character: *JPH_CharacterVirtual);
	void JPH_CharacterVirtual_SetHitReductionCosMaxAngle(character: *JPH_CharacterVirtual, value: float32);
	bool JPH_CharacterVirtual_GetMaxHitsExceeded(character: *JPH_CharacterVirtual);
	void JPH_CharacterVirtual_GetShapeOffset(character: *JPH_CharacterVirtual, result: *JPH_Vec3);
	void JPH_CharacterVirtual_SetShapeOffset(character: *JPH_CharacterVirtual, value: *JPH_Vec3);
	uint64 JPH_CharacterVirtual_GetUserData(character: *JPH_CharacterVirtual);
	void JPH_CharacterVirtual_SetUserData(character: *JPH_CharacterVirtual, value: uint64);
	uint32 JPH_CharacterVirtual_GetInnerBodyID(character: *JPH_CharacterVirtual);
	void JPH_CharacterVirtual_CancelVelocityTowardsSteepSlopes(character: *JPH_CharacterVirtual, desiredVelocity: *JPH_Vec3, velocity: *JPH_Vec3);
	void JPH_CharacterVirtual_StartTrackingContactChanges(character: *JPH_CharacterVirtual);
	void JPH_CharacterVirtual_FinishTrackingContactChanges(character: *JPH_CharacterVirtual);
	void JPH_CharacterVirtual_Update(character: *JPH_CharacterVirtual, deltaTime: float32, layer: uint32, system: *JPH_PhysicsSystem, bodyFilter: *JPH_BodyFilter, shapeFilter: *JPH_ShapeFilter);
	void JPH_CharacterVirtual_ExtendedUpdate(character: *JPH_CharacterVirtual, deltaTime: float32, settings: *JPH_ExtendedUpdateSettings, layer: uint32, system: *JPH_PhysicsSystem, bodyFilter: *JPH_BodyFilter, shapeFilter: *JPH_ShapeFilter);
	void JPH_CharacterVirtual_RefreshContacts(character: *JPH_CharacterVirtual, layer: uint32, system: *JPH_PhysicsSystem, bodyFilter: *JPH_BodyFilter, shapeFilter: *JPH_ShapeFilter);
	bool JPH_CharacterVirtual_CanWalkStairs(character: *JPH_CharacterVirtual, linearVelocity: *JPH_Vec3);
	bool JPH_CharacterVirtual_WalkStairs(character: *JPH_CharacterVirtual, deltaTime: float32, stepUp: *JPH_Vec3, stepForward: *JPH_Vec3, stepForwardTest: *JPH_Vec3, stepDownExtra: *JPH_Vec3, layer: uint32, system: *JPH_PhysicsSystem, bodyFilter: *JPH_BodyFilter, shapeFilter: *JPH_ShapeFilter);
	bool JPH_CharacterVirtual_StickToFloor(character: *JPH_CharacterVirtual, stepDown: *JPH_Vec3, layer: uint32, system: *JPH_PhysicsSystem, bodyFilter: *JPH_BodyFilter, shapeFilter: *JPH_ShapeFilter);
	void JPH_CharacterVirtual_UpdateGroundVelocity(character: *JPH_CharacterVirtual);
	bool JPH_CharacterVirtual_SetShape(character: *JPH_CharacterVirtual, shape: *JPH_Shape, maxPenetrationDepth: float32, layer: uint32, system: *JPH_PhysicsSystem, bodyFilter: *JPH_BodyFilter, shapeFilter: *JPH_ShapeFilter);
	void JPH_CharacterVirtual_SetInnerBodyShape(character: *JPH_CharacterVirtual, shape: *JPH_Shape);
	uint32 JPH_CharacterVirtual_GetNumActiveContacts(character: *JPH_CharacterVirtual);
	void JPH_CharacterVirtual_GetActiveContact(character: *JPH_CharacterVirtual, index: uint32, result: *JPH_CharacterContact);
	bool JPH_CharacterVirtual_HasCollidedWithBody(character: *JPH_CharacterVirtual, body: uint32);
	bool JPH_CharacterVirtual_HasCollidedWith(character: *JPH_CharacterVirtual, other: uint32);
	bool JPH_CharacterVirtual_HasCollidedWithCharacter(character: *JPH_CharacterVirtual, other: *JPH_CharacterVirtual);
	void JPH_CharacterContactListener_SetProcs(procs: *JPH_CharacterContactListener_Procs);
	*JPH_CharacterContactListener JPH_CharacterContactListener_Create(userData: *void);
	void JPH_CharacterContactListener_Destroy(listener: *JPH_CharacterContactListener);
	void JPH_CharacterVsCharacterCollision_SetProcs(procs: *JPH_CharacterVsCharacterCollision_Procs);
	*JPH_CharacterVsCharacterCollision JPH_CharacterVsCharacterCollision_Create(userData: *void);
	*JPH_CharacterVsCharacterCollision JPH_CharacterVsCharacterCollision_CreateSimple();
	void JPH_CharacterVsCharacterCollisionSimple_AddCharacter(characterVsCharacter: *JPH_CharacterVsCharacterCollision, character: *JPH_CharacterVirtual);
	void JPH_CharacterVsCharacterCollisionSimple_RemoveCharacter(characterVsCharacter: *JPH_CharacterVsCharacterCollision, character: *JPH_CharacterVirtual);
	void JPH_CharacterVsCharacterCollision_Destroy(listener: *JPH_CharacterVsCharacterCollision);
	bool JPH_CollisionDispatch_CollideShapeVsShape(shape1: *JPH_Shape, shape2: *JPH_Shape, scale1: *JPH_Vec3, scale2: *JPH_Vec3, centerOfMassTransform1: *JPH_Mat4, centerOfMassTransform2: *JPH_Mat4, collideShapeSettings: *JPH_CollideShapeSettings, callback: ::(), userData: *void, shapeFilter: *JPH_ShapeFilter);
	bool JPH_CollisionDispatch_CastShapeVsShapeLocalSpace(direction: *JPH_Vec3, shape1: *JPH_Shape, shape2: *JPH_Shape, scale1InShape2LocalSpace: *JPH_Vec3, scale2: *JPH_Vec3, centerOfMassTransform1InShape2LocalSpace: *JPH_Mat4, centerOfMassWorldTransform2: *JPH_Mat4, shapeCastSettings: *JPH_ShapeCastSettings, callback: ::(), userData: *void, shapeFilter: *JPH_ShapeFilter);
	bool JPH_CollisionDispatch_CastShapeVsShapeWorldSpace(direction: *JPH_Vec3, shape1: *JPH_Shape, shape2: *JPH_Shape, scale1: *JPH_Vec3, inScale2: *JPH_Vec3, centerOfMassWorldTransform1: *JPH_Mat4, centerOfMassWorldTransform2: *JPH_Mat4, shapeCastSettings: *JPH_ShapeCastSettings, callback: ::(), userData: *void, shapeFilter: *JPH_ShapeFilter);
	void JPH_DebugRenderer_SetProcs(procs: *JPH_DebugRenderer_Procs);
	*JPH_DebugRenderer JPH_DebugRenderer_Create(userData: *void);
	void JPH_DebugRenderer_Destroy(renderer: *JPH_DebugRenderer);
	void JPH_DebugRenderer_NextFrame(renderer: *JPH_DebugRenderer);
	void JPH_DebugRenderer_SetCameraPos(renderer: *JPH_DebugRenderer, position: *JPH_Vec3);
	void JPH_DebugRenderer_DrawLine(renderer: *JPH_DebugRenderer, from: *JPH_Vec3, to: *JPH_Vec3, color: uint32);
	void JPH_DebugRenderer_DrawWireBox(renderer: *JPH_DebugRenderer, box: *JPH_AABox, color: uint32);
	void JPH_DebugRenderer_DrawWireBox2(renderer: *JPH_DebugRenderer, matrix: *JPH_Mat4, box: *JPH_AABox, color: uint32);
	void JPH_DebugRenderer_DrawMarker(renderer: *JPH_DebugRenderer, position: *JPH_Vec3, color: uint32, size: float32);
	void JPH_DebugRenderer_DrawArrow(renderer: *JPH_DebugRenderer, from: *JPH_Vec3, to: *JPH_Vec3, color: uint32, size: float32);
	void JPH_DebugRenderer_DrawCoordinateSystem(renderer: *JPH_DebugRenderer, matrix: *JPH_Mat4, size: float32);
	void JPH_DebugRenderer_DrawPlane(renderer: *JPH_DebugRenderer, point: *JPH_Vec3, normal: *JPH_Vec3, color: uint32, size: float32);
	void JPH_DebugRenderer_DrawWireTriangle(renderer: *JPH_DebugRenderer, v1: *JPH_Vec3, v2: *JPH_Vec3, v3: *JPH_Vec3, color: uint32);
	void JPH_DebugRenderer_DrawWireSphere(renderer: *JPH_DebugRenderer, center: *JPH_Vec3, radius: float32, color: uint32, level: int32);
	void JPH_DebugRenderer_DrawWireUnitSphere(renderer: *JPH_DebugRenderer, matrix: *JPH_Mat4, color: uint32, level: int32);
	void JPH_DebugRenderer_DrawTriangle(renderer: *JPH_DebugRenderer, v1: *JPH_Vec3, v2: *JPH_Vec3, v3: *JPH_Vec3, color: uint32, castShadow: JPH_DebugRenderer_CastShadow);
	void JPH_DebugRenderer_DrawBox(renderer: *JPH_DebugRenderer, box: *JPH_AABox, color: uint32, castShadow: JPH_DebugRenderer_CastShadow, drawMode: JPH_DebugRenderer_DrawMode);
	void JPH_DebugRenderer_DrawBox2(renderer: *JPH_DebugRenderer, matrix: *JPH_Mat4, box: *JPH_AABox, color: uint32, castShadow: JPH_DebugRenderer_CastShadow, drawMode: JPH_DebugRenderer_DrawMode);
	void JPH_DebugRenderer_DrawSphere(renderer: *JPH_DebugRenderer, center: *JPH_Vec3, radius: float32, color: uint32, castShadow: JPH_DebugRenderer_CastShadow, drawMode: JPH_DebugRenderer_DrawMode);
	void JPH_DebugRenderer_DrawUnitSphere(renderer: *JPH_DebugRenderer, matrix: JPH_Mat4, color: uint32, castShadow: JPH_DebugRenderer_CastShadow, drawMode: JPH_DebugRenderer_DrawMode);
	void JPH_DebugRenderer_DrawCapsule(renderer: *JPH_DebugRenderer, matrix: *JPH_Mat4, halfHeightOfCylinder: float32, radius: float32, color: uint32, castShadow: JPH_DebugRenderer_CastShadow, drawMode: JPH_DebugRenderer_DrawMode);
	void JPH_DebugRenderer_DrawCylinder(renderer: *JPH_DebugRenderer, matrix: *JPH_Mat4, halfHeight: float32, radius: float32, color: uint32, castShadow: JPH_DebugRenderer_CastShadow, drawMode: JPH_DebugRenderer_DrawMode);
	void JPH_DebugRenderer_DrawOpenCone(renderer: *JPH_DebugRenderer, top: *JPH_Vec3, axis: *JPH_Vec3, perpendicular: *JPH_Vec3, halfAngle: float32, length: float32, color: uint32, castShadow: JPH_DebugRenderer_CastShadow, drawMode: JPH_DebugRenderer_DrawMode);
	void JPH_DebugRenderer_DrawSwingConeLimits(renderer: *JPH_DebugRenderer, matrix: *JPH_Mat4, swingYHalfAngle: float32, swingZHalfAngle: float32, edgeLength: float32, color: uint32, castShadow: JPH_DebugRenderer_CastShadow, drawMode: JPH_DebugRenderer_DrawMode);
	void JPH_DebugRenderer_DrawSwingPyramidLimits(renderer: *JPH_DebugRenderer, matrix: *JPH_Mat4, minSwingYAngle: float32, maxSwingYAngle: float32, minSwingZAngle: float32, maxSwingZAngle: float32, edgeLength: float32, color: uint32, castShadow: JPH_DebugRenderer_CastShadow, drawMode: JPH_DebugRenderer_DrawMode);
	void JPH_DebugRenderer_DrawPie(renderer: *JPH_DebugRenderer, center: *JPH_Vec3, radius: float32, normal: *JPH_Vec3, axis: *JPH_Vec3, minAngle: float32, maxAngle: float32, color: uint32, castShadow: JPH_DebugRenderer_CastShadow, drawMode: JPH_DebugRenderer_DrawMode);
	void JPH_DebugRenderer_DrawTaperedCylinder(renderer: *JPH_DebugRenderer, inMatrix: *JPH_Mat4, top: float32, bottom: float32, topRadius: float32, bottomRadius: float32, color: uint32, castShadow: JPH_DebugRenderer_CastShadow, drawMode: JPH_DebugRenderer_DrawMode);
	*JPH_Skeleton JPH_Skeleton_Create();
	void JPH_Skeleton_Destroy(skeleton: *JPH_Skeleton);
	uint32 JPH_Skeleton_AddJoint(skeleton: *JPH_Skeleton, name: *byte);
	uint32 JPH_Skeleton_AddJoint2(skeleton: *JPH_Skeleton, name: *byte, parentIndex: int32);
	uint32 JPH_Skeleton_AddJoint3(skeleton: *JPH_Skeleton, name: *byte, parentName: *byte);
	int32 JPH_Skeleton_GetJointCount(skeleton: *JPH_Skeleton);
	void JPH_Skeleton_GetJoint(skeleton: *JPH_Skeleton, index: int32, joint: *JPH_SkeletonJoint);
	int32 JPH_Skeleton_GetJointIndex(skeleton: *JPH_Skeleton, name: *byte);
	void JPH_Skeleton_CalculateParentJointIndices(skeleton: *JPH_Skeleton);
	bool JPH_Skeleton_AreJointsCorrectlyOrdered(skeleton: *JPH_Skeleton);
	*JPH_SkeletonPose JPH_SkeletonPose_Create();
	void JPH_SkeletonPose_Destroy(pose: *JPH_SkeletonPose);
	void JPH_SkeletonPose_SetSkeleton(pose: *JPH_SkeletonPose, skeleton: *JPH_Skeleton);
	*JPH_Skeleton JPH_SkeletonPose_GetSkeleton(pose: *JPH_SkeletonPose);
	void JPH_SkeletonPose_SetRootOffset(pose: *JPH_SkeletonPose, offset: *JPH_Vec3);
	void JPH_SkeletonPose_GetRootOffset(pose: *JPH_SkeletonPose, result: *JPH_Vec3);
	int32 JPH_SkeletonPose_GetJointCount(pose: *JPH_SkeletonPose);
	void JPH_SkeletonPose_GetJointState(pose: *JPH_SkeletonPose, index: int32, outTranslation: *JPH_Vec3, outRotation: *JPH_Quat);
	void JPH_SkeletonPose_SetJointState(pose: *JPH_SkeletonPose, index: int32, translation: *JPH_Vec3, rotation: *JPH_Quat);
	void JPH_SkeletonPose_GetJointMatrix(pose: *JPH_SkeletonPose, index: int32, result: *JPH_Mat4);
	void JPH_SkeletonPose_SetJointMatrix(pose: *JPH_SkeletonPose, index: int32, matrix: *JPH_Mat4);
	void JPH_SkeletonPose_GetJointMatrices(pose: *JPH_SkeletonPose, outMatrices: *JPH_Mat4, count: int32);
	void JPH_SkeletonPose_SetJointMatrices(pose: *JPH_SkeletonPose, matrices: *JPH_Mat4, count: int32);
	void JPH_SkeletonPose_CalculateJointMatrices(pose: *JPH_SkeletonPose);
	void JPH_SkeletonPose_CalculateJointStates(pose: *JPH_SkeletonPose);
	void JPH_SkeletonPose_CalculateLocalSpaceJointMatrices(pose: *JPH_SkeletonPose, outMatrices: *JPH_Mat4);
	*JPH_SkeletalAnimation JPH_SkeletalAnimation_Create();
	void JPH_SkeletalAnimation_Destroy(animation: *JPH_SkeletalAnimation);
	float32 JPH_SkeletalAnimation_GetDuration(animation: *JPH_SkeletalAnimation);
	bool JPH_SkeletalAnimation_IsLooping(animation: *JPH_SkeletalAnimation);
	void JPH_SkeletalAnimation_SetIsLooping(animation: *JPH_SkeletalAnimation, looping: bool);
	void JPH_SkeletalAnimation_ScaleJoints(animation: *JPH_SkeletalAnimation, scale: float32);
	void JPH_SkeletalAnimation_Sample(animation: *JPH_SkeletalAnimation, time: float32, pose: *JPH_SkeletonPose);
	int32 JPH_SkeletalAnimation_GetAnimatedJointCount(animation: *JPH_SkeletalAnimation);
	void JPH_SkeletalAnimation_AddAnimatedJoint(animation: *JPH_SkeletalAnimation, jointName: *byte);
	void JPH_SkeletalAnimation_AddKeyframe(animation: *JPH_SkeletalAnimation, jointIndex: int32, time: float32, translation: *JPH_Vec3, rotation: *JPH_Quat);
	*JPH_SkeletonMapper JPH_SkeletonMapper_Create();
	void JPH_SkeletonMapper_Destroy(mapper: *JPH_SkeletonMapper);
	void JPH_SkeletonMapper_Initialize(mapper: *JPH_SkeletonMapper, skeleton1: *JPH_Skeleton, neutralPose1: *JPH_Mat4, skeleton2: *JPH_Skeleton, neutralPose2: *JPH_Mat4);
	void JPH_SkeletonMapper_LockAllTranslations(mapper: *JPH_SkeletonMapper, skeleton2: *JPH_Skeleton, neutralPose2: *JPH_Mat4);
	void JPH_SkeletonMapper_LockTranslations(mapper: *JPH_SkeletonMapper, skeleton2: *JPH_Skeleton, lockedTranslations: *bool, neutralPose2: *JPH_Mat4);
	void JPH_SkeletonMapper_Map(mapper: *JPH_SkeletonMapper, pose1ModelSpace: *JPH_Mat4, pose2LocalSpace: *JPH_Mat4, outPose2ModelSpace: *JPH_Mat4);
	void JPH_SkeletonMapper_MapReverse(mapper: *JPH_SkeletonMapper, pose2ModelSpace: *JPH_Mat4, outPose1ModelSpace: *JPH_Mat4);
	int32 JPH_SkeletonMapper_GetMappedJointIndex(mapper: *JPH_SkeletonMapper, joint1Index: int32);
	bool JPH_SkeletonMapper_IsJointTranslationLocked(mapper: *JPH_SkeletonMapper, joint2Index: int32);
	*JPH_RagdollSettings JPH_RagdollSettings_Create();
	void JPH_RagdollSettings_Destroy(settings: *JPH_RagdollSettings);
	*JPH_Skeleton JPH_RagdollSettings_GetSkeleton(character: *JPH_RagdollSettings);
	void JPH_RagdollSettings_SetSkeleton(character: *JPH_RagdollSettings, skeleton: *JPH_Skeleton);
	bool JPH_RagdollSettings_Stabilize(settings: *JPH_RagdollSettings);
	void JPH_RagdollSettings_DisableParentChildCollisions(settings: *JPH_RagdollSettings, jointMatrices: *JPH_Mat4, minSeparationDistance: float32);
	void JPH_RagdollSettings_CalculateBodyIndexToConstraintIndex(settings: *JPH_RagdollSettings);
	int32 JPH_RagdollSettings_GetConstraintIndexForBodyIndex(settings: *JPH_RagdollSettings, bodyIndex: int32);
	void JPH_RagdollSettings_CalculateConstraintIndexToBodyIdxPair(settings: *JPH_RagdollSettings);
	void JPH_RagdollSettings_ResizeParts(settings: *JPH_RagdollSettings, count: int32);
	int32 JPH_RagdollSettings_GetPartCount(settings: *JPH_RagdollSettings);
	void JPH_RagdollSettings_SetPartShape(settings: *JPH_RagdollSettings, partIndex: int32, shape: *JPH_Shape);
	void JPH_RagdollSettings_SetPartPosition(settings: *JPH_RagdollSettings, partIndex: int32, position: *JPH_Vec3);
	void JPH_RagdollSettings_SetPartRotation(settings: *JPH_RagdollSettings, partIndex: int32, rotation: *JPH_Quat);
	void JPH_RagdollSettings_SetPartMotionType(settings: *JPH_RagdollSettings, partIndex: int32, motionType: JPH_MotionType);
	void JPH_RagdollSettings_SetPartObjectLayer(settings: *JPH_RagdollSettings, partIndex: int32, layer: uint32);
	void JPH_RagdollSettings_SetPartMassProperties(settings: *JPH_RagdollSettings, partIndex: int32, mass: float32);
	void JPH_RagdollSettings_SetPartToParent(settings: *JPH_RagdollSettings, partIndex: int32, constraintSettings: *JPH_SwingTwistConstraintSettings);
	*JPH_Ragdoll JPH_RagdollSettings_CreateRagdoll(settings: *JPH_RagdollSettings, system: *JPH_PhysicsSystem, collisionGroup: uint32, userData: uint64);
	void JPH_Ragdoll_Destroy(ragdoll: *JPH_Ragdoll);
	void JPH_Ragdoll_AddToPhysicsSystem(ragdoll: *JPH_Ragdoll, activationMode: JPH_Activation, lockBodies: bool);
	void JPH_Ragdoll_RemoveFromPhysicsSystem(ragdoll: *JPH_Ragdoll, lockBodies: bool);
	void JPH_Ragdoll_Activate(ragdoll: *JPH_Ragdoll, lockBodies: bool);
	bool JPH_Ragdoll_IsActive(ragdoll: *JPH_Ragdoll, lockBodies: bool);
	void JPH_Ragdoll_ResetWarmStart(ragdoll: *JPH_Ragdoll);
	void JPH_Ragdoll_SetPose(ragdoll: *JPH_Ragdoll, pose: *JPH_SkeletonPose, lockBodies: bool);
	void JPH_Ragdoll_SetPose2(ragdoll: *JPH_Ragdoll, rootOffset: *JPH_Vec3, jointMatrices: *JPH_Mat4, lockBodies: bool);
	void JPH_Ragdoll_GetPose(ragdoll: *JPH_Ragdoll, outPose: *JPH_SkeletonPose, lockBodies: bool);
	void JPH_Ragdoll_GetPose2(ragdoll: *JPH_Ragdoll, outRootOffset: *JPH_Vec3, outJointMatrices: *JPH_Mat4, lockBodies: bool);
	void JPH_Ragdoll_DriveToPoseUsingMotors(ragdoll: *JPH_Ragdoll, pose: *JPH_SkeletonPose);
	void JPH_Ragdoll_DriveToPoseUsingKinematics(ragdoll: *JPH_Ragdoll, pose: *JPH_SkeletonPose, deltaTime: float32, lockBodies: bool);
	int32 JPH_Ragdoll_GetBodyCount(ragdoll: *JPH_Ragdoll);
	uint32 JPH_Ragdoll_GetBodyID(ragdoll: *JPH_Ragdoll, bodyIndex: int32);
	int32 JPH_Ragdoll_GetConstraintCount(ragdoll: *JPH_Ragdoll);
	*JPH_TwoBodyConstraint JPH_Ragdoll_GetConstraint(ragdoll: *JPH_Ragdoll, constraintIndex: int32);
	void JPH_Ragdoll_GetRootTransform(ragdoll: *JPH_Ragdoll, outPosition: *JPH_Vec3, outRotation: *JPH_Quat, lockBodies: bool);
	*JPH_RagdollSettings JPH_Ragdoll_GetRagdollSettings(ragdoll: *JPH_Ragdoll);
	void JPH_EstimateCollisionResponse(body1: *JPH_Body, body2: *JPH_Body, manifold: *JPH_ContactManifold, combinedFriction: float32, combinedRestitution: float32, minVelocityForRestitution: float32, numIterations: uint32, result: *JPH_CollisionEstimationResult);
	void JPH_VehicleConstraintSettings_Init(settings: *JPH_VehicleConstraintSettings);
	*JPH_VehicleConstraint JPH_VehicleConstraint_Create(body: *JPH_Body, settings: *JPH_VehicleConstraintSettings);
	*JPH_PhysicsStepListener JPH_VehicleConstraint_AsPhysicsStepListener(constraint: *JPH_VehicleConstraint);
	void JPH_VehicleConstraint_SetMaxPitchRollAngle(constraint: *JPH_VehicleConstraint, maxPitchRollAngle: float32);
	void JPH_VehicleConstraint_SetVehicleCollisionTester(constraint: *JPH_VehicleConstraint, tester: *JPH_VehicleCollisionTester);
	void JPH_VehicleConstraint_OverrideGravity(constraint: *JPH_VehicleConstraint, value: *JPH_Vec3);
	bool JPH_VehicleConstraint_IsGravityOverridden(constraint: *JPH_VehicleConstraint);
	void JPH_VehicleConstraint_GetGravityOverride(constraint: *JPH_VehicleConstraint, result: *JPH_Vec3);
	void JPH_VehicleConstraint_ResetGravityOverride(constraint: *JPH_VehicleConstraint);
	void JPH_VehicleConstraint_GetLocalForward(constraint: *JPH_VehicleConstraint, result: *JPH_Vec3);
	void JPH_VehicleConstraint_GetLocalUp(constraint: *JPH_VehicleConstraint, result: *JPH_Vec3);
	void JPH_VehicleConstraint_GetWorldUp(constraint: *JPH_VehicleConstraint, result: *JPH_Vec3);
	*JPH_Body JPH_VehicleConstraint_GetVehicleBody(constraint: *JPH_VehicleConstraint);
	*JPH_VehicleController JPH_VehicleConstraint_GetController(constraint: *JPH_VehicleConstraint);
	uint32 JPH_VehicleConstraint_GetWheelsCount(constraint: *JPH_VehicleConstraint);
	*JPH_Wheel JPH_VehicleConstraint_GetWheel(constraint: *JPH_VehicleConstraint, index: uint32);
	void JPH_VehicleConstraint_GetWheelLocalBasis(constraint: *JPH_VehicleConstraint, wheel: *JPH_Wheel, outForward: *JPH_Vec3, outUp: *JPH_Vec3, outRight: *JPH_Vec3);
	void JPH_VehicleConstraint_GetWheelLocalTransform(constraint: *JPH_VehicleConstraint, wheelIndex: uint32, wheelRight: *JPH_Vec3, wheelUp: *JPH_Vec3, result: *JPH_Mat4);
	void JPH_VehicleConstraint_GetWheelWorldTransform(constraint: *JPH_VehicleConstraint, wheelIndex: uint32, wheelRight: *JPH_Vec3, wheelUp: *JPH_Vec3, result: *JPH_Mat4);
	*JPH_WheelSettings JPH_WheelSettings_Create();
	void JPH_WheelSettings_Destroy(settings: *JPH_WheelSettings);
	void JPH_WheelSettings_GetPosition(settings: *JPH_WheelSettings, result: *JPH_Vec3);
	void JPH_WheelSettings_SetPosition(settings: *JPH_WheelSettings, value: *JPH_Vec3);
	void JPH_WheelSettings_GetSuspensionForcePoint(settings: *JPH_WheelSettings, result: *JPH_Vec3);
	void JPH_WheelSettings_SetSuspensionForcePoint(settings: *JPH_WheelSettings, value: *JPH_Vec3);
	void JPH_WheelSettings_GetSuspensionDirection(settings: *JPH_WheelSettings, result: *JPH_Vec3);
	void JPH_WheelSettings_SetSuspensionDirection(settings: *JPH_WheelSettings, value: *JPH_Vec3);
	void JPH_WheelSettings_GetSteeringAxis(settings: *JPH_WheelSettings, result: *JPH_Vec3);
	void JPH_WheelSettings_SetSteeringAxis(settings: *JPH_WheelSettings, value: *JPH_Vec3);
	void JPH_WheelSettings_GetWheelUp(settings: *JPH_WheelSettings, result: *JPH_Vec3);
	void JPH_WheelSettings_SetWheelUp(settings: *JPH_WheelSettings, value: *JPH_Vec3);
	void JPH_WheelSettings_GetWheelForward(settings: *JPH_WheelSettings, result: *JPH_Vec3);
	void JPH_WheelSettings_SetWheelForward(settings: *JPH_WheelSettings, value: *JPH_Vec3);
	float32 JPH_WheelSettings_GetSuspensionMinLength(settings: *JPH_WheelSettings);
	void JPH_WheelSettings_SetSuspensionMinLength(settings: *JPH_WheelSettings, value: float32);
	float32 JPH_WheelSettings_GetSuspensionMaxLength(settings: *JPH_WheelSettings);
	void JPH_WheelSettings_SetSuspensionMaxLength(settings: *JPH_WheelSettings, value: float32);
	float32 JPH_WheelSettings_GetSuspensionPreloadLength(settings: *JPH_WheelSettings);
	void JPH_WheelSettings_SetSuspensionPreloadLength(settings: *JPH_WheelSettings, value: float32);
	void JPH_WheelSettings_GetSuspensionSpring(settings: *JPH_WheelSettings, result: *JPH_SpringSettings);
	void JPH_WheelSettings_SetSuspensionSpring(settings: *JPH_WheelSettings, springSettings: *JPH_SpringSettings);
	float32 JPH_WheelSettings_GetRadius(settings: *JPH_WheelSettings);
	void JPH_WheelSettings_SetRadius(settings: *JPH_WheelSettings, value: float32);
	float32 JPH_WheelSettings_GetWidth(settings: *JPH_WheelSettings);
	void JPH_WheelSettings_SetWidth(settings: *JPH_WheelSettings, value: float32);
	bool JPH_WheelSettings_GetEnableSuspensionForcePoint(settings: *JPH_WheelSettings);
	void JPH_WheelSettings_SetEnableSuspensionForcePoint(settings: *JPH_WheelSettings, value: bool);
	*JPH_Wheel JPH_Wheel_Create(settings: *JPH_WheelSettings);
	void JPH_Wheel_Destroy(wheel: *JPH_Wheel);
	*JPH_WheelSettings JPH_Wheel_GetSettings(wheel: *JPH_Wheel);
	float32 JPH_Wheel_GetAngularVelocity(wheel: *JPH_Wheel);
	void JPH_Wheel_SetAngularVelocity(wheel: *JPH_Wheel, value: float32);
	float32 JPH_Wheel_GetRotationAngle(wheel: *JPH_Wheel);
	void JPH_Wheel_SetRotationAngle(wheel: *JPH_Wheel, value: float32);
	float32 JPH_Wheel_GetSteerAngle(wheel: *JPH_Wheel);
	void JPH_Wheel_SetSteerAngle(wheel: *JPH_Wheel, value: float32);
	bool JPH_Wheel_HasContact(wheel: *JPH_Wheel);
	uint32 JPH_Wheel_GetContactBodyID(wheel: *JPH_Wheel);
	uint32 JPH_Wheel_GetContactSubShapeID(wheel: *JPH_Wheel);
	void JPH_Wheel_GetContactPosition(wheel: *JPH_Wheel, result: *JPH_Vec3);
	void JPH_Wheel_GetContactPointVelocity(wheel: *JPH_Wheel, result: *JPH_Vec3);
	void JPH_Wheel_GetContactNormal(wheel: *JPH_Wheel, result: *JPH_Vec3);
	void JPH_Wheel_GetContactLongitudinal(wheel: *JPH_Wheel, result: *JPH_Vec3);
	void JPH_Wheel_GetContactLateral(wheel: *JPH_Wheel, result: *JPH_Vec3);
	float32 JPH_Wheel_GetSuspensionLength(wheel: *JPH_Wheel);
	float32 JPH_Wheel_GetSuspensionLambda(wheel: *JPH_Wheel);
	float32 JPH_Wheel_GetLongitudinalLambda(wheel: *JPH_Wheel);
	float32 JPH_Wheel_GetLateralLambda(wheel: *JPH_Wheel);
	bool JPH_Wheel_HasHitHardPoint(wheel: *JPH_Wheel);
	void JPH_VehicleAntiRollBar_Init(antiRollBar: *JPH_VehicleAntiRollBar);
	void JPH_VehicleEngineSettings_Init(settings: *JPH_VehicleEngineSettings);
	void JPH_VehicleEngine_ClampRPM(engine: *JPH_VehicleEngine);
	float32 JPH_VehicleEngine_GetCurrentRPM(engine: *JPH_VehicleEngine);
	void JPH_VehicleEngine_SetCurrentRPM(engine: *JPH_VehicleEngine, rpm: float32);
	float32 JPH_VehicleEngine_GetAngularVelocity(engine: *JPH_VehicleEngine);
	float32 JPH_VehicleEngine_GetTorque(engine: *JPH_VehicleEngine, acceleration: float32);
	void JPH_VehicleEngine_ApplyTorque(engine: *JPH_VehicleEngine, torque: float32, deltaTime: float32);
	void JPH_VehicleEngine_ApplyDamping(engine: *JPH_VehicleEngine, deltaTime: float32);
	bool JPH_VehicleEngine_AllowSleep(engine: *JPH_VehicleEngine);
	void JPH_VehicleDifferentialSettings_Init(settings: *JPH_VehicleDifferentialSettings);
	*JPH_VehicleTransmissionSettings JPH_VehicleTransmissionSettings_Create();
	void JPH_VehicleTransmissionSettings_Destroy(settings: *JPH_VehicleTransmissionSettings);
	JPH_TransmissionMode JPH_VehicleTransmissionSettings_GetMode(settings: *JPH_VehicleTransmissionSettings);
	void JPH_VehicleTransmissionSettings_SetMode(settings: *JPH_VehicleTransmissionSettings, value: JPH_TransmissionMode);
	uint32 JPH_VehicleTransmissionSettings_GetGearRatioCount(settings: *JPH_VehicleTransmissionSettings);
	float32 JPH_VehicleTransmissionSettings_GetGearRatio(settings: *JPH_VehicleTransmissionSettings, index: uint32);
	void JPH_VehicleTransmissionSettings_SetGearRatio(settings: *JPH_VehicleTransmissionSettings, index: uint32, value: float32);
	*float32 JPH_VehicleTransmissionSettings_GetGearRatios(settings: *JPH_VehicleTransmissionSettings);
	void JPH_VehicleTransmissionSettings_SetGearRatios(settings: *JPH_VehicleTransmissionSettings, values: *float32, count: uint32);
	uint32 JPH_VehicleTransmissionSettings_GetReverseGearRatioCount(settings: *JPH_VehicleTransmissionSettings);
	float32 JPH_VehicleTransmissionSettings_GetReverseGearRatio(settings: *JPH_VehicleTransmissionSettings, index: uint32);
	void JPH_VehicleTransmissionSettings_SetReverseGearRatio(settings: *JPH_VehicleTransmissionSettings, index: uint32, value: float32);
	*float32 JPH_VehicleTransmissionSettings_GetReverseGearRatios(settings: *JPH_VehicleTransmissionSettings);
	void JPH_VehicleTransmissionSettings_SetReverseGearRatios(settings: *JPH_VehicleTransmissionSettings, values: *float32, count: uint32);
	float32 JPH_VehicleTransmissionSettings_GetSwitchTime(settings: *JPH_VehicleTransmissionSettings);
	void JPH_VehicleTransmissionSettings_SetSwitchTime(settings: *JPH_VehicleTransmissionSettings, value: float32);
	float32 JPH_VehicleTransmissionSettings_GetClutchReleaseTime(settings: *JPH_VehicleTransmissionSettings);
	void JPH_VehicleTransmissionSettings_SetClutchReleaseTime(settings: *JPH_VehicleTransmissionSettings, value: float32);
	float32 JPH_VehicleTransmissionSettings_GetSwitchLatency(settings: *JPH_VehicleTransmissionSettings);
	void JPH_VehicleTransmissionSettings_SetSwitchLatency(settings: *JPH_VehicleTransmissionSettings, value: float32);
	float32 JPH_VehicleTransmissionSettings_GetShiftUpRPM(settings: *JPH_VehicleTransmissionSettings);
	void JPH_VehicleTransmissionSettings_SetShiftUpRPM(settings: *JPH_VehicleTransmissionSettings, value: float32);
	float32 JPH_VehicleTransmissionSettings_GetShiftDownRPM(settings: *JPH_VehicleTransmissionSettings);
	void JPH_VehicleTransmissionSettings_SetShiftDownRPM(settings: *JPH_VehicleTransmissionSettings, value: float32);
	float32 JPH_VehicleTransmissionSettings_GetClutchStrength(settings: *JPH_VehicleTransmissionSettings);
	void JPH_VehicleTransmissionSettings_SetClutchStrength(settings: *JPH_VehicleTransmissionSettings, value: float32);
	void JPH_VehicleTransmission_SetMode(transmission: *JPH_VehicleTransmission, mode: JPH_TransmissionMode);
	void JPH_VehicleTransmission_Set(transmission: *JPH_VehicleTransmission, currentGear: int32, clutchFriction: float32);
	void JPH_VehicleTransmission_Update(transmission: *JPH_VehicleTransmission, deltaTime: float32, currentRPM: float32, forwardInput: float32, canShiftUp: bool);
	int32 JPH_VehicleTransmission_GetCurrentGear(transmission: *JPH_VehicleTransmission);
	float32 JPH_VehicleTransmission_GetClutchFriction(transmission: *JPH_VehicleTransmission);
	bool JPH_VehicleTransmission_IsSwitchingGear(transmission: *JPH_VehicleTransmission);
	float32 JPH_VehicleTransmission_GetCurrentRatio(transmission: *JPH_VehicleTransmission);
	bool JPH_VehicleTransmission_AllowSleep(transmission: *JPH_VehicleTransmission);
	void JPH_VehicleCollisionTester_Destroy(tester: *JPH_VehicleCollisionTester);
	uint32 JPH_VehicleCollisionTester_GetObjectLayer(tester: *JPH_VehicleCollisionTester);
	void JPH_VehicleCollisionTester_SetObjectLayer(tester: *JPH_VehicleCollisionTester, value: uint32);
	*JPH_VehicleCollisionTesterRay JPH_VehicleCollisionTesterRay_Create(layer: uint32, up: *JPH_Vec3, maxSlopeAngle: float32);
	*JPH_VehicleCollisionTesterCastSphere JPH_VehicleCollisionTesterCastSphere_Create(layer: uint32, radius: float32, up: *JPH_Vec3, maxSlopeAngle: float32);
	*JPH_VehicleCollisionTesterCastCylinder JPH_VehicleCollisionTesterCastCylinder_Create(layer: uint32, convexRadiusFraction: float32);
	void JPH_VehicleControllerSettings_Destroy(settings: *JPH_VehicleControllerSettings);
	*JPH_VehicleConstraint JPH_VehicleController_GetConstraint(controller: *JPH_VehicleController);
	*JPH_WheelSettingsWV JPH_WheelSettingsWV_Create();
	float32 JPH_WheelSettingsWV_GetInertia(settings: *JPH_WheelSettingsWV);
	void JPH_WheelSettingsWV_SetInertia(settings: *JPH_WheelSettingsWV, value: float32);
	float32 JPH_WheelSettingsWV_GetAngularDamping(settings: *JPH_WheelSettingsWV);
	void JPH_WheelSettingsWV_SetAngularDamping(settings: *JPH_WheelSettingsWV, value: float32);
	float32 JPH_WheelSettingsWV_GetMaxSteerAngle(settings: *JPH_WheelSettingsWV);
	void JPH_WheelSettingsWV_SetMaxSteerAngle(settings: *JPH_WheelSettingsWV, value: float32);
	*JPH_LinearCurve JPH_WheelSettingsWV_GetLongitudinalFriction(settings: *JPH_WheelSettingsWV);
	void JPH_WheelSettingsWV_SetLongitudinalFriction(settings: *JPH_WheelSettingsWV, value: *JPH_LinearCurve);
	*JPH_LinearCurve JPH_WheelSettingsWV_GetLateralFriction(settings: *JPH_WheelSettingsWV);
	void JPH_WheelSettingsWV_SetLateralFriction(settings: *JPH_WheelSettingsWV, value: *JPH_LinearCurve);
	float32 JPH_WheelSettingsWV_GetMaxBrakeTorque(settings: *JPH_WheelSettingsWV);
	void JPH_WheelSettingsWV_SetMaxBrakeTorque(settings: *JPH_WheelSettingsWV, value: float32);
	float32 JPH_WheelSettingsWV_GetMaxHandBrakeTorque(settings: *JPH_WheelSettingsWV);
	void JPH_WheelSettingsWV_SetMaxHandBrakeTorque(settings: *JPH_WheelSettingsWV, value: float32);
	*JPH_WheelWV JPH_WheelWV_Create(settings: *JPH_WheelSettingsWV);
	*JPH_WheelSettingsWV JPH_WheelWV_GetSettings(wheel: *JPH_WheelWV);
	void JPH_WheelWV_ApplyTorque(wheel: *JPH_WheelWV, torque: float32, deltaTime: float32);
	*JPH_WheeledVehicleControllerSettings JPH_WheeledVehicleControllerSettings_Create();
	void JPH_WheeledVehicleControllerSettings_GetEngine(settings: *JPH_WheeledVehicleControllerSettings, result: *JPH_VehicleEngineSettings);
	void JPH_WheeledVehicleControllerSettings_SetEngine(settings: *JPH_WheeledVehicleControllerSettings, value: *JPH_VehicleEngineSettings);
	*JPH_VehicleTransmissionSettings JPH_WheeledVehicleControllerSettings_GetTransmission(settings: *JPH_WheeledVehicleControllerSettings);
	void JPH_WheeledVehicleControllerSettings_SetTransmission(settings: *JPH_WheeledVehicleControllerSettings, value: *JPH_VehicleTransmissionSettings);
	uint32 JPH_WheeledVehicleControllerSettings_GetDifferentialsCount(settings: *JPH_WheeledVehicleControllerSettings);
	void JPH_WheeledVehicleControllerSettings_SetDifferentialsCount(settings: *JPH_WheeledVehicleControllerSettings, count: uint32);
	void JPH_WheeledVehicleControllerSettings_GetDifferential(settings: *JPH_WheeledVehicleControllerSettings, index: uint32, result: *JPH_VehicleDifferentialSettings);
	void JPH_WheeledVehicleControllerSettings_SetDifferential(settings: *JPH_WheeledVehicleControllerSettings, index: uint32, value: *JPH_VehicleDifferentialSettings);
	void JPH_WheeledVehicleControllerSettings_SetDifferentials(settings: *JPH_WheeledVehicleControllerSettings, values: *JPH_VehicleDifferentialSettings, count: uint32);
	void JPH_WheeledVehicleControllerSettings_AddDifferential(settings: *JPH_WheeledVehicleControllerSettings, leftWheel: int32, rightWheel: int32);
	float32 JPH_WheeledVehicleControllerSettings_GetDifferentialLimitedSlipRatio(settings: *JPH_WheeledVehicleControllerSettings);
	void JPH_WheeledVehicleControllerSettings_SetDifferentialLimitedSlipRatio(settings: *JPH_WheeledVehicleControllerSettings, value: float32);
	void JPH_WheeledVehicleController_SetDriverInput(controller: *JPH_WheeledVehicleController, forward: float32, right: float32, brake: float32, handBrake: float32);
	void JPH_WheeledVehicleController_SetForwardInput(controller: *JPH_WheeledVehicleController, forward: float32);
	float32 JPH_WheeledVehicleController_GetForwardInput(controller: *JPH_WheeledVehicleController);
	void JPH_WheeledVehicleController_SetRightInput(controller: *JPH_WheeledVehicleController, rightRatio: float32);
	float32 JPH_WheeledVehicleController_GetRightInput(controller: *JPH_WheeledVehicleController);
	void JPH_WheeledVehicleController_SetBrakeInput(controller: *JPH_WheeledVehicleController, brakeInput: float32);
	float32 JPH_WheeledVehicleController_GetBrakeInput(controller: *JPH_WheeledVehicleController);
	void JPH_WheeledVehicleController_SetHandBrakeInput(controller: *JPH_WheeledVehicleController, handBrakeInput: float32);
	float32 JPH_WheeledVehicleController_GetHandBrakeInput(controller: *JPH_WheeledVehicleController);
	float32 JPH_WheeledVehicleController_GetWheelSpeedAtClutch(controller: *JPH_WheeledVehicleController);
	void JPH_WheeledVehicleController_SetTireMaxImpulseCallback(controller: *JPH_WheeledVehicleController, tireMaxImpulseCallback: ::(), userData: *void);
	*JPH_VehicleEngine JPH_WheeledVehicleController_GetEngine(controller: *JPH_WheeledVehicleController);
	*JPH_VehicleTransmission JPH_WheeledVehicleController_GetTransmission(controller: *JPH_WheeledVehicleController);
	void JPH_VehicleTrackSettings_Init(settings: *JPH_VehicleTrackSettings);
	float32 JPH_VehicleTrack_GetAngularVelocity(track: *JPH_VehicleTrack);
	void JPH_VehicleTrack_SetAngularVelocity(track: *JPH_VehicleTrack, velocity: float32);
	uint32 JPH_VehicleTrack_GetDrivenWheel(track: *JPH_VehicleTrack);
	float32 JPH_VehicleTrack_GetInertia(track: *JPH_VehicleTrack);
	float32 JPH_VehicleTrack_GetAngularDamping(track: *JPH_VehicleTrack);
	float32 JPH_VehicleTrack_GetMaxBrakeTorque(track: *JPH_VehicleTrack);
	float32 JPH_VehicleTrack_GetDifferentialRatio(track: *JPH_VehicleTrack);
	*JPH_VehicleTrack JPH_TrackedVehicleController_GetTrack(controller: *JPH_TrackedVehicleController, side: JPH_TrackSide);
	*JPH_WheelSettingsTV JPH_WheelSettingsTV_Create();
	float32 JPH_WheelSettingsTV_GetLongitudinalFriction(settings: *JPH_WheelSettingsTV);
	void JPH_WheelSettingsTV_SetLongitudinalFriction(settings: *JPH_WheelSettingsTV, value: float32);
	float32 JPH_WheelSettingsTV_GetLateralFriction(settings: *JPH_WheelSettingsTV);
	void JPH_WheelSettingsTV_SetLateralFriction(settings: *JPH_WheelSettingsTV, value: float32);
	*JPH_WheelTV JPH_WheelTV_Create(settings: *JPH_WheelSettingsTV);
	*JPH_WheelSettingsTV JPH_WheelTV_GetSettings(wheel: *JPH_WheelTV);
	*JPH_TrackedVehicleControllerSettings JPH_TrackedVehicleControllerSettings_Create();
	void JPH_TrackedVehicleControllerSettings_GetEngine(settings: *JPH_TrackedVehicleControllerSettings, result: *JPH_VehicleEngineSettings);
	void JPH_TrackedVehicleControllerSettings_SetEngine(settings: *JPH_TrackedVehicleControllerSettings, value: *JPH_VehicleEngineSettings);
	*JPH_VehicleTransmissionSettings JPH_TrackedVehicleControllerSettings_GetTransmission(settings: *JPH_TrackedVehicleControllerSettings);
	void JPH_TrackedVehicleControllerSettings_SetTransmission(settings: *JPH_TrackedVehicleControllerSettings, value: *JPH_VehicleTransmissionSettings);
	void JPH_TrackedVehicleControllerSettings_SetTrack(settings: *JPH_TrackedVehicleControllerSettings, index: uint32, track: *JPH_VehicleTrackSettings);
	void JPH_TrackedVehicleController_SetDriverInput(controller: *JPH_TrackedVehicleController, forward: float32, leftRatio: float32, rightRatio: float32, brake: float32);
	float32 JPH_TrackedVehicleController_GetForwardInput(controller: *JPH_TrackedVehicleController);
	void JPH_TrackedVehicleController_SetForwardInput(controller: *JPH_TrackedVehicleController, value: float32);
	float32 JPH_TrackedVehicleController_GetLeftRatio(controller: *JPH_TrackedVehicleController);
	void JPH_TrackedVehicleController_SetLeftRatio(controller: *JPH_TrackedVehicleController, value: float32);
	float32 JPH_TrackedVehicleController_GetRightRatio(controller: *JPH_TrackedVehicleController);
	void JPH_TrackedVehicleController_SetRightRatio(controller: *JPH_TrackedVehicleController, value: float32);
	float32 JPH_TrackedVehicleController_GetBrakeInput(controller: *JPH_TrackedVehicleController);
	void JPH_TrackedVehicleController_SetBrakeInput(controller: *JPH_TrackedVehicleController, value: float32);
	*JPH_VehicleEngine JPH_TrackedVehicleController_GetEngine(controller: *JPH_TrackedVehicleController);
	*JPH_VehicleTransmission JPH_TrackedVehicleController_GetTransmission(controller: *JPH_TrackedVehicleController);
	*JPH_MotorcycleControllerSettings JPH_MotorcycleControllerSettings_Create();
	float32 JPH_MotorcycleControllerSettings_GetMaxLeanAngle(settings: *JPH_MotorcycleControllerSettings);
	void JPH_MotorcycleControllerSettings_SetMaxLeanAngle(settings: *JPH_MotorcycleControllerSettings, value: float32);
	float32 JPH_MotorcycleControllerSettings_GetLeanSpringConstant(settings: *JPH_MotorcycleControllerSettings);
	void JPH_MotorcycleControllerSettings_SetLeanSpringConstant(settings: *JPH_MotorcycleControllerSettings, value: float32);
	float32 JPH_MotorcycleControllerSettings_GetLeanSpringDamping(settings: *JPH_MotorcycleControllerSettings);
	void JPH_MotorcycleControllerSettings_SetLeanSpringDamping(settings: *JPH_MotorcycleControllerSettings, value: float32);
	float32 JPH_MotorcycleControllerSettings_GetLeanSpringIntegrationCoefficient(settings: *JPH_MotorcycleControllerSettings);
	void JPH_MotorcycleControllerSettings_SetLeanSpringIntegrationCoefficient(settings: *JPH_MotorcycleControllerSettings, value: float32);
	float32 JPH_MotorcycleControllerSettings_GetLeanSpringIntegrationCoefficientDecay(settings: *JPH_MotorcycleControllerSettings);
	void JPH_MotorcycleControllerSettings_SetLeanSpringIntegrationCoefficientDecay(settings: *JPH_MotorcycleControllerSettings, value: float32);
	float32 JPH_MotorcycleControllerSettings_GetLeanSmoothingFactor(settings: *JPH_MotorcycleControllerSettings);
	void JPH_MotorcycleControllerSettings_SetLeanSmoothingFactor(settings: *JPH_MotorcycleControllerSettings, value: float32);
	float32 JPH_MotorcycleController_GetWheelBase(controller: *JPH_MotorcycleController);
	bool JPH_MotorcycleController_IsLeanControllerEnabled(controller: *JPH_MotorcycleController);
	void JPH_MotorcycleController_EnableLeanController(controller: *JPH_MotorcycleController, value: bool);
	bool JPH_MotorcycleController_IsLeanSteeringLimitEnabled(controller: *JPH_MotorcycleController);
	void JPH_MotorcycleController_EnableLeanSteeringLimit(controller: *JPH_MotorcycleController, value: bool);
	float32 JPH_MotorcycleController_GetLeanSpringConstant(controller: *JPH_MotorcycleController);
	void JPH_MotorcycleController_SetLeanSpringConstant(controller: *JPH_MotorcycleController, value: float32);
	float32 JPH_MotorcycleController_GetLeanSpringDamping(controller: *JPH_MotorcycleController);
	void JPH_MotorcycleController_SetLeanSpringDamping(controller: *JPH_MotorcycleController, value: float32);
	float32 JPH_MotorcycleController_GetLeanSpringIntegrationCoefficient(controller: *JPH_MotorcycleController);
	void JPH_MotorcycleController_SetLeanSpringIntegrationCoefficient(controller: *JPH_MotorcycleController, value: float32);
	float32 JPH_MotorcycleController_GetLeanSpringIntegrationCoefficientDecay(controller: *JPH_MotorcycleController);
	void JPH_MotorcycleController_SetLeanSpringIntegrationCoefficientDecay(controller: *JPH_MotorcycleController, value: float32);
	float32 JPH_MotorcycleController_GetLeanSmoothingFactor(controller: *JPH_MotorcycleController);
	void JPH_MotorcycleController_SetLeanSmoothingFactor(controller: *JPH_MotorcycleController, value: float32);
	*JPH_LinearCurve JPH_LinearCurve_Create();
	void JPH_LinearCurve_Destroy(curve: *JPH_LinearCurve);
	void JPH_LinearCurve_Clear(curve: *JPH_LinearCurve);
	void JPH_LinearCurve_Reserve(curve: *JPH_LinearCurve, numPoints: uint32);
	void JPH_LinearCurve_AddPoint(curve: *JPH_LinearCurve, x: float32, y: float32);
	void JPH_LinearCurve_Sort(curve: *JPH_LinearCurve);
	float32 JPH_LinearCurve_GetMinX(curve: *JPH_LinearCurve);
	float32 JPH_LinearCurve_GetMaxX(curve: *JPH_LinearCurve);
	float32 JPH_LinearCurve_GetValue(curve: *JPH_LinearCurve, x: float32);
	uint32 JPH_LinearCurve_GetPointCount(curve: *JPH_LinearCurve);
	void JPH_LinearCurve_GetPoint(curve: *JPH_LinearCurve, index: uint32, result: *JPH_Point);
	void JPH_LinearCurve_GetPoints(curve: *JPH_LinearCurve, points: *JPH_Point, count: *uint32);
	*JPH_TempAllocator JPH_TempAllocator_Create(size: uint32);
	*JPH_TempAllocator JPH_TempAllocatorMalloc_Create();
	void JPH_TempAllocator_Destroy(allocator: *JPH_TempAllocator);
	JPH_PhysicsUpdateError JPH_PhysicsSystem_Update2(system: *JPH_PhysicsSystem, deltaTime: float32, collisionSteps: int32, tempAllocator: *JPH_TempAllocator, jobSystem: *JPH_JobSystem);
}

enum JPH_PhysicsUpdateError: uint32
{
	JPH_PhysicsUpdateError_None = 0,
	JPH_PhysicsUpdateError_ManifoldCacheFull = 1,
	JPH_PhysicsUpdateError_BodyPairCacheFull = 2,
	JPH_PhysicsUpdateError_ContactConstraintsFull = 4,
	_JPH_PhysicsUpdateError_Count = 5,
	_JPH_PhysicsUpdateError_Force32 = 2147483647
}

enum JPH_BodyType: uint32
{
	JPH_BodyType_Rigid = 0,
	JPH_BodyType_Soft = 1,
	_JPH_BodyType_Count = 2,
	_JPH_BodyType_Force32 = 2147483647
}

enum JPH_MotionType: uint32
{
	JPH_MotionType_Static = 0,
	JPH_MotionType_Kinematic = 1,
	JPH_MotionType_Dynamic = 2,
	_JPH_MotionType_Count = 3,
	_JPH_MotionType_Force32 = 2147483647
}

enum JPH_Activation: uint32
{
	JPH_Activation_Activate = 0,
	JPH_Activation_DontActivate = 1,
	_JPH_Activation_Count = 2,
	_JPH_Activation_Force32 = 2147483647
}

enum JPH_ValidateResult: uint32
{
	JPH_ValidateResult_AcceptAllContactsForThisBodyPair = 0,
	JPH_ValidateResult_AcceptContact = 1,
	JPH_ValidateResult_RejectContact = 2,
	JPH_ValidateResult_RejectAllContactsForThisBodyPair = 3,
	_JPH_ValidateResult_Count = 4,
	_JPH_ValidateResult_Force32 = 2147483647
}

enum JPH_ShapeType: uint32
{
	JPH_ShapeType_Convex = 0,
	JPH_ShapeType_Compound = 1,
	JPH_ShapeType_Decorated = 2,
	JPH_ShapeType_Mesh = 3,
	JPH_ShapeType_HeightField = 4,
	JPH_ShapeType_SoftBody = 5,
	JPH_ShapeType_User1 = 6,
	JPH_ShapeType_User2 = 7,
	JPH_ShapeType_User3 = 8,
	JPH_ShapeType_User4 = 9,
	_JPH_ShapeType_Count = 10,
	_JPH_ShapeType_Force32 = 2147483647
}

enum JPH_ShapeSubType: uint32
{
	JPH_ShapeSubType_Sphere = 0,
	JPH_ShapeSubType_Box = 1,
	JPH_ShapeSubType_Triangle = 2,
	JPH_ShapeSubType_Capsule = 3,
	JPH_ShapeSubType_TaperedCapsule = 4,
	JPH_ShapeSubType_Cylinder = 5,
	JPH_ShapeSubType_ConvexHull = 6,
	JPH_ShapeSubType_StaticCompound = 7,
	JPH_ShapeSubType_MutableCompound = 8,
	JPH_ShapeSubType_RotatedTranslated = 9,
	JPH_ShapeSubType_Scaled = 10,
	JPH_ShapeSubType_OffsetCenterOfMass = 11,
	JPH_ShapeSubType_Mesh = 12,
	JPH_ShapeSubType_HeightField = 13,
	JPH_ShapeSubType_SoftBody = 14,
	_JPH_ShapeSubType_Count = 15,
	_JPH_ShapeSubType_Force32 = 2147483647
}

enum JPH_ConstraintType: uint32
{
	JPH_ConstraintType_Constraint = 0,
	JPH_ConstraintType_TwoBodyConstraint = 1,
	_JPH_ConstraintType_Count = 2,
	_JPH_ConstraintType_Force32 = 2147483647
}

enum JPH_ConstraintSubType: uint32
{
	JPH_ConstraintSubType_Fixed = 0,
	JPH_ConstraintSubType_Point = 1,
	JPH_ConstraintSubType_Hinge = 2,
	JPH_ConstraintSubType_Slider = 3,
	JPH_ConstraintSubType_Distance = 4,
	JPH_ConstraintSubType_Cone = 5,
	JPH_ConstraintSubType_SwingTwist = 6,
	JPH_ConstraintSubType_SixDOF = 7,
	JPH_ConstraintSubType_Path = 8,
	JPH_ConstraintSubType_Vehicle = 9,
	JPH_ConstraintSubType_RackAndPinion = 10,
	JPH_ConstraintSubType_Gear = 11,
	JPH_ConstraintSubType_Pulley = 12,
	JPH_ConstraintSubType_User1 = 13,
	JPH_ConstraintSubType_User2 = 14,
	JPH_ConstraintSubType_User3 = 15,
	JPH_ConstraintSubType_User4 = 16,
	_JPH_ConstraintSubType_Count = 17,
	_JPH_ConstraintSubType_Force32 = 2147483647
}

enum JPH_ConstraintSpace: uint32
{
	JPH_ConstraintSpace_LocalToBodyCOM = 0,
	JPH_ConstraintSpace_WorldSpace = 1,
	_JPH_ConstraintSpace_Count = 2,
	_JPH_ConstraintSpace_Force32 = 2147483647
}

enum JPH_MotionQuality: uint32
{
	JPH_MotionQuality_Discrete = 0,
	JPH_MotionQuality_LinearCast = 1,
	_JPH_MotionQuality_Count = 2,
	_JPH_MotionQuality_Force32 = 2147483647
}

enum JPH_OverrideMassProperties: uint32
{
	JPH_OverrideMassProperties_CalculateMassAndInertia = 0,
	JPH_OverrideMassProperties_CalculateInertia = 1,
	JPH_OverrideMassProperties_MassAndInertiaProvided = 2,
	_JPH_JPH_OverrideMassProperties_Count = 3,
	_JPH_JPH_OverrideMassProperties_Force32 = 2147483647
}

enum JPH_AllowedDOFs: uint32
{
	JPH_AllowedDOFs_All = 63,
	JPH_AllowedDOFs_TranslationX = 1,
	JPH_AllowedDOFs_TranslationY = 2,
	JPH_AllowedDOFs_TranslationZ = 4,
	JPH_AllowedDOFs_RotationX = 8,
	JPH_AllowedDOFs_RotationY = 16,
	JPH_AllowedDOFs_RotationZ = 32,
	JPH_AllowedDOFs_Plane2D = 35,
	_JPH_AllowedDOFs_Count = 36,
	_JPH_AllowedDOFs_Force32 = 2147483647
}

enum JPH_GroundState: uint32
{
	JPH_GroundState_OnGround = 0,
	JPH_GroundState_OnSteepGround = 1,
	JPH_GroundState_NotSupported = 2,
	JPH_GroundState_InAir = 3,
	_JPH_GroundState_Count = 4,
	_JPH_GroundState_Force32 = 2147483647
}

enum JPH_BackFaceMode: uint32
{
	JPH_BackFaceMode_IgnoreBackFaces = 0,
	JPH_BackFaceMode_CollideWithBackFaces = 1,
	_JPH_BackFaceMode_Count = 2,
	_JPH_BackFaceMode_Force32 = 2147483647
}

enum JPH_ActiveEdgeMode: uint32
{
	JPH_ActiveEdgeMode_CollideOnlyWithActive = 0,
	JPH_ActiveEdgeMode_CollideWithAll = 1,
	_JPH_ActiveEdgeMode_Count = 2,
	_JPH_ActiveEdgeMode_Force32 = 2147483647
}

enum JPH_CollectFacesMode: uint32
{
	JPH_CollectFacesMode_CollectFaces = 0,
	JPH_CollectFacesMode_NoFaces = 1,
	_JPH_CollectFacesMode_Count = 2,
	_JPH_CollectFacesMode_Force32 = 2147483647
}

enum JPH_MotorState: uint32
{
	JPH_MotorState_Off = 0,
	JPH_MotorState_Velocity = 1,
	JPH_MotorState_Position = 2,
	_JPH_MotorState_Count = 3,
	_JPH_MotorState_Force32 = 2147483647
}

enum JPH_CollisionCollectorType: uint32
{
	JPH_CollisionCollectorType_AllHit = 0,
	JPH_CollisionCollectorType_AllHitSorted = 1,
	JPH_CollisionCollectorType_ClosestHit = 2,
	JPH_CollisionCollectorType_AnyHit = 3,
	_JPH_CollisionCollectorType_Count = 4,
	_JPH_CollisionCollectorType_Force32 = 2147483647
}

enum JPH_SwingType: uint32
{
	JPH_SwingType_Cone = 0,
	JPH_SwingType_Pyramid = 1,
	_JPH_SwingType_Count = 2,
	_JPH_SwingType_Force32 = 2147483647
}

enum JPH_SixDOFConstraintAxis: uint32
{
	JPH_SixDOFConstraintAxis_TranslationX = 0,
	JPH_SixDOFConstraintAxis_TranslationY = 1,
	JPH_SixDOFConstraintAxis_TranslationZ = 2,
	JPH_SixDOFConstraintAxis_RotationX = 3,
	JPH_SixDOFConstraintAxis_RotationY = 4,
	JPH_SixDOFConstraintAxis_RotationZ = 5,
	_JPH_SixDOFConstraintAxis_Num = 6,
	_JPH_SixDOFConstraintAxis_NumTranslation = 3,
	_JPH_SixDOFConstraintAxis_Force32 = 2147483647
}

enum JPH_SpringMode: uint32
{
	JPH_SpringMode_FrequencyAndDamping = 0,
	JPH_SpringMode_StiffnessAndDamping = 1,
	_JPH_SpringMode_Count = 2,
	_JPH_SpringMode_Force32 = 2147483647
}

enum JPH_SoftBodyConstraintColor: uint32
{
	JPH_SoftBodyConstraintColor_ConstraintType = 0,
	JPH_SoftBodyConstraintColor_ConstraintGroup = 1,
	JPH_SoftBodyConstraintColor_ConstraintOrder = 2,
	_JPH_SoftBodyConstraintColor_Count = 3,
	_JPH_SoftBodyConstraintColor_Force32 = 2147483647
}

enum JPH_SoftBodyBendType: uint32
{
	JPH_SoftBodyBendType_None = 0,
	JPH_SoftBodyBendType_Distance = 1,
	JPH_SoftBodyBendType_Dihedral = 2
}

enum JPH_BodyManager_ShapeColor: uint32
{
	JPH_BodyManager_ShapeColor_InstanceColor = 0,
	JPH_BodyManager_ShapeColor_ShapeTypeColor = 1,
	JPH_BodyManager_ShapeColor_MotionTypeColor = 2,
	JPH_BodyManager_ShapeColor_SleepColor = 3,
	JPH_BodyManager_ShapeColor_IslandColor = 4,
	JPH_BodyManager_ShapeColor_MaterialColor = 5,
	_JPH_BodyManager_ShapeColor_Count = 6,
	_JPH_BodyManager_ShapeColor_Force32 = 2147483647
}

enum JPH_DebugRenderer_CastShadow: uint32
{
	JPH_DebugRenderer_CastShadow_On = 0,
	JPH_DebugRenderer_CastShadow_Off = 1,
	_JPH_DebugRenderer_CastShadow_Count = 2,
	_JPH_DebugRenderer_CastShadow_Force32 = 2147483647
}

enum JPH_DebugRenderer_DrawMode: uint32
{
	JPH_DebugRenderer_DrawMode_Solid = 0,
	JPH_DebugRenderer_DrawMode_Wireframe = 1,
	_JPH_DebugRenderer_DrawMode_Count = 2,
	_JPH_DebugRenderer_DrawMode_Force32 = 2147483647
}

enum JPH_Mesh_Shape_BuildQuality: uint32
{
	JPH_Mesh_Shape_BuildQuality_FavorRuntimePerformance = 0,
	JPH_Mesh_Shape_BuildQuality_FavorBuildSpeed = 1,
	_JPH_Mesh_Shape_BuildQuality_Count = 2,
	_JPH_Mesh_Shape_BuildQuality_Force32 = 2147483647
}

enum JPH_TransmissionMode: uint32
{
	JPH_TransmissionMode_Auto = 0,
	JPH_TransmissionMode_Manual = 1,
	_JPH_TransmissionMode_Count = 2,
	_JPH_TransmissionMode_Force32 = 2147483647
}

enum JPH_TrackSide: uint32
{
	JPH_TrackSide_Left = 0,
	JPH_TrackSide_Right = 1
}

state JPH_BroadPhaseLayerInterface
{
	opaque: any
}

state JPH_ObjectVsBroadPhaseLayerFilter
{
	opaque: any
}

state JPH_ObjectLayerPairFilter
{
	opaque: any
}

state JPH_BroadPhaseLayerFilter
{
	opaque: any
}

state JPH_ObjectLayerFilter
{
	opaque: any
}

state JPH_BodyFilter
{
	opaque: any
}

state JPH_ShapeFilter
{
	opaque: any
}

state JPH_SimShapeFilter
{
	opaque: any
}

state JPH_PhysicsStepListener
{
	opaque: any
}

state JPH_PhysicsSystem
{
	opaque: any
}

state JPH_PhysicsMaterial
{
	opaque: any
}

state JPH_LinearCurve
{
	opaque: any
}

state JPH_ShapeSettings
{
	opaque: any
}

state JPH_ConvexShapeSettings
{
	opaque: any
}

state JPH_SphereShapeSettings
{
	opaque: any
}

state JPH_BoxShapeSettings
{
	opaque: any
}

state JPH_PlaneShapeSettings
{
	opaque: any
}

state JPH_TriangleShapeSettings
{
	opaque: any
}

state JPH_CapsuleShapeSettings
{
	opaque: any
}

state JPH_TaperedCapsuleShapeSettings
{
	opaque: any
}

state JPH_CylinderShapeSettings
{
	opaque: any
}

state JPH_TaperedCylinderShapeSettings
{
	opaque: any
}

state JPH_ConvexHullShapeSettings
{
	opaque: any
}

state JPH_CompoundShapeSettings
{
	opaque: any
}

state JPH_StaticCompoundShapeSettings
{
	opaque: any
}

state JPH_MutableCompoundShapeSettings
{
	opaque: any
}

state JPH_MeshShapeSettings
{
	opaque: any
}

state JPH_HeightFieldShapeSettings
{
	opaque: any
}

state JPH_RotatedTranslatedShapeSettings
{
	opaque: any
}

state JPH_ScaledShapeSettings
{
	opaque: any
}

state JPH_OffsetCenterOfMassShapeSettings
{
	opaque: any
}

state JPH_EmptyShapeSettings
{
	opaque: any
}

state JPH_Shape
{
	opaque: any
}

state JPH_ConvexShape
{
	opaque: any
}

state JPH_SphereShape
{
	opaque: any
}

state JPH_BoxShape
{
	opaque: any
}

state JPH_PlaneShape
{
	opaque: any
}

state JPH_CapsuleShape
{
	opaque: any
}

state JPH_CylinderShape
{
	opaque: any
}

state JPH_TaperedCylinderShape
{
	opaque: any
}

state JPH_TriangleShape
{
	opaque: any
}

state JPH_TaperedCapsuleShape
{
	opaque: any
}

state JPH_ConvexHullShape
{
	opaque: any
}

state JPH_CompoundShape
{
	opaque: any
}

state JPH_StaticCompoundShape
{
	opaque: any
}

state JPH_MutableCompoundShape
{
	opaque: any
}

state JPH_MeshShape
{
	opaque: any
}

state JPH_HeightFieldShape
{
	opaque: any
}

state JPH_DecoratedShape
{
	opaque: any
}

state JPH_RotatedTranslatedShape
{
	opaque: any
}

state JPH_ScaledShape
{
	opaque: any
}

state JPH_OffsetCenterOfMassShape
{
	opaque: any
}

state JPH_EmptyShape
{
	opaque: any
}

state JPH_BodyCreationSettings
{
	opaque: any
}

state JPH_SoftBodyCreationSettings
{
	opaque: any
}

state JPH_SoftBodySharedSettings
{
	opaque: any
}

state JPH_BodyInterface
{
	opaque: any
}

state JPH_BodyLockInterface
{
	opaque: any
}

state JPH_BroadPhaseQuery
{
	opaque: any
}

state JPH_NarrowPhaseQuery
{
	opaque: any
}

state JPH_MotionProperties
{
	opaque: any
}

state JPH_Body
{
	opaque: any
}

state JPH_ContactListener
{
	opaque: any
}

state JPH_ContactManifold
{
	opaque: any
}

state JPH_GroupFilter
{
	opaque: any
}

state JPH_GroupFilterTable
{
	opaque: any
}

state JPH_Vec3
{
	x: float32,
	y: float32,
	z: float32
}

state JPH_Vec4
{
	x: float32,
	y: float32,
	z: float32,
	w: float32
}

state JPH_Quat
{
	x: float32,
	y: float32,
	z: float32,
	w: float32
}

state JPH_Plane
{
	normal: JPH_Vec3,
	distance: float32
}

state JPH_Mat4
{
	column: [4]JPH_Vec4
}

state JPH_Point
{
	x: float32,
	y: float32
}

state JPH_AABox
{
	min: JPH_Vec3,
	max: JPH_Vec3
}

state JPH_Triangle
{
	v1: JPH_Vec3,
	v2: JPH_Vec3,
	v3: JPH_Vec3,
	materialIndex: uint32
}

state JPH_IndexedTriangleNoMaterial
{
	i1: uint32,
	i2: uint32,
	i3: uint32
}

state JPH_IndexedTriangle
{
	i1: uint32,
	i2: uint32,
	i3: uint32,
	materialIndex: uint32,
	userData: uint32
}

state JPH_MassProperties
{
	mass: float32,
	inertia: JPH_Mat4
}

state JPH_SoftVertex
{
	position: JPH_Vec3,
	velocity: JPH_Vec3,
	invMass: float32
}

state JPH_SoftFace
{
	vertex1: uint32,
	vertex2: uint32,
	vertex3: uint32,
	materialIndex: uint32
}

state JPH_ContactSettings
{
	combinedFriction: float32,
	combinedRestitution: float32,
	invMassScale1: float32,
	invInertiaScale1: float32,
	invMassScale2: float32,
	invInertiaScale2: float32,
	isSensor: uint32,
	relativeLinearSurfaceVelocity: JPH_Vec3,
	relativeAngularSurfaceVelocity: JPH_Vec3
}

state JPH_CollideSettingsBase
{
	activeEdgeMode: JPH_ActiveEdgeMode,
	collectFacesMode: JPH_CollectFacesMode,
	collisionTolerance: float32,
	penetrationTolerance: float32,
	activeEdgeMovementDirection: JPH_Vec3
}

state JPH_CollideShapeSettings
{
	base: JPH_CollideSettingsBase,
	maxSeparationDistance: float32,
	backFaceMode: JPH_BackFaceMode
}

state JPH_ShapeCastSettings
{
	base: JPH_CollideSettingsBase,
	backFaceModeTriangles: JPH_BackFaceMode,
	backFaceModeConvex: JPH_BackFaceMode,
	useShrunkenShapeAndConvexRadius: bool,
	returnDeepestPoint: bool
}

state JPH_RayCastSettings
{
	backFaceModeTriangles: JPH_BackFaceMode,
	backFaceModeConvex: JPH_BackFaceMode,
	treatConvexAsSolid: bool
}

state JPH_SpringSettings
{
	mode: JPH_SpringMode,
	frequencyOrStiffness: float32,
	damping: float32
}

state JPH_MotorSettings
{
	springSettings: JPH_SpringSettings,
	minForceLimit: float32,
	maxForceLimit: float32,
	minTorqueLimit: float32,
	maxTorqueLimit: float32
}

state JPH_SubShapeIDPair
{
	Body1ID: uint32,
	subShapeID1: uint32,
	Body2ID: uint32,
	subShapeID2: uint32
}

state JPH_BroadPhaseCastResult
{
	bodyID: uint32,
	fraction: float32
}

state JPH_RayCastResult
{
	bodyID: uint32,
	fraction: float32,
	subShapeID2: uint32
}

state JPH_CollidePointResult
{
	bodyID: uint32,
	subShapeID2: uint32
}

state JPH_CollideShapeResult
{
	contactPointOn1: JPH_Vec3,
	contactPointOn2: JPH_Vec3,
	penetrationAxis: JPH_Vec3,
	penetrationDepth: float32,
	subShapeID1: uint32,
	subShapeID2: uint32,
	bodyID2: uint32,
	shape1FaceCount: uint32,
	shape1Faces: *JPH_Vec3,
	shape2FaceCount: uint32,
	shape2Faces: *JPH_Vec3
}

state JPH_ShapeCastResult
{
	contactPointOn1: JPH_Vec3,
	contactPointOn2: JPH_Vec3,
	penetrationAxis: JPH_Vec3,
	penetrationDepth: float32,
	subShapeID1: uint32,
	subShapeID2: uint32,
	bodyID2: uint32,
	fraction: float32,
	isBackFaceHit: bool
}

state JPH_DrawSettings
{
	drawGetSupportFunction: bool,
	drawSupportDirection: bool,
	drawGetSupportingFace: bool,
	drawShape: bool,
	drawShapeWireframe: bool,
	drawShapeColor: JPH_BodyManager_ShapeColor,
	drawBoundingBox: bool,
	drawCenterOfMassTransform: bool,
	drawWorldTransform: bool,
	drawVelocity: bool,
	drawMassAndInertia: bool,
	drawSleepStats: bool,
	drawSoftBodyVertices: bool,
	drawSoftBodyVertexVelocities: bool,
	drawSoftBodyEdgeConstraints: bool,
	drawSoftBodyBendConstraints: bool,
	drawSoftBodyVolumeConstraints: bool,
	drawSoftBodySkinConstraints: bool,
	drawSoftBodyLRAConstraints: bool,
	drawSoftBodyPredictedBounds: bool,
	drawSoftBodyConstraintColor: JPH_SoftBodyConstraintColor
}

state JPH_SupportingFace
{
	count: uint32,
	vertices: [32]JPH_Vec3
}

state JPH_CollisionGroup
{
	groupFilter: *JPH_GroupFilter,
	groupID: uint32,
	subGroupID: uint32
}

state JPH_CollisionEstimationResult
{
	linearVelocity1: JPH_Vec3,
	angularVelocity1: JPH_Vec3,
	linearVelocity2: JPH_Vec3,
	angularVelocity2: JPH_Vec3,
	frictionPoint: JPH_Vec3,
	tangent1: JPH_Vec3,
	tangent2: JPH_Vec3,
	frictionImpulse1: float32,
	frictionImpulse2: float32,
	angularFrictionImpulse: float32,
	contactImpulseCount: uint32,
	contactImpulses: *float32
}

state JPH_BodyActivationListener
{
	opaque: any
}

state JPH_BodyDrawFilter
{
	opaque: any
}

state JPH_SharedMutex
{
	opaque: any
}

state JPH_DebugRenderer
{
	opaque: any
}

state JPH_Constraint
{
	opaque: any
}

state JPH_TwoBodyConstraint
{
	opaque: any
}

state JPH_FixedConstraint
{
	opaque: any
}

state JPH_DistanceConstraint
{
	opaque: any
}

state JPH_PointConstraint
{
	opaque: any
}

state JPH_HingeConstraint
{
	opaque: any
}

state JPH_SliderConstraint
{
	opaque: any
}

state JPH_ConeConstraint
{
	opaque: any
}

state JPH_SwingTwistConstraint
{
	opaque: any
}

state JPH_SixDOFConstraint
{
	opaque: any
}

state JPH_GearConstraint
{
	opaque: any
}

state JPH_CharacterBase
{
	opaque: any
}

state JPH_Character
{
	opaque: any
}

state JPH_CharacterVirtual
{
	opaque: any
}

state JPH_CharacterContactListener
{
	opaque: any
}

state JPH_CharacterVsCharacterCollision
{
	opaque: any
}

state JPH_Skeleton
{
	opaque: any
}

state JPH_SkeletonPose
{
	opaque: any
}

state JPH_SkeletalAnimation
{
	opaque: any
}

state JPH_SkeletonMapper
{
	opaque: any
}

state JPH_RagdollSettings
{
	opaque: any
}

state JPH_Ragdoll
{
	opaque: any
}

state JPH_ConstraintSettings
{
	enabled: bool,
	constraintPriority: uint32,
	numVelocityStepsOverride: uint32,
	numPositionStepsOverride: uint32,
	drawConstraintSize: float32,
	userData: uint64
}

state JPH_FixedConstraintSettings
{
	base: JPH_ConstraintSettings,
	space: JPH_ConstraintSpace,
	autoDetectPoint: bool,
	point1: JPH_Vec3,
	axisX1: JPH_Vec3,
	axisY1: JPH_Vec3,
	point2: JPH_Vec3,
	axisX2: JPH_Vec3,
	axisY2: JPH_Vec3
}

state JPH_DistanceConstraintSettings
{
	base: JPH_ConstraintSettings,
	space: JPH_ConstraintSpace,
	point1: JPH_Vec3,
	point2: JPH_Vec3,
	minDistance: float32,
	maxDistance: float32,
	limitsSpringSettings: JPH_SpringSettings
}

state JPH_PointConstraintSettings
{
	base: JPH_ConstraintSettings,
	space: JPH_ConstraintSpace,
	point1: JPH_Vec3,
	point2: JPH_Vec3
}

state JPH_HingeConstraintSettings
{
	base: JPH_ConstraintSettings,
	space: JPH_ConstraintSpace,
	point1: JPH_Vec3,
	hingeAxis1: JPH_Vec3,
	normalAxis1: JPH_Vec3,
	point2: JPH_Vec3,
	hingeAxis2: JPH_Vec3,
	normalAxis2: JPH_Vec3,
	limitsMin: float32,
	limitsMax: float32,
	limitsSpringSettings: JPH_SpringSettings,
	maxFrictionTorque: float32,
	motorSettings: JPH_MotorSettings
}

state JPH_SliderConstraintSettings
{
	base: JPH_ConstraintSettings,
	space: JPH_ConstraintSpace,
	autoDetectPoint: bool,
	point1: JPH_Vec3,
	sliderAxis1: JPH_Vec3,
	normalAxis1: JPH_Vec3,
	point2: JPH_Vec3,
	sliderAxis2: JPH_Vec3,
	normalAxis2: JPH_Vec3,
	limitsMin: float32,
	limitsMax: float32,
	limitsSpringSettings: JPH_SpringSettings,
	maxFrictionForce: float32,
	motorSettings: JPH_MotorSettings
}

state JPH_ConeConstraintSettings
{
	base: JPH_ConstraintSettings,
	space: JPH_ConstraintSpace,
	point1: JPH_Vec3,
	twistAxis1: JPH_Vec3,
	point2: JPH_Vec3,
	twistAxis2: JPH_Vec3,
	halfConeAngle: float32
}

state JPH_SwingTwistConstraintSettings
{
	base: JPH_ConstraintSettings,
	space: JPH_ConstraintSpace,
	position1: JPH_Vec3,
	twistAxis1: JPH_Vec3,
	planeAxis1: JPH_Vec3,
	position2: JPH_Vec3,
	twistAxis2: JPH_Vec3,
	planeAxis2: JPH_Vec3,
	swingType: JPH_SwingType,
	normalHalfConeAngle: float32,
	planeHalfConeAngle: float32,
	twistMinAngle: float32,
	twistMaxAngle: float32,
	maxFrictionTorque: float32,
	swingMotorSettings: JPH_MotorSettings,
	twistMotorSettings: JPH_MotorSettings
}

state JPH_SixDOFConstraintSettings
{
	base: JPH_ConstraintSettings,
	space: JPH_ConstraintSpace,
	position1: JPH_Vec3,
	axisX1: JPH_Vec3,
	axisY1: JPH_Vec3,
	position2: JPH_Vec3,
	axisX2: JPH_Vec3,
	axisY2: JPH_Vec3,
	maxFriction: [6]float32,
	swingType: JPH_SwingType,
	limitMin: [6]float32,
	limitMax: [6]float32,
	limitsSpringSettings: [3]JPH_SpringSettings,
	motorSettings: [6]JPH_MotorSettings
}

state JPH_GearConstraintSettings
{
	base: JPH_ConstraintSettings,
	space: JPH_ConstraintSpace,
	hingeAxis1: JPH_Vec3,
	hingeAxis2: JPH_Vec3,
	ratio: float32
}

state JPH_BodyLockRead
{
	lockInterface: *JPH_BodyLockInterface,
	mutex: *JPH_SharedMutex,
	body: *JPH_Body
}

state JPH_BodyLockWrite
{
	lockInterface: *JPH_BodyLockInterface,
	mutex: *JPH_SharedMutex,
	body: *JPH_Body
}

state JPH_BodyLockMultiRead
{
	opaque: any
}

state JPH_BodyLockMultiWrite
{
	opaque: any
}

state JPH_ExtendedUpdateSettings
{
	stickToFloorStepDown: JPH_Vec3,
	walkStairsStepUp: JPH_Vec3,
	walkStairsMinStepForward: float32,
	walkStairsStepForwardTest: float32,
	walkStairsCosAngleForwardContact: float32,
	walkStairsStepDownExtra: JPH_Vec3
}

state JPH_CharacterBaseSettings
{
	up: JPH_Vec3,
	supportingVolume: JPH_Plane,
	maxSlopeAngle: float32,
	enhancedInternalEdgeRemoval: bool,
	shape: *JPH_Shape
}

state JPH_CharacterSettings
{
	base: JPH_CharacterBaseSettings,
	layer: uint32,
	mass: float32,
	friction: float32,
	gravityFactor: float32,
	allowedDOFs: JPH_AllowedDOFs
}

state JPH_CharacterVirtualSettings
{
	base: JPH_CharacterBaseSettings,
	ID: uint32,
	mass: float32,
	maxStrength: float32,
	shapeOffset: JPH_Vec3,
	backFaceMode: JPH_BackFaceMode,
	predictiveContactDistance: float32,
	maxCollisionIterations: uint32,
	maxConstraintIterations: uint32,
	minTimeRemaining: float32,
	collisionTolerance: float32,
	characterPadding: float32,
	maxNumHits: uint32,
	hitReductionCosMaxAngle: float32,
	penetrationRecoverySpeed: float32,
	innerBodyShape: *JPH_Shape,
	innerBodyIDOverride: uint32,
	innerBodyLayer: uint32
}

state JPH_CharacterContactSettings
{
	canPushCharacter: bool,
	canReceiveImpulses: bool
}

state JPH_CharacterContact
{
	hash: uint64,
	bodyB: uint32,
	characterIDB: uint32,
	subShapeIDB: uint32,
	position: JPH_Vec3,
	linearVelocity: JPH_Vec3,
	contactNormal: JPH_Vec3,
	surfaceNormal: JPH_Vec3,
	distance: float32,
	fraction: float32,
	motionTypeB: JPH_MotionType,
	isSensorB: bool,
	characterB: *JPH_CharacterVirtual,
	userData: uint64,
	material: *JPH_PhysicsMaterial,
	hadCollision: bool,
	wasDiscarded: bool,
	canPushCharacter: bool,
	isBackFacingContact: bool
}

state JobSystemThreadPoolConfig
{
	maxJobs: uint32,
	maxBarriers: uint32,
	numThreads: int32
}

state JPH_JobSystemConfig
{
	context: *void,
	queueJob: ::(),
	queueJobs: ::(),
	maxConcurrency: uint32,
	maxBarriers: uint32
}

state JPH_JobSystem
{
	opaque: any
}

state JPH_PhysicsSystemSettings
{
	maxBodies: uint32,
	numBodyMutexes: uint32,
	maxBodyPairs: uint32,
	maxContactConstraints: uint32,
	_padding: uint32,
	broadPhaseLayerInterface: *JPH_BroadPhaseLayerInterface,
	objectLayerPairFilter: *JPH_ObjectLayerPairFilter,
	objectVsBroadPhaseLayerFilter: *JPH_ObjectVsBroadPhaseLayerFilter
}

state JPH_PhysicsSettings
{
	maxInFlightBodyPairs: int32,
	stepListenersBatchSize: int32,
	stepListenerBatchesPerJob: int32,
	baumgarte: float32,
	speculativeContactDistance: float32,
	penetrationSlop: float32,
	linearCastThreshold: float32,
	linearCastMaxPenetration: float32,
	manifoldTolerance: float32,
	maxPenetrationDistance: float32,
	bodyPairCacheMaxDeltaPositionSq: float32,
	bodyPairCacheCosMaxDeltaRotationDiv2: float32,
	contactNormalCosMaxDeltaRotation: float32,
	contactPointPreserveLambdaMaxDistSq: float32,
	numVelocitySteps: uint32,
	numPositionSteps: uint32,
	minVelocityForRestitution: float32,
	timeBeforeSleep: float32,
	pointVelocitySleepThreshold: float32,
	deterministicSimulation: bool,
	constraintWarmStart: bool,
	useBodyPairContactCache: bool,
	useManifoldReduction: bool,
	useLargeIslandSplitter: bool,
	allowSleeping: bool,
	checkActiveEdges: bool
}

state JPH_PhysicsStepListenerContext
{
	deltaTime: float32,
	isFirstStep: uint32,
	isLastStep: uint32,
	physicsSystem: *JPH_PhysicsSystem
}

state JPH_PhysicsStepListener_Procs
{
	OnStep: ::()
}

state JPH_BroadPhaseLayerFilter_Procs
{
	ShouldCollide: ::()
}

state JPH_ObjectLayerFilter_Procs
{
	ShouldCollide: ::()
}

state JPH_BodyFilter_Procs
{
	ShouldCollide: ::(),
	ShouldCollideLocked: ::()
}

state JPH_ShapeFilter_Procs
{
	ShouldCollide: ::(),
	ShouldCollide2: ::()
}

state JPH_SimShapeFilter_Procs
{
	ShouldCollide: ::()
}

state JPH_ContactListener_Procs
{
	OnContactValidate: ::(),
	OnContactAdded: ::(),
	OnContactPersisted: ::(),
	OnContactRemoved: ::()
}

state JPH_BodyActivationListener_Procs
{
	OnBodyActivated: ::(),
	OnBodyDeactivated: ::()
}

state JPH_BodyDrawFilter_Procs
{
	ShouldDraw: ::()
}

state JPH_CharacterContactListener_Procs
{
	OnAdjustBodyVelocity: ::(),
	OnContactValidate: ::(),
	OnCharacterContactValidate: ::(),
	OnContactAdded: ::(),
	OnContactPersisted: ::(),
	OnContactRemoved: ::(),
	OnCharacterContactAdded: ::(),
	OnCharacterContactPersisted: ::(),
	OnCharacterContactRemoved: ::(),
	OnContactSolve: ::(),
	OnCharacterContactSolve: ::()
}

state JPH_CharacterVsCharacterCollision_Procs
{
	CollideCharacter: ::(),
	CastCharacter: ::()
}

state JPH_DebugRenderer_Procs
{
	DrawLine: ::(),
	DrawTriangle: ::(),
	DrawText3D: ::()
}

state JPH_SkeletonJoint
{
	name: *byte,
	parentName: *byte,
	parentJointIndex: int32
}

state JPH_WheelSettings
{
	opaque: any
}

state JPH_WheelSettingsWV
{
	opaque: any
}

state JPH_WheelSettingsTV
{
	opaque: any
}

state JPH_Wheel
{
	opaque: any
}

state JPH_WheelWV
{
	opaque: any
}

state JPH_WheelTV
{
	opaque: any
}

state JPH_VehicleEngine
{
	opaque: any
}

state JPH_VehicleTransmission
{
	opaque: any
}

state JPH_VehicleTransmissionSettings
{
	opaque: any
}

state JPH_VehicleCollisionTester
{
	opaque: any
}

state JPH_VehicleCollisionTesterRay
{
	opaque: any
}

state JPH_VehicleCollisionTesterCastSphere
{
	opaque: any
}

state JPH_VehicleCollisionTesterCastCylinder
{
	opaque: any
}

state JPH_VehicleConstraint
{
	opaque: any
}

state JPH_VehicleControllerSettings
{
	opaque: any
}

state JPH_WheeledVehicleControllerSettings
{
	opaque: any
}

state JPH_MotorcycleControllerSettings
{
	opaque: any
}

state JPH_TrackedVehicleControllerSettings
{
	opaque: any
}

state JPH_WheeledVehicleController
{
	opaque: any
}

state JPH_MotorcycleController
{
	opaque: any
}

state JPH_TrackedVehicleController
{
	opaque: any
}

state JPH_VehicleController
{
	opaque: any
}

state JPH_VehicleAntiRollBar
{
	leftWheel: int32,
	rightWheel: int32,
	stiffness: float32
}

state JPH_VehicleConstraintSettings
{
	base: JPH_ConstraintSettings,
	up: JPH_Vec3,
	forward: JPH_Vec3,
	maxPitchRollAngle: float32,
	wheelsCount: uint32,
	wheels: **JPH_WheelSettings,
	antiRollBarsCount: uint32,
	antiRollBars: *JPH_VehicleAntiRollBar,
	controller: *JPH_VehicleControllerSettings
}

state JPH_VehicleEngineSettings
{
	maxTorque: float32,
	minRPM: float32,
	maxRPM: float32,
	normalizedTorque: *JPH_LinearCurve,
	inertia: float32,
	angularDamping: float32
}

state JPH_VehicleDifferentialSettings
{
	leftWheel: int32,
	rightWheel: int32,
	differentialRatio: float32,
	leftRightSplit: float32,
	limitedSlipRatio: float32,
	engineTorqueRatio: float32
}

state JPH_VehicleTrack
{
	opaque: any
}

state JPH_VehicleTrackSettings
{
	drivenWheel: uint32,
	wheels: *uint32,
	wheelsCount: uint32,
	inertia: float32,
	angularDamping: float32,
	maxBrakeTorque: float32,
	differentialRatio: float32
}

state JPH_TempAllocator
{
	opaque: any
}

