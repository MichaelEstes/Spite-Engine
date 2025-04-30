package File

import OS
import Fiber

LoadFileAsync(file: string)
{

}

LoadFileFiber(file: *string)
{
    handle := Fiber.AddJob(::(data: *string) {
        OS.ReadFile(data~);
    }, file);
}