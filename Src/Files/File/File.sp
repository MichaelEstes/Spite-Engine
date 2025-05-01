package File

import OS
import Fiber
import ThreadParamAllocator

state LoadFileParam
{
    file: string,
    contents: *string
}

LoadFileAsync(file: string)
{

}

*Fiber.JobHandle LoadFileFiber(file: string, contents: *string)
{
    data := AllocThreadParam<LoadFileParam>();
    data.file = file;
    data.contents = contents;

    handle: *Fiber.JobHandle = null; 
    Fiber.AddJob(::(data: *LoadFileParam) {
        defer DeallocThreadParam<LoadFileParam>(data);
        data.contents~ = OS.ReadFile(data.file~);
    }, data, Fiber.JobPriority.High, handle@);

    return handle;
}