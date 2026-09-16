package Physics

import Jolt

enum MotionMode
{
    Static,
    Kinematic,
    Dynamic
}

enum ActivationMode
{
    Activate,
    DontActivate
}

InitializePhysics()
{
    JPH_Init();
}