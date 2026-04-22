package UUID

import OS

state UUID
{
    data: [16]byte
}

UUID::()
{
    this.data = OS.CreateUUID();
}

string UUID::log()
{
    hexChars := "0123456789abcdef";
    bytes := this.data[0]@ as *ubyte;
    buffer := ZeroedAllocator<byte>().Alloc(37)[0];
    outIndex := 0;

    for (i .. 16)
    {
        if (i == 4 || i == 6 || i == 8 || i == 10)
        {
            buffer[outIndex]~ = '-';
            outIndex += 1;
        }

        value := bytes[i]~;
        buffer[outIndex]~ = hexChars[((value >> 4) & 0xF) as uint]~;
        buffer[outIndex + 1]~ = hexChars[(value & 0xF) as uint]~;
        outIndex += 2;
    }

    return {36, buffer} as string;
}
