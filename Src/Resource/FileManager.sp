package FileManager

import ThreadParamAllocator
import Fiber
import OS
import SparseSet
import HandleSet

state FileRef
{
    key: string,
    contents: string,
    refCount: uint
}

FileRef::delete
{
    delete this.contents;
}

state FileManager
{
    fileToHandle := Map<string, uint32>(),
    fileHandles := HandleSet<FileRef>()
}

fileManager := FileManager();

state LoadFileParam
{
    onLoad: ::(uint32),
    file: string,
}

LoadFileAsync(file: string, onLoad: ::(uint32))
{
    if (fileManager.fileToHandle.Has(file))
    {
        handle := fileManager.fileToHandle[file]~;
        onLoad(handle);
        return;
    }

    loadFileParam := AllocThreadParam<LoadFileParam>();
    loadFileParam.onLoad = onLoad;
    loadFileParam.file = file;

    Fiber.RunOnMainFiber(::(data: *LoadFileParam) {
        defer DeallocThreadParam<LoadFileParam>(data);

        fileContent := OS.ReadFile(data.file);
        handleValue := fileManager.fileHandles.GetNext();
        handleValue.value.key = data.file;
        handleValue.value.contents = fileContent;
        handleValue.value.refCount = 0;

        handle := handleValue.handle;
        fileManager.fileToHandle.Insert(data.file, handle);

        data.onLoad(handle);
    }, loadFileParam);
}

string TakeFileRef(handle: uint32)
{
    fileRef := fileManager.fileHandles[handle]~;
    fileRef.refCount += 1;
    return fileRef.contents;
}

ReleaseFileRef(handle: uint32)
{
    if (!fileManager.fileHandles.Has(handle)) return;

    fileRef := fileManager.fileHandles[handle]~;
    fileRef.refCount -= 1;
    if (fileRef.refCount == 0)
    {
        fileManager.fileToHandle.Remove(fileRef.key);
        fileManager.fileHandles.Remove(handle);
        delete fileRef;
    }
}