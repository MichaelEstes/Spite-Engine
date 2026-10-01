package SDL

extern
{
	#link windows "./extern/SDL3_image";
    #link linux "./extern/libSDL3_image";

    *Surface IMG_Load(file: *byte);
    *Surface IMG_Load_IO(ioStream: *IOStream, close: bool);

    bool IMG_SavePNG(surface: *Surface, file: *byte);
}

*Surface LoadImage(file: string) => IMG_Load(file[0]);

*Surface CreateImage(ioStream: *IOStream, close: bool)
    => IMG_Load_IO(ioStream, close);

bool SavePNG(surface: *Surface, file: *byte) => IMG_SavePNG(surface, file);
