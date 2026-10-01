package RenderCommon

import RenderComponents
import ECS
import Array
import ArrayView
import Common
import OS
import Math
import Vec
import Matrix
import Transform

Color GetMeshTriangleColor(mesh: Mesh) =>
{
    color := Color();

    assetDef := GetAssetDefWithHandle(mesh.defHandle);
    assetDefName := assetDef.name;

    // if (assetDefName ==)

    return color;
}

Vec3 WorldPoint(mat: Matrix4, point: Vec3) =>
{
    transformed := mat * Vec4(point.x, point.y, point.z, 1.0);
    return Vec3(transformed.x, transformed.y, transformed.z);
}

Triangle WorldTriangle(mat: Matrix4, tri: Triangle) =>
{
    return Triangle(
        WorldPoint(mat, tri.verts[0]),
        WorldPoint(mat, tri.verts[1]),
        WorldPoint(mat, tri.verts[2])
    );
}

RayTraceScene(scene: *Scene, cameraEntity: Entity, width: uint32, height: uint32, out: string)
{
    log "Ray Tracing Scene";
    pixelCount := width * height;
    pixels := Array<Color>(pixelCount);
    defer delete pixels;

    widthF := width as float;
    heightF := height as float;

    aspectRatio := widthF / heightF;
    worldUp := Vec3(0.0, 1.0, 0.0);

    camera := scene.GetComponent<Camera>(cameraEntity);
    cameraOrigin := camera.position;
    cameraForward := camera.Forward() * -1.0;
    cameraRight := cameraForward.Cross(worldUp).Normalize().vec;
    cameraUp := cameraRight.Cross(cameraForward); 

    halfHeight := Math.Tan(camera.fov / 2.0);
    halfWidth := halfHeight * widthF / heightF;

    for (ec in scene.Iterate<Mesh>())
    {
        UpdateWorldTransform(ec.entity, scene~);
    }

    for (x .. width)
    {
        for (y .. height)
        {
            pixelIndex := (y * width) + x;

            horizontal := 2.0 * (x + 0.5) / widthF - 1.0;
            vertical := 1.0 - 2.0 * (y + 0.5) / heightF;

            offsetX := horizontal * halfWidth;
            offsetY := vertical * halfHeight;

            rayDirection := (cameraForward + cameraRight * offsetX + cameraUp * offsetY).Normalize().vec;

            pixels[pixelIndex] = Color(0.0, 0.0, 0.0, 1.0);

            for (ec in scene.Iterate<Mesh>())
            {
                entity := ec.entity;
                mesh := ec.component;

                geo := mesh.geometry;
                mat := mesh.material;

                worldTransform := scene.GetComponent<WorldTransform>(entity);

                triIndex := 0;
                for (meshTri in geo.IterateTriangles())
                {
                    worldTri := WorldTriangle(worldTransform.mat, meshTri);
                    intersection := RayIntersection();
                    ray := Ray(cameraOrigin, rayDirection);
                    if (ray.IntersectTri(worldTri, intersection@))
                    {
                        pixels[pixelIndex] = Color(1.0, 1.0, 1.0, 1.0);
                    }
                    triIndex += 1;
                }
            }
        }
    }

    outFile := OS.GetAbsolutePath(out);
    surface := SDL.CreateSurfaceFrom(width, height, PixelFormat.RGBA128_FLOAT, pixels[0]@, width * #sizeof Color);
    saved := SDL.SavePNG(surface, outFile[0]);

    log "Saved image", saved, outFile;
}