package ResourceManagers

import GLTFManager
import ImageManager
import URIManager

Map<[8]byte, uint32> CreateResourceExtToManagerIDMap()
{
    extToID := Map<[8]byte, uint32>();
    
    extToID.Insert("gltf".ToFixed<8>(), GLTFResourceManagerID);

    log "CREATED RESOURCE EXT TO MANAGER ID MAP";

    return extToID;
}

ResourceExtToManagerID := CreateResourceExtToManagerIDMap();