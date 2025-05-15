package FileManager

import ThreadParamAllocator
import Fiber
import OS
import SparseSet

state FileManager
{
    fileToHandle := Map<string, uint32>(),
    handleToContent := SparseSet<string>(),

    currentHandle := uint32(0)
}

fileManager := FileManager();

state LoadFileParam
{
    onLoad: ::(string, uint32),
    file: string,
}

LoadFileAsync(file: string, onLoad: ::(string, uint32))
{
    loadFileParam := AllocThreadParam<LoadFileParam>();
    loadFileParam.onLoad = onLoad;
    loadFileParam.file = file;

    if (fileManager.fileToHandle.Has(file))
    {
        handle := fileManager.fileToHandle[file]~;
        fileContent := fileManager.handleToContent.Get(handle)~;
        onLoad(fileContent, handle);
        return;
    }

    Fiber.RunOnMainFiber(::(data: *LoadFileParam) {
        defer DeallocThreadParam<LoadFileParam>(data);

        fileContent := OS.ReadFile(data.file);
        handle := fileManager.currentHandle;
        fileManager.fileToHandle.Insert(data.file, handle);
        fileManager.handleToContent.Insert(handle, fileContent);
        fileManager.currentHandle += 1;

        data.onLoad(fileContent, handle);
    }, loadFileParam);
}