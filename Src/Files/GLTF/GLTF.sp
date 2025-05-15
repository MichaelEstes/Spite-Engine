package GLTF

import OS
import Array
import Matrix
import Vec
import Quaternion
import Color
import Arena
import StrArena
import JSON
import File

InvalidGLTFIndex := -1 as uint32;

state GLTF
{
    mem := Arena(),
    strMem := StrArena(),

    src: string,
    path: string,

    asset: GLTFAsset,

    scenes: Array<GLTFScene>,
    nodes: Array<GLTFNode>,
    meshes: Array<GLTFMesh>,
    materials: Array<GLTFMaterial>,
    animations: Array<GLTFAnimation>,
    cameras: Array<GLTFCamera>,
    skins: Array<GLTFSkin>,
    textures: Array<GLTFTexture>,
    images: Array<GLTFImage>,
    samplers: Array<GLTFSampler>,
    buffers: Array<GLTFBuffer>,
    bufferViews: Array<GLTFBufferView>,
    accessors: Array<GLTFAccessor>,
	
    scene: uint32 = InvalidGLTFIndex
}

GLTF::delete
{
    delete this.scenes;
    delete this.nodes;
    delete this.meshes;
    delete this.materials;
    delete this.animations;
    delete this.cameras;
    delete this.skins;
    delete this.textures;
    delete this.images;
    delete this.samplers;
    delete this.buffers;
    delete this.bufferViews;
    delete this.accessors;

    delete this.src;
    delete this.path;
    delete this.mem;
    delete this.strMem;
}

state GLTFAsset
{
	version: string,
	generator: *string,
	copyright: *string,
	minVersion: *string
}

state GLTFScene
{
	name: *string,

	nodes: Array<uint32>
}

GLTFScene::delete
{
    delete this.nodes;
}

state GLTFTRS
{
	translation: Vec3,
	rotation: Quaternion,
	scale: Vec3
}

state GLTFNode
{
    name: *string,
    
    children: Array<uint32>,
    weights: Array<float32>,
    
    transform: ?{
        matrix: Matrix4,
        trs: GLTFTRS
    },
    
    camera: uint32 = InvalidGLTFIndex,
    mesh: uint32 = InvalidGLTFIndex,
    skin: uint32 = InvalidGLTFIndex,

    trs: bool
}

GLTFNode::delete
{
    delete this.children;
    delete this.weights;
}

state GLTFMesh
{
    name: *string,

	primitives: Array<GLTFPrimitive>,
	weights: Array<float32>,
}

GLTFMesh::delete
{
    delete this.primitives;
    delete this.weights;
}

enum GLTFAttributeKind: uint32
{
    Unknown,
    Position,
    Normal,
    Tangent,
    TexCoord,
    Color,
    Joints,
    Weights
}

state GLTFAttribute
{
    data: ?{
        name: string,
        index: uint32
    }
    accessor: uint32,
    kind: GLTFAttributeKind
}

state GLTFPrimitive
{
    attributes: Map<string, uint32>,
    targets: Array<Map<string, uint32>>,

    indices: uint32 = InvalidGLTFIndex,
    material: uint32 = InvalidGLTFIndex,
    mode: uint32 = 4
}

GLTFPrimitive::delete
{
    delete this.attributes;
    delete this.targets;
}

state GLTFTextureInfo
{
    index: uint32,
    texCoord: uint32
}

state GLTFMaterialPBRMetallicRoughness
{
    baseColorFactor: Color,
    baseColorTexture: *GLTFTextureInfo,
    
	metallicRoughnessTexture: *GLTFTextureInfo,

    metallicFactor: float32 = 1.0,
    roughnessFactor: float32 = 1.0
}

state GLTFNormalTextureInfo
{
	info: GLTFTextureInfo,
    scale: float32 = 1.0
}

state GLTFOcclusionTextureInfo
{
    info: GLTFTextureInfo,
    strength: float32 = 1.0
}

state GLTFMaterial
{
    name: *string,
    
    pbrMetallicRoughness: *GLTFMaterialPBRMetallicRoughness,
    normalTexture: *GLTFNormalTextureInfo,
    occlusionTexture: *GLTFOcclusionTextureInfo,
    emissiveTexture: *GLTFTextureInfo,

    emissiveFactor: Vec3,
    alphaMode: string,

    alphaCutoff: float32 = 0.5,
    doubleSided: bool
}

state GLTFCamera
{
    name: *string,
    
    camera: ?{
        perspective: GLTFCameraPerspective,
        orthographic: GLTFCameraOrthographic
    },

    type: string
}

state GLTFCameraPerspective
{
    aspectRatio: float32,
    yfov: float32,
    zfar: float32,
    znear: float32
}

state GLTFCameraOrthographic
{
    xmag: float32,
    ymag: float32,
    znear: float32,
    zfar: float32
}

state GLTFBuffer
{
    name: *string,

    uri: GLTFURI,
    byteLength: uint32
}

state GLTFBufferView
{
    name: *string,

    buffer: uint32,
    byteOffset: uint32,
    byteLength: uint32,
    byteStride: uint32,
    target: uint32
}

state GLTFAccessorSparseIndices
{
    bufferView: uint32,
    componentType: uint32,
    byteOffset: uint32
}

state GLTFAccessorSparseValues
{
    bufferView: uint32,
    byteOffset: uint32
}

state GLTFAccessorSparse
{
    indices: GLTFAccessorSparseIndices,
    values: GLTFAccessorSparseValues,
    count: uint32
}

state GLTFAccessor
{
    name: *string,

    max: Array<float32>,
    min: Array<float32>,
    
	type: string,
    sparse: *GLTFAccessorSparse,

    bufferView: uint32,
    byteOffset: uint32,
    componentType: uint32,
    count: uint32,
    
    normalized: bool
}

GLTFAccessor::delete
{
    delete this.max;
    delete this.min;
}

state GLTFTexture
{
    name: *string,
    
    sampler: uint32,
    source: uint32
}

state GLTFSampler
{
    name: *string,

    magFilter: uint32,
    minFilter: uint32,
    wrapS: uint32,
    wrapT: uint32
}

state GLTFImage
{
    name: *string,
    
    uri: GLTFURI,
    mimeType: *string,
    
    bufferView: uint32
}

state GLTFAnimation
{
    name: *string,
    
    channels: Array<GLTFAnimationChannel>,
    samplers: Array<GLTFAnimationSampler>
}

GLTFAnimation::delete
{
    delete this.channels;
    delete this.samplers;
}

state GLTFAnimationChannel
{
    target: GLTFAnimationChannelTarget,
    sampler: uint32,
}

state GLTFAnimationChannelTarget
{
    path: string,  // "translation", "rotation", "scale", or "weights"
    node: uint32
}

state GLTFAnimationSampler
{
    interpolation: string  // "LINEAR", "STEP", "CUBICSPLINE"

    input: uint32,   
    output: uint32,  
}

state GLTFSkin
{
    name: *string,
    
    joints: Array<uint32>,

    inverseBindMatrices: uint32,
    skeleton: uint32 = InvalidGLTFIndex
}

GLTFSkin::delete
{
    delete this.joints;
}

state GLTFURI
{
    uri: *string,
    data: *byte,
    byteCount: uint32
}

GLTF ParseGLTF(gltf: GLTF, oot: JSONObject)
{
    ParseGLTFAsset(gltf, root);

    sceneValue := root.GetMember("scene");
    if (sceneValue) gltf.scene = sceneValue.Number().value.i;

    ParseGLTFScenes(gltf, root);
    ParseGLTFNodes(gltf, root);
    ParseGLTFMeshes(gltf, root);
    ParseGLTFMaterials(gltf, root);
    ParseGLTFAnimations(gltf, root);
    ParseGLTFCameras(gltf, root);
    ParseGLTFSkins(gltf, root);
    ParseGLTFTextures(gltf, root);
    ParseGLTFImages(gltf, root);
    ParseGLTFSamplers(gltf, root);
    ParseGLTFBuffers(gltf, root);
    ParseGLTFBufferViews(gltf, root);
    ParseGLTFAccessors(gltf, root);

    return gltf;
}

GLTF LoadGLTF(file: string)
{
    path := GetAbsolutePath(file);

    gltf := GLTF();
    gltf.src = path;
    gltf.path = OS.GetDirectoryName(path);

    json := ParseJSONFile(path);
    defer delete json;

    root := json.root.Object();

    return ParseGLTF(gltf, root);
}

*string ParseGLTFStringPtr(gltf: GLTF, value: *JSONValue)
{
    str: *string = null;
    if (value)
    {
        strPtr := gltf.mem.Emplace<string>();
        strVal := value.String().value;
        strPtr~ = gltf.strMem.Copy(strVal);
        str = strPtr;
    }
    return str;
}

GLTFURI ParseGLTFURI(gltf: GLTF, value: *JSONValue)
{
    uri := GLTFURI();

    if (value)
    {
        uriPtr := gltf.mem.Emplace<string>();
        uriPtr~ = gltf.strMem.Copy(value.String().value);
        uri.uri = uriPtr;

        if (IsDataURI(uriPtr~))
        {

        }
        else
        {
            filePath := OS.JoinPaths([gltf.path, uriPtr~])
            defer delete filePath;
            
            contents := OS.ReadFile(filePath)
            uri.data = contents.mem;
            uri.byteCount = contents.count;
        }
    }

    return uri;
}

ParseGLTFAsset(gltf: GLTF, root: *JSONObject)
{
    assetValue := root.GetMember("asset");
    if (!assetValue) return;

    assetObj := assetValue.Object();
    if (!assetObj) return;

    versionValue := assetObj.GetMember("version");
    if (versionValue)
    {
        version := versionValue.String().value;
        gltf.asset.version = gltf.strMem.Copy(version);
    }

    generatorValue := assetObj.GetMember("generator");
    gltf.asset.generator = ParseGLTFStringPtr(gltf, generatorValue);
   
    copyrightValue := assetObj.GetMember("copyright");
    gltf.asset.copyright = ParseGLTFStringPtr(gltf, copyrightValue);
    
    minVersionValue := assetObj.GetMember("minVersion");
    gltf.asset.minVersion = ParseGLTFStringPtr(gltf, minVersionValue);
}

ParseGLTFScenes(gltf: GLTF, root: *JSONObject)
{
    scenesValue := root.GetMember("scenes");
    if (!scenesValue) return;

    sceneArr := scenesValue.Array();
    gltf.scenes.SizeTo(sceneArr.values.count);
    for (sceneValue in sceneArr.values)
    {
        scene := GLTFScene();
        
        sceneObj := sceneValue.Object();
        scene.name = ParseGLTFStringPtr(gltf, sceneObj.GetMember("name"));

        nodesValue := sceneObj.GetMember("nodes");
        if (!nodesValue) continue;

        nodesArr := nodesValue.Array();
        scene.nodes.SizeTo(nodesArr.values.count);
        for (nodeValue in nodesArr.values)
        {
            node := nodeValue.Number().value.i;
            scene.nodes.Add(node);
        }

        gltf.scenes.Add(scene);
    }
}

ParseGLTFNodes(gltf: GLTF, root: *JSONObject)
{
    nodesValue := root.GetMember("nodes");
    if (!nodesValue) return;

    nodesArr := nodesValue.Array();
    gltf.nodes.SizeTo(nodesArr.values.count);
    for (nodeValue in nodesArr.values)
    {
        node := GLTFNode();
        nodeObj := nodeValue.Object();
        
        node.name = ParseGLTFStringPtr(gltf, nodeObj.GetMember("name"));
        
        cameraValue := nodeObj.GetMember("camera");
        if (cameraValue) node.camera = cameraValue.Number().value.i;

        meshValue := nodeObj.GetMember("mesh");
        if (meshValue) node.mesh = meshValue.Number().value.i;
        
        skinValue := nodeObj.GetMember("skin");
        if (skinValue) node.skin = skinValue.Number().value.i;
        
        childrenValue := nodeObj.GetMember("children");
        if (childrenValue)
        {
            childrenArr := childrenValue.Array();
            node.children.SizeTo(childrenArr.values.count);
            for (childValue in childrenArr.values)
            {
                child := childValue.Number().value.i;
                node.children.Add(child);
            }
        }
        
        matrixValue := nodeObj.GetMember("matrix");
        if (matrixValue)
        {
            node.trs = false;
            matrixArr := matrixValue.Array();
            matrix := Matrix4();
            for (i .. 4) 
                for (j .. 4) 
                    matrix[i][j] = matrixArr.GetValue(i * 4 + j).Number().value.f;

            node.transform.matrix = matrix;
        }
        else
        {
            node.trs = true;
            trs := GLTFTRS();
            
            translationValue := nodeObj.GetMember("translation");
            if (translationValue)
            {
                translationArr := translationValue.Array();
                trs.translation = Vec3(
                    translationArr.GetValue(0).Number().value.f,
                    translationArr.GetValue(1).Number().value.f,
                    translationArr.GetValue(2).Number().value.f
                );
            }
            
            rotationValue := nodeObj.GetMember("rotation");
            if (rotationValue)
            {
                rotationArr := rotationValue.Array();
                trs.rotation = Quaternion(
                    rotationArr.GetValue(0).Number().value.f,
                    rotationArr.GetValue(1).Number().value.f,
                    rotationArr.GetValue(2).Number().value.f,
                    rotationArr.GetValue(3).Number().value.f
                );
            }
            
            scaleValue := nodeObj.GetMember("scale");
            if (scaleValue)
            {
                scaleArr := scaleValue.Array();
                trs.scale = Vec3(
                    scaleArr.GetValue(0).Number().value.f,
                    scaleArr.GetValue(1).Number().value.f,
                    scaleArr.GetValue(2).Number().value.f
                );
            }
            
            node.transform.trs = trs;
        }
        
        gltf.nodes.Add(node);
    }
}

ParseGLTFMeshes(gltf: GLTF, root: *JSONObject)
{
    meshesValue := root.GetMember("meshes");
    if (!meshesValue) return;

    meshesArr := meshesValue.Array();
    gltf.meshes.SizeTo(meshesArr.values.count);
    for (meshValue in meshesArr.values)
    {
        mesh := GLTFMesh();
        meshObj := meshValue.Object();
        
        mesh.name = ParseGLTFStringPtr(gltf, meshObj.GetMember("name"));
        
        weightsValue := meshObj.GetMember("weights");
        if (weightsValue)
        {
            weightsArr := weightsValue.Array();
            mesh.weights.SizeTo(weightsArr.values.count);
            for (weightValue in weightsArr.values)
            {
                weight := weightValue.Number().value.f;
                mesh.weights.Add(weight);
            }
        }
        
        primitivesValue := meshObj.GetMember("primitives");
        if (!primitivesValue) continue;
        
        primitivesArr := primitivesValue.Array();
        mesh.primitives.SizeTo(primitivesArr.values.count);
        for (primitiveValue in primitivesArr.values)
        {
            primitive := GLTFPrimitive();
            primitiveObj := primitiveValue.Object();
            
            attributesValue := primitiveObj.GetMember("attributes");
            if (!attributesValue) continue;
            
            attributesObj := attributesValue.Object();
            for (attributeKV in attributesObj.members)
            {
                accessorKey := gltf.strMem.Copy(attributeKV.key~);
                accessor := attributeKV.value~.Number().value.i;

                primitive.attributes.Insert(accessorKey, accessor);
            }

            indicesValue := primitiveObj.GetMember("indices");
            if (indicesValue) primitive.indices = indicesValue.Number().value.i;
            
            materialValue := primitiveObj.GetMember("material");
            if (materialValue) primitive.material = materialValue.Number().value.i;
            
            modeValue := primitiveObj.GetMember("mode");
            if (modeValue) primitive.mode = modeValue.Number().value.i;
            
            targetsValue := primitiveObj.GetMember("targets");
            if (targetsValue)
            {
                targetsArr := targetsValue.Array();
                primitive.targets.SizeTo(targetsArr.values.count);
                for (targetValue in targetsArr.values)
                {
                    targetObj := targetValue.Object();
                    target := Map<string, uint32>();
                    
                    for (targetKV in targetObj.members)
                    {
                        targetKey := gltf.strMem.Copy(targetKV.key~);
                        accessor := targetKV.value~.Number().value.i;

                        target.Insert(targetKey, accessor);
                    }
                    
                    primitive.targets.Add(target);
                }
            }

            mesh.primitives.Add(primitive);
        }

        gltf.meshes.Add(mesh);
    }
}

GLTFTextureInfo ParseGLTFTextureInfo(gltf: GLTF, textureObj: *JSONObject)
{    
    textureInfo := GLTFTextureInfo();
    
    indexValue := textureObj.GetMember("index");
    if (indexValue) textureInfo.index = indexValue.Number().value.i;
    
    texCoordValue := textureObj.GetMember("texCoord");
    if (texCoordValue) textureInfo.texCoord = texCoordValue.Number().value.i;
    
    return textureInfo;
}

ParseGLTFMaterials(gltf: GLTF, root: *JSONObject)
{
    materialsValue := root.GetMember("materials");
    if (!materialsValue) return;

    materialsArr := materialsValue.Array();
    gltf.materials.SizeTo(materialsArr.values.count);
    for (materialValue in materialsArr.values)
    {
        material := GLTFMaterial();
        materialObj := materialValue.Object();
        
        material.name = ParseGLTFStringPtr(gltf, materialObj.GetMember("name"));
        
        pbrValue := materialObj.GetMember("pbrMetallicRoughness");
        if (pbrValue)
        {
            pbrObj := pbrValue.Object();
            pbr := gltf.mem.Emplace<GLTFMaterialPBRMetallicRoughness>();
            
            baseColorFactorValue := pbrObj.GetMember("baseColorFactor");
            if (baseColorFactorValue)
            {
                baseColorFactorArr := baseColorFactorValue.Array();
                pbr.baseColorFactor = Color(
                    baseColorFactorArr.GetValue(0).Number().value.f,
                    baseColorFactorArr.GetValue(1).Number().value.f,
                    baseColorFactorArr.GetValue(2).Number().value.f,
                    baseColorFactorArr.GetValue(3).Number().value.f
                );
            }
            
            baseColorTextureValue := pbrObj.GetMember("baseColorTexture");
            if (baseColorTextureValue)
            {
                pbr.baseColorTexture = gltf.mem.Insert<GLTFTextureInfo>(
                    ParseGLTFTextureInfo(gltf, baseColorTextureValue.Object())
                );
            }
  
            metallicRoughnessTextureValue := pbrObj.GetMember("metallicRoughnessTexture");
            if (metallicRoughnessTextureValue)
            {
                pbr.metallicRoughnessTexture = gltf.mem.Insert<GLTFTextureInfo>(
                    ParseGLTFTextureInfo(gltf, metallicRoughnessTextureValue.Object())
                );
            }
            
            metallicFactorValue := pbrObj.GetMember("metallicFactor");
            if (metallicFactorValue) 
                pbr.metallicFactor = metallicFactorValue.Number().value.f;
            
            roughnessFactorValue := pbrObj.GetMember("roughnessFactor");
            if (roughnessFactorValue) 
                pbr.roughnessFactor = roughnessFactorValue.Number().value.f;
            
            material.pbrMetallicRoughness = pbr;
        }
        
        normalTextureValue := materialObj.GetMember("normalTexture");
        if (normalTextureValue)
        {
            normalTextureObj := normalTextureValue.Object();
            normalTexture := gltf.mem.Emplace<GLTFNormalTextureInfo>();
            
            normalTexture.info = ParseGLTFTextureInfo(gltf, normalTextureObj);
            
            scaleValue := normalTextureObj.GetMember("scale");
            if (scaleValue) 
                normalTexture.scale = scaleValue.Number().value.f;
         
            material.normalTexture = normalTexture;
        }
        
        occlusionTextureValue := materialObj.GetMember("occlusionTexture");
        if (occlusionTextureValue)
        {
            occlusionTextureObj := occlusionTextureValue.Object();
            occlusionTexture := gltf.mem.Emplace<GLTFOcclusionTextureInfo>();
            
            occlusionTexture.info = ParseGLTFTextureInfo(gltf, occlusionTextureObj);
            
            strengthValue := occlusionTextureObj.GetMember("strength");
            if (strengthValue) 
                occlusionTexture.strength = strengthValue.Number().value.f;
            
            material.occlusionTexture = occlusionTexture;
        }
        
        emissiveTextureValue := materialObj.GetMember("emissiveTexture");
        if (emissiveTextureValue)
        {
            material.emissiveTexture = gltf.mem.Insert<GLTFTextureInfo>(
                ParseGLTFTextureInfo(gltf, emissiveTextureValue.Object())
            );
        }

        alphaModeValue := materialObj.GetMember("alphaMode");
        if (alphaModeValue)
        {
            alphaModeStr := alphaModeValue.String().value;
            material.alphaMode = gltf.strMem.Copy(alphaModeStr);
        }
        
        emissiveFactorValue := materialObj.GetMember("emissiveFactor");
        if (emissiveFactorValue)
        {
            emissiveFactorArr := emissiveFactorValue.Array();
            material.emissiveFactor = Vec3(
                emissiveFactorArr.GetValue(0).Number().value.f,
                emissiveFactorArr.GetValue(1).Number().value.f,
                emissiveFactorArr.GetValue(2).Number().value.f
            );
        }        
        
        alphaCutoffValue := materialObj.GetMember("alphaCutoff");
        if (alphaCutoffValue) 
            material.alphaCutoff = alphaCutoffValue.Number().value.f;
        
        doubleSidedValue := materialObj.GetMember("doubleSided");
        if (doubleSidedValue) 
            material.doubleSided = doubleSidedValue.Boolean().value;
        
        gltf.materials.Add(material);
    }
}

ParseGLTFAnimations(gltf: GLTF, root: *JSONObject)
{
    animationsValue := root.GetMember("animations");
    if (!animationsValue) return;

    animationsArr := animationsValue.Array();
    gltf.animations.SizeTo(animationsArr.values.count);
    for (animationValue in animationsArr.values)
    {
        animation := GLTFAnimation();
        animationObj := animationValue.Object();
        
        animation.name = ParseGLTFStringPtr(gltf, animationObj.GetMember("name"));
        
        channelsValue := animationObj.GetMember("channels");
        if (channelsValue)
        {
            channelsArr := channelsValue.Array();
            animation.channels.SizeTo(channelsArr.values.count);
            for (channelValue in channelsArr.values)
            {
                channel := GLTFAnimationChannel();
                channelObj := channelValue.Object();
                
                targetValue := channelObj.GetMember("target");
                if (targetValue)
                {
                    targetObj := targetValue.Object();
                    
                    pathValue := targetObj.GetMember("path");
                    if (pathValue)
                    {
                        pathStr := pathValue.String().value;
                        channel.target.path = gltf.strMem.Copy(pathStr);
                    }
                    
                    nodeValue := targetObj.GetMember("node");
                    if (nodeValue) channel.target.node = nodeValue.Number().value.i;
                }
                
                samplerValue := channelObj.GetMember("sampler");
                if (samplerValue) channel.sampler = samplerValue.Number().value.i;
                
                animation.channels.Add(channel);
            }
        }
        
        samplersValue := animationObj.GetMember("samplers");
        if (samplersValue)
        {
            samplersArr := samplersValue.Array();
            animation.samplers.SizeTo(samplersArr.values.count);
            for (samplerValue in samplersArr.values)
            {
                sampler := GLTFAnimationSampler();
                samplerObj := samplerValue.Object();
                
                interpolationValue := samplerObj.GetMember("interpolation");
                if (interpolationValue)
                {
                    interpolationStr := interpolationValue.String().value;
                    sampler.interpolation = gltf.strMem.Copy(interpolationStr);
                }
                
                inputValue := samplerObj.GetMember("input");
                if (inputValue) sampler.input = inputValue.Number().value.i;
                
                outputValue := samplerObj.GetMember("output");
                if (outputValue) sampler.output = outputValue.Number().value.i;
                
                animation.samplers.Add(sampler);
            }
        }
        
        gltf.animations.Add(animation);
    }
}

ParseGLTFCameras(gltf: GLTF, root: *JSONObject)
{
    camerasValue := root.GetMember("cameras");
    if (!camerasValue) return;

    camerasArr := camerasValue.Array();
    gltf.cameras.SizeTo(camerasArr.values.count);
    for (cameraValue in camerasArr.values)
    {
        camera := GLTFCamera();
        cameraObj := cameraValue.Object();
        
        camera.name = ParseGLTFStringPtr(gltf, cameraObj.GetMember("name"));
        
        typeValue := cameraObj.GetMember("type");
        if (typeValue)
        {
            typeStr := typeValue.String().value;
            camera.type = gltf.strMem.Copy(typeStr);
            
            if (typeStr == "perspective")
            {
                perspectiveValue := cameraObj.GetMember("perspective");
                if (perspectiveValue)
                {
                    perspectiveObj := perspectiveValue.Object();
                    perspective := GLTFCameraPerspective();
                    
                    aspectRatioValue := perspectiveObj.GetMember("aspectRatio");
                    if (aspectRatioValue) 
                        perspective.aspectRatio = aspectRatioValue.Number().value.f;
                    
                    yfovValue := perspectiveObj.GetMember("yfov");
                    if (yfovValue) 
                        perspective.yfov = yfovValue.Number().value.f;
                    
                    zfarValue := perspectiveObj.GetMember("zfar");
                    if (zfarValue) 
                        perspective.zfar = zfarValue.Number().value.f;
                    
                    znearValue := perspectiveObj.GetMember("znear");
                    if (znearValue) 
                        perspective.znear = znearValue.Number().value.f;
                    
                    camera.camera.perspective = perspective;
                }
            }
            else if (typeStr == "orthographic")
            {
                orthographicValue := cameraObj.GetMember("orthographic");
                if (orthographicValue)
                {
                    orthographicObj := orthographicValue.Object();
                    orthographic := GLTFCameraOrthographic();
                    
                    xmagValue := orthographicObj.GetMember("xmag");
                    if (xmagValue) 
                        orthographic.xmag = xmagValue.Number().value.f;
                    
                    ymagValue := orthographicObj.GetMember("ymag");
                    if (ymagValue) 
                        orthographic.ymag = ymagValue.Number().value.f;
                    
                    zfarValue := orthographicObj.GetMember("zfar");
                    if (zfarValue) 
                        orthographic.zfar = zfarValue.Number().value.f;
                    
                    znearValue := orthographicObj.GetMember("znear");
                    if (znearValue) 
                        orthographic.znear = znearValue.Number().value.f;
                    
                    camera.camera.orthographic = orthographic;
                }
            }
        }
        
        gltf.cameras.Add(camera);
    }
}

ParseGLTFSkins(gltf: GLTF, root: *JSONObject)
{
    skinsValue := root.GetMember("skins");
    if (!skinsValue) return;

    skinsArr := skinsValue.Array();
    gltf.skins.SizeTo(skinsArr.values.count);
    for (skinValue in skinsArr.values)
    {
        skin := GLTFSkin();
        skinObj := skinValue.Object();
        
        skin.name = ParseGLTFStringPtr(gltf, skinObj.GetMember("name"));
        
        inverseBindMatricesValue := skinObj.GetMember("inverseBindMatrices");
        if (inverseBindMatricesValue) 
            skin.inverseBindMatrices = inverseBindMatricesValue.Number().value.i;
        
        skeletonValue := skinObj.GetMember("skeleton");
        if (skeletonValue) 
            skin.skeleton = skeletonValue.Number().value.i;
        
        jointsValue := skinObj.GetMember("joints");
        if (jointsValue)
        {
            jointsArr := jointsValue.Array();
            skin.joints.SizeTo(jointsArr.values.count);
            for (jointValue in jointsArr.values)
            {
                jointIndex := jointValue.Number().value.i;
                skin.joints.Add(jointIndex);
            }
        }
        
        gltf.skins.Add(skin);
    }
}

ParseGLTFTextures(gltf: GLTF, root: *JSONObject)
{
    texturesValue := root.GetMember("textures");
    if (!texturesValue) return;

    texturesArr := texturesValue.Array();
    gltf.textures.SizeTo(texturesArr.values.count);
    for (textureValue in texturesArr.values)
    {
        texture := GLTFTexture();
        textureObj := textureValue.Object();
        
        texture.name = ParseGLTFStringPtr(gltf, textureObj.GetMember("name"));
        
        samplerValue := textureObj.GetMember("sampler");
        if (samplerValue) 
            texture.sampler = samplerValue.Number().value.i;
        
        sourceValue := textureObj.GetMember("source");
        if (sourceValue) 
            texture.source = sourceValue.Number().value.i;
        
        gltf.textures.Add(texture);
    }
}

ParseGLTFImages(gltf: GLTF, root: *JSONObject)
{
    imagesValue := root.GetMember("images");
    if (!imagesValue) return;

    imagesArr := imagesValue.Array();
    gltf.images.SizeTo(imagesArr.values.count);
    for (imageValue in imagesArr.values)
    {
        image := GLTFImage();
        imageObj := imageValue.Object();
        
        image.name = ParseGLTFStringPtr(gltf, imageObj.GetMember("name"));
        
        image.uri = ParseGLTFURI(gltf, imageObj.GetMember("uri"));
        
        mimeTypeValue := imageObj.GetMember("mimeType");
        if (mimeTypeValue)
        {
            mimeTypePtr := gltf.mem.Emplace<string>();
            mimeTypePtr~ = gltf.strMem.Copy(mimeTypeValue.String().value);
            image.mimeType = mimeTypePtr;
        }
        
        bufferViewValue := imageObj.GetMember("bufferView");
        if (bufferViewValue)
            image.bufferView = bufferViewValue.Number().value.i;
        
        gltf.images.Add(image);
    }
}

ParseGLTFSamplers(gltf: GLTF, root: *JSONObject)
{
    samplersValue := root.GetMember("samplers");
    if (!samplersValue) return;

    samplersArr := samplersValue.Array();
    gltf.samplers.SizeTo(samplersArr.values.count);
    for (samplerValue in samplersArr.values)
    {
        sampler := GLTFSampler();
        samplerObj := samplerValue.Object();
        
        sampler.name = ParseGLTFStringPtr(gltf, samplerObj.GetMember("name"));
        
        magFilterValue := samplerObj.GetMember("magFilter");
        if (magFilterValue) 
            sampler.magFilter = magFilterValue.Number().value.i;
        
        minFilterValue := samplerObj.GetMember("minFilter");
        if (minFilterValue) 
            sampler.minFilter = minFilterValue.Number().value.i;
        
        wrapSValue := samplerObj.GetMember("wrapS");
        if (wrapSValue) 
            sampler.wrapS = wrapSValue.Number().value.i;
        
        wrapTValue := samplerObj.GetMember("wrapT");
        if (wrapTValue) 
            sampler.wrapT = wrapTValue.Number().value.i;
        
        gltf.samplers.Add(sampler);
    }
}

ParseGLTFBuffers(gltf: GLTF, root: *JSONObject)
{
    buffersValue := root.GetMember("buffers");
    if (!buffersValue) return;

    buffersArr := buffersValue.Array();
    gltf.buffers.SizeTo(buffersArr.values.count);
    for (bufferValue in buffersArr.values)
    {
        buffer := GLTFBuffer();
        bufferObj := bufferValue.Object();
        
        buffer.name = ParseGLTFStringPtr(gltf, bufferObj.GetMember("name"));
        
        buffer.uri = ParseGLTFURI(gltf, bufferObj.GetMember("uri"));
        
        byteLengthValue := bufferObj.GetMember("byteLength");
        buffer.byteLength = byteLengthValue.Number().value.i;
        
        gltf.buffers.Add(buffer);
    }
}

ParseGLTFBufferViews(gltf: GLTF, root: *JSONObject)
{
    bufferViewsValue := root.GetMember("bufferViews");
    if (!bufferViewsValue) return;

    bufferViewsArr := bufferViewsValue.Array();
    gltf.bufferViews.SizeTo(bufferViewsArr.values.count);
    for (bufferViewValue in bufferViewsArr.values)
    {
        bufferView := GLTFBufferView();
        bufferViewObj := bufferViewValue.Object();
        
        bufferView.name = ParseGLTFStringPtr(gltf, bufferViewObj.GetMember("name"));
        
        bufferValue := bufferViewObj.GetMember("buffer");
        bufferView.buffer = bufferValue.Number().value.i;
        
        byteLengthValue := bufferViewObj.GetMember("byteLength");
        bufferView.byteLength = byteLengthValue.Number().value.i;
        
        byteOffsetValue := bufferViewObj.GetMember("byteOffset");
        if (byteOffsetValue)
            bufferView.byteOffset = byteOffsetValue.Number().value.i;
        
        byteStrideValue := bufferViewObj.GetMember("byteStride");
        if (byteStrideValue)
            bufferView.byteStride = byteStrideValue.Number().value.i;
        
        targetValue := bufferViewObj.GetMember("target");
        if (targetValue)
            bufferView.target = targetValue.Number().value.i;
        
        gltf.bufferViews.Add(bufferView);
    }
}

ParseGLTFAccessors(gltf: GLTF, root: *JSONObject)
{
    accessorsValue := root.GetMember("accessors");
    if (!accessorsValue) return;

    accessorsArr := accessorsValue.Array();
    gltf.accessors.SizeTo(accessorsArr.values.count);
    for (accessorValue in accessorsArr.values)
    {
        accessor := GLTFAccessor();
        accessorObj := accessorValue.Object();
        
        accessor.name = ParseGLTFStringPtr(gltf, accessorObj.GetMember("name"));
        
        bufferViewValue := accessorObj.GetMember("bufferView");
        if (bufferViewValue)
            accessor.bufferView = bufferViewValue.Number().value.i;
        
        byteOffsetValue := accessorObj.GetMember("byteOffset");
        if (byteOffsetValue)
            accessor.byteOffset = byteOffsetValue.Number().value.i;
        
        componentTypeValue := accessorObj.GetMember("componentType");
        accessor.componentType = componentTypeValue.Number().value.i;
        
        normalizedValue := accessorObj.GetMember("normalized");
        if (normalizedValue)
            accessor.normalized = normalizedValue.Boolean().value;
        
        countValue := accessorObj.GetMember("count");
        accessor.count = countValue.Number().value.i;
        
        typeValue := accessorObj.GetMember("type");
        accessor.type = gltf.strMem.Copy(typeValue.String().value);
        
        minValue := accessorObj.GetMember("min");
        if (minValue)
        {
            minArr := minValue.Array();
            accessor.min.SizeTo(minArr.values.count);
            for (value in minArr.values)
            {
                accessor.min.Add(value.Number().value.f);
            }
        }
        
        maxValue := accessorObj.GetMember("max");
        if (maxValue)
        {
            maxArr := maxValue.Array();
            accessor.max.SizeTo(maxArr.values.count);
            for (value in maxArr.values)
            {
                accessor.max.Add(value.Number().value.f);
            }
        }
        
        sparseValue := accessorObj.GetMember("sparse");
        if (sparseValue)
        {
            sparseObj := sparseValue.Object();
            sparse := gltf.mem.Emplace<GLTFAccessorSparse>();
            
            sparseCountValue := sparseObj.GetMember("count");
            sparse.count = sparseCountValue.Number().value.i;
            
            indicesValue := sparseObj.GetMember("indices");
            indicesObj := indicesValue.Object();
            
            bufferViewValue := indicesObj.GetMember("bufferView");
            sparse.indices.bufferView = bufferViewValue.Number().value.i;
            
            componentTypeValue := indicesObj.GetMember("componentType");
            sparse.indices.componentType = componentTypeValue.Number().value.i;
            
            byteOffsetValue := indicesObj.GetMember("byteOffset");
            if (byteOffsetValue)
                sparse.indices.byteOffset = byteOffsetValue.Number().value.i;
            
            valuesValue := sparseObj.GetMember("values");
            valuesObj := valuesValue.Object();
            
            bufferViewValue = valuesObj.GetMember("bufferView");
            sparse.values.bufferView = bufferViewValue.Number().value.i;
            
            byteOffsetValue = valuesObj.GetMember("byteOffset");
            if (byteOffsetValue)
                sparse.values.byteOffset = byteOffsetValue.Number().value.i;
            
            accessor.sparse = sparse;
        }
        
        gltf.accessors.Add(accessor);
    }
}