package File

bool IsDataURI(uri: string)
{
    dataPrefix := "data:";
    if (uri.count < dataPrefix.count) return false;
    return uri.StartsWith(dataPrefix);
}

//https://stackoverflow.com/questions/180947/base64-decode-snippet-in-c/13935718
string Base64Decode(encoded: string)
{
    count := encoded.count;
    if (count == 0) return "";

   b64index := int32:[
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  62, 63, 62, 62, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 0,  0,  0,  0,  0,  0,
        0,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 0,  0,  0,  0,  63,
        0,  26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51
   ];
    
    strArr: *byte = encoded[0];
    pad := count % 4 || strArr[count - 1]~ == '=';
    pad2 := pad && (count % 4 > 2 || strArr[count - 2] != '=');
    end := (count - pad) / 4 << 2;
    decodedCount := end / 4 * 3 + pad + pad2;
    decodedBuf := ZeroedAllocator<byte>().Alloc(decodedCount);
    
    i := 0;
    j := 0;
    while (i < end)
    {
        n := b64index[strArr[i]~] << 18     |
             b64index[strArr[i + 1]~] << 12 |
             b64index[strArr[i + 2]~] << 6  |
             b64index[strArr[i + 3]~];

        decodedBuf[j]~ = n >> 16;
        decodedBuf[j + 1]~ = n >> 8 & 0xFF;
        decodedBuf[j + 2]~ = n & 0xFF;

        j += 3;
        i += 4;
    }

    if (pad)
    {
        n := b64index[strArr[end]~] << 18 | 
             b64index[strArr[end + 1]~] << 12;

        decodedBuf[j]~ = n >> 16;

        if (pad2)
        {
            n |= b64index[strArr[end + 2]~] << 6;
            decodedBuf[j + 1]~ = n >> 8 & 0xFF;
        }
    }

    return string(decodedCount, decodedBuf[0]);
}