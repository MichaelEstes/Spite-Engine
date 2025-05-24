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
    delete this.key;
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
    onLoad: ::(FileHandle, *any),
    file: string,
    data: *any
}

FileHandle LoadFile(file: string)
{
    if (fileManager.fileToHandle.Has(file))
    {
        handle := fileManager.fileToHandle[file]~;
        return handle;
    }

    fileName := file.Copy();
    fileContent := OS.ReadFile(fileName);
    handleValue := fileManager.fileHandles.GetNext();
    handleValue.value.key = fileName;
    handleValue.value.contents = fileContent;
    handleValue.value.refCount = 0;

    handle := handleValue.handle as FileHandle;
    fileManager.fileToHandle.Insert(fileName, handle);

    return handle;
}

LoadFileAsync(file: string, onLoad: ::(FileHandle, *any), data: *any = null)
{
    if (fileManager.fileToHandle.Has(file))
    {
        handle := fileManager.fileToHandle[file]~;
        onLoad(handle, data);
        return;
    }

    loadFileParam := AllocThreadParam<LoadFileParam>();
    loadFileParam.onLoad = onLoad;
    loadFileParam.file = file;
    loadFileParam.data = data;

    Fiber.RunOnMainFiber(::(param: *LoadFileParam) 
    {
        defer DeallocThreadParam<LoadFileParam>(param);

        handle := LoadFile(param.file);

        param.onLoad(handle, param.data);
    }, loadFileParam);
}

string TakeFileRef(handle: FileHandle)
{
    fileRef := fileManager.fileHandles[handle.id];
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