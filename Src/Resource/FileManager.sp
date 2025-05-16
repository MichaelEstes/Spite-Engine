package FileManager

import ThreadParamAllocator
import Fiber
import OS
import SparseSet
import HandleSet

state FileHandle
{
    id: uint32
}

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
    fileToHandle := Map<string, FileHandle>(),
    fileHandles := HandleSet<FileRef>()
}

fileManager := FileManager();

state LoadFileParam
{
    onLoad: ::(FileHandle),
    file: string,
}

LoadFileAsync(file: string, onLoad: ::(FileHandle))
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

        handle := handleValue.handle as FileHandle;
        fileManager.fileToHandle.Insert(data.file, handle);

        data.onLoad(handle);
    }, loadFileParam);
}

string TakeFileRef(handle: FileHandle)
{
    fileRef := fileManager.fileHandles[handle.id]~;
    fileRef.refCount += 1;
    return fileRef.contents;
}

ReleaseFileRef(handle: FileHandle)
{
    id := handle.id;
    if (!fileManager.fileHandles.Has(id)) return;

    fileRef := fileManager.fileHandles[id]~;
    fileRef.refCount -= 1;
    if (fileRef.refCount == 0)
    {
        fileManager.fileToHandle.Remove(fileRef.key);
        fileManager.fileHandles.Remove(id);
        delete fileRef;
    }
}