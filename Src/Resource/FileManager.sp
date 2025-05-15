package FileManager

import ThreadParamAllocator
import Fiber
import OS
import SparseSet
import HandleSet

state FileManager
{
    fileHandles := HandleSet<string>(),
    fileReferences := SparseSet<uint32>()
}

fileManager := FileManager();

state LoadFileParam
{
    onLoad: ::(string, uint32),
    file: string,
}

LoadFileAsync(file: string, onLoad: ::(uint32))
{
    if (fileManager.fileToHandle.Has(file))
    {
        handle := fileManager.fileToHandle[file]~;
        onLoad(handle.id);
        return;
    }

    loadFileParam := AllocThreadParam<LoadFileParam>();
    loadFileParam.onLoad = onLoad;
    loadFileParam.file = file;

    Fiber.RunOnMainFiber(::(data: *LoadFileParam) {
        defer DeallocThreadParam<LoadFileParam>(data);

        fileContent := OS.ReadFile(data.file);
        handle := FileHandle();
        handle.id = fileManager.currentID;
        fileManager.fileToHandle.Insert(data.file, handle);
        fileManager.handleToContent.Insert(handle, fileContent);
        fileManager.currentID += 1;

        data.onLoad(fileContent, handle);
    }, loadFileParam);
}