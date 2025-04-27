package SDL

extern
{
	#link windows "./extern/SDL3_image";
    #link linux "./extern/libSDL3_image";

    *Surface IMG_Load(file: *byte);
}

*Surface LoadImage(file: string) => IMG_Load(file[0]);