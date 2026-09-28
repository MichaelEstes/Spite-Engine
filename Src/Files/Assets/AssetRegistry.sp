package Assets

import Array
import OS


state AssetDir
{
    dir: string
}

state AssetPath
{
    path: string
}

state Asset
{
    name: string
}

state AssetRegistry
{
    assetsPaths := Set<string>(),
    assetDirTable := Map<string, Map<string, string>>()
}

Asset::(name: string)
{
    this.name = name;
}

assetRegistry := AssetRegistry();

bool RegistryAssetDirectory(dir: string)
{
    if (!OS.PathExists(dir))
    {
        log "RegistryAssetDirectory :: Directory does not exist", dir;
        return false;
    }

    assetRegistry.assetsPaths.Insert(dir);

    if (!assetRegistry.assetDirTable.Has(dir))
    {
        assetRegistry.assetDirTable.Insert(dir, Map<string, string>());
    }

    IterateDirectory(
        dir, 
        ::(path: string, isDirectory: bool, initialDir: *string)
        {
            if (isDirectory) return;
            
            fileName := OS.GetFileName(path);
            assetNameToPath := assetRegistry.assetDirTable.Find(initialDir~);
            if (assetNameToPath.Has(fileName))
            {
                log "RegistryAssetDirectory :: Multiple files with same name in asset registry: ", fileName;
            }
            assetNameToPath.Insert(fileName, path.Copy());
        },
        dir@
    );

    return true;
}

string GetAssetPath(asset: Asset)
{
    for (kv in assetRegistry.assetDirTable)
    {
        assetTable := kv.value;
        if (assetTable.Has(asset.name))
        {
            path := assetTable.Find(asset.name)~;
            return path;
        }
    }

    return "";
}