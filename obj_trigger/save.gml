    if file_exists(iniFile)
    {
        ini_open(iniFile)
        offset = [ini_read_real("offset", "x", 0), ini_read_real("offset", "y", 0)]
        centered = ini_read_real("offset", "centered", false)
        images = ini_read_real("properties", "images", 1)
        image_width = ini_read_real("properties", "image_width", 0)
        tile_size = abs(int64(ini_read_real("tileset", "size", 0)))
        if (tile_size != 0)
            tile_scaleX = 32 / tile_size
        tile_scaleY = 32 / tile_size
        tile_scale = 32 / tile_size
        ini_close()
    }