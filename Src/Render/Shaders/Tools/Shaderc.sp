package Shaderc

extern
{
    #link windows "./extern/shaderc_shared";

    *void shaderc_compiler_initialize();
    void  shaderc_compiler_release(compiler: *void);

    *void shaderc_compile_options_initialize();
    *void shaderc_compile_options_clone(options: *void);
    void  shaderc_compile_options_release(options: *void);

    void shaderc_compile_options_add_macro_definition(options: *void, name: *byte, name_length: uint, value: *byte, value_length: uint);

    void shaderc_compile_options_set_source_language(options: *void, lang: SourceLanguage);
    void shaderc_compile_options_set_forced_version_profile(options: *void, version: int32, profile: Profile);
    void shaderc_compile_options_set_target_env(options: *void, target: TargetEnv, version: uint32);
    void shaderc_compile_options_set_target_spirv(options: *void, ver: SpvVersion);

    void shaderc_compile_options_set_generate_debug_info(options: *void);
    void shaderc_compile_options_set_suppress_warnings(options: *void);
    void shaderc_compile_options_set_warnings_as_errors(options: *void);

    void shaderc_compile_options_set_optimization_level(options: *void, level: OptimizationLevel);
    void shaderc_compile_options_set_limit(options: *void, limit: Limit, value: int32);
    void shaderc_compile_options_set_nan_clamp(options: *void, enable: bool);

    void shaderc_compile_options_set_auto_bind_uniforms(options: *void, auto_bind: bool);
    void shaderc_compile_options_set_auto_map_locations(options: *void, auto_map: bool);
    void shaderc_compile_options_set_preserve_bindings(options: *void, preserve_bindings: bool);
    void shaderc_compile_options_set_binding_base(options: *void, kind: UniformKind, base: uint32);
    void shaderc_compile_options_set_binding_base_for_stage(options: *void, shader_kind: ShaderKind, kind: UniformKind, base: uint32);

    void shaderc_compile_options_set_hlsl_io_mapping(options: *void, hlsl_iomap: bool);
    void shaderc_compile_options_set_hlsl_offsets(options: *void, hlsl_offsets: bool);
    void shaderc_compile_options_set_hlsl_functionality1(options: *void, enable: bool);
    void shaderc_compile_options_set_hlsl_16bit_types(options: *void, enable: bool);
    void shaderc_compile_options_set_hlsl_register_set_and_binding(options: *void, reg: *byte, set: *byte, binding: *byte);
    void shaderc_compile_options_set_hlsl_register_set_and_binding_for_stage(options: *void, shader_kind: ShaderKind, reg: *byte, set: *byte, binding: *byte);
    void shaderc_compile_options_set_auto_combined_image_sampler(options: *void, upgrade: bool);

    void shaderc_compile_options_set_vulkan_rules_relaxed(options: *void, relaxed: bool);
    void shaderc_compile_options_set_invert_y(options: *void, enable: bool);

    void shaderc_compile_options_set_include_callbacks(options: *void, resolver: *void, result_releaser: *void, user_data: *void);

    *void shaderc_compile_into_spv(compiler: *void, source_text: *byte, source_text_size: uint, shader_kind: ShaderKind, input_file_name: *byte, entry_point_name: *byte, additional_options: *void);
    *void shaderc_compile_into_spv_assembly(compiler: *void, source_text: *byte, source_text_size: uint, shader_kind: ShaderKind, input_file_name: *byte, entry_point_name: *byte, additional_options: *void);
    *void shaderc_compile_into_preprocessed_text(compiler: *void, source_text: *byte, source_text_size: uint, shader_kind: ShaderKind, input_file_name: *byte, entry_point_name: *byte, additional_options: *void);
    *void shaderc_assemble_into_spv(compiler: *void, source_assembly: *byte, source_assembly_size: uint, additional_options: *void);

    void              shaderc_result_release(result: *void);
    CompilationStatus shaderc_result_get_compilation_status(result: *void);
    *byte             shaderc_result_get_error_message(result: *void);
    *byte             shaderc_result_get_bytes(result: *void);
    uint              shaderc_result_get_length(result: *void);
    uint              shaderc_result_get_num_warnings(result: *void);
    uint              shaderc_result_get_num_errors(result: *void);

    void shaderc_get_spv_version(version: *uint32, revision: *uint32);
    bool shaderc_parse_version_profile(str: *byte, version: *int32, profile: *Profile);
}

enum ShaderKind: int32
{
    Vertex                = 0,
    Fragment              = 1,
    Compute               = 2,
    Geometry              = 3,
    TessControl           = 4,
    TessEvaluation        = 5,
    InferFromSource       = 6,
    DefaultVertex         = 7,
    DefaultFragment       = 8,
    DefaultCompute        = 9,
    DefaultGeometry       = 10,
    DefaultTessControl    = 11,
    DefaultTessEvaluation = 12,
    SpirvAssembly         = 13,
    RayGen                = 14,
    AnyHit                = 15,
    ClosestHit            = 16,
    Miss                  = 17,
    Intersection          = 18,
    Callable              = 19,
    DefaultRayGen         = 20,
    DefaultAnyHit         = 21,
    DefaultClosestHit     = 22,
    DefaultMiss           = 23,
    DefaultIntersection   = 24,
    DefaultCallable       = 25,
    Task                  = 26,
    Mesh                  = 27,
    DefaultTask           = 28,
    DefaultMesh           = 29,
}

enum SourceLanguage: int32
{
    GLSL,
    HLSL,
}

enum OptimizationLevel: int32
{
    Zero,
    Size,
    Performance,
}

enum TargetEnv: int32
{
    Vulkan,
    OpenGL,
    OpenGLCompat,
    WebGPU,
}

enum SpvVersion: uint32
{
    V1_0 = 0x010000,
    V1_1 = 0x010100,
    V1_2 = 0x010200,
    V1_3 = 0x010300,
    V1_4 = 0x010400,
    V1_5 = 0x010500,
    V1_6 = 0x010600,
}

enum CompilationStatus: int32
{
    Success,
    InvalidStage,
    CompilationError,
    InternalError,
    NullResultObject,
    InvalidAssembly,
    ValidationError,
    TransformationError,
    ConfigurationError,
}

enum Profile: int32
{
    None,
    Core,
    Compatibility,
    ES,
}

enum UniformKind: int32
{
    Image,
    Sampler,
    Texture,
    Buffer,
    StorageBuffer,
    UnorderedAccessView,
}

enum IncludeType: int32
{
    Relative,
    Standard,
}

enum Limit: int32
{
    MaxLights,
    MaxClipPlanes,
    MaxTextureUnits,
    MaxTextureCoords,
    MaxVertexAttribs,
    MaxVertexUniformComponents,
    MaxVaryingFloats,
    MaxVertexTextureImageUnits,
    MaxCombinedTextureImageUnits,
    MaxTextureImageUnits,
    MaxFragmentUniformComponents,
    MaxDrawBuffers,
    MaxVertexUniformVectors,
    MaxVaryingVectors,
    MaxFragmentUniformVectors,
    MaxVertexOutputVectors,
    MaxFragmentInputVectors,
    MinProgramTexelOffset,
    MaxProgramTexelOffset,
    MaxClipDistances,
    MaxComputeWorkGroupCountX,
    MaxComputeWorkGroupCountY,
    MaxComputeWorkGroupCountZ,
    MaxComputeWorkGroupSizeX,
    MaxComputeWorkGroupSizeY,
    MaxComputeWorkGroupSizeZ,
    MaxComputeUniformComponents,
    MaxComputeTextureImageUnits,
    MaxComputeImageUniforms,
    MaxComputeAtomicCounters,
    MaxComputeAtomicCounterBuffers,
    MaxVaryingComponents,
    MaxVertexOutputComponents,
    MaxGeometryInputComponents,
    MaxGeometryOutputComponents,
    MaxFragmentInputComponents,
    MaxImageUnits,
    MaxCombinedImageUnitsAndFragmentOutputs,
    MaxCombinedShaderOutputResources,
    MaxImageSamples,
    MaxVertexImageUniforms,
    MaxTessControlImageUniforms,
    MaxTessEvaluationImageUniforms,
    MaxGeometryImageUniforms,
    MaxFragmentImageUniforms,
    MaxCombinedImageUniforms,
    MaxGeometryTextureImageUnits,
    MaxGeometryOutputVertices,
    MaxGeometryTotalOutputComponents,
    MaxGeometryUniformComponents,
    MaxGeometryVaryingComponents,
    MaxTessControlInputComponents,
    MaxTessControlOutputComponents,
    MaxTessControlTextureImageUnits,
    MaxTessControlUniformComponents,
    MaxTessControlTotalOutputComponents,
    MaxTessEvaluationInputComponents,
    MaxTessEvaluationOutputComponents,
    MaxTessEvaluationTextureImageUnits,
    MaxTessEvaluationUniformComponents,
    MaxTessPatchComponents,
    MaxPatchVertices,
    MaxTessGenLevel,
    MaxViewports,
    MaxVertexAtomicCounters,
    MaxTessControlAtomicCounters,
    MaxTessEvaluationAtomicCounters,
    MaxGeometryAtomicCounters,
    MaxFragmentAtomicCounters,
    MaxCombinedAtomicCounters,
    MaxAtomicCounterBindings,
    MaxVertexAtomicCounterBuffers,
    MaxTessControlAtomicCounterBuffers,
    MaxTessEvaluationAtomicCounterBuffers,
    MaxGeometryAtomicCounterBuffers,
    MaxFragmentAtomicCounterBuffers,
    MaxCombinedAtomicCounterBuffers,
    MaxAtomicCounterBufferSize,
    MaxTransformFeedbackBuffers,
    MaxTransformFeedbackInterleavedComponents,
    MaxCullDistances,
    MaxCombinedClipAndCullDistances,
    MaxSamples,
    MaxMeshOutputVerticesNV,
    MaxMeshOutputPrimitivesNV,
    MaxMeshWorkGroupSizeXNV,
    MaxMeshWorkGroupSizeYNV,
    MaxMeshWorkGroupSizeZNV,
    MaxTaskWorkGroupSizeXNV,
    MaxTaskWorkGroupSizeYNV,
    MaxTaskWorkGroupSizeZNV,
    MaxMeshViewCountNV,
    MaxMeshOutputVerticesEXT,
    MaxMeshOutputPrimitivesEXT,
    MaxMeshWorkGroupSizeXEXT,
    MaxMeshWorkGroupSizeYEXT,
    MaxMeshWorkGroupSizeZEXT,
    MaxTaskWorkGroupSizeXEXT,
    MaxTaskWorkGroupSizeYEXT,
    MaxTaskWorkGroupSizeZEXT,
    MaxMeshViewCountEXT,
    MaxDualSourceDrawBuffersEXT,
}

state IncludeResult
{
    source_name:        *byte,
    source_name_length: uint,
    content:            *byte,
    content_length:     uint,
    user_data:          *void,
}
