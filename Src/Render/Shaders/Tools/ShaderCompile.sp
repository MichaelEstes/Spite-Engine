package ShaderTools

import Shaderc

state ShaderCompiler
{
    compiler: *any,
    options: *any
}

ShaderCompiler::delete
{
    shaderc_compiler_release(this.compiler);
    shaderc_compile_options_release(this.options);
}

ShaderCompiler InitShaderCompiler()
{
    compiler := ShaderCompiler();
    compiler.compiler = shaderc_compiler_initialize();
    compiler.options  = shaderc_compile_options_initialize();

    shaderc_compile_options_set_target_env(compiler.options, TargetEnv.Vulkan, 0);
    shaderc_compile_options_set_target_spirv(compiler.options, SpvVersion.V1_0);
    shaderc_compile_options_set_optimization_level(compiler.options, OptimizationLevel.Performance);

    return compiler;
}

string CompileShader(
    shaderSource: string, 
    compiler: ShaderCompiler,
    inputFile: string = "shader"
    entryPoint: string = "main"
)
{
    result := shaderc_compile_into_spv(
        compiler.compiler, 
        shaderSource[0], 
        shaderSource.count,
        ShaderKind.InferFromSource,
        inputFile[0], entryPoint[0],
        compiler.options
    );
    defer shaderc_result_release(result);

    status := shaderc_result_get_compilation_status(result);
    if (status != CompilationStatus.Success)
    {
        log "Shader compilation failed: ", string(shaderc_result_get_error_message(result));
        log "Shader: ", shaderSource;
        return "";
    }

    spirvData: *byte = shaderc_result_get_bytes(result);
    spirvLength := shaderc_result_get_length(result);

    spirvCopy := ZeroedAllocator<byte>().Alloc(spirvLength);
    for (i .. spirvLength)
        spirvCopy[i]~ = spirvData[i]~;

    return string(spirvLength, spirvCopy[0]);
}