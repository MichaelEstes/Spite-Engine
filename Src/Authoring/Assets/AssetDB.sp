package Authoring

import Array
import Math

enum AssetDBItemKind
{
    Model,
    Texture,
    Material,
    Shader
}

state AssetDBItem
{
    localPath: string,
    uuid: [16]byte,
    ext: [8]byte,
    associated: Array<AssetDbItem>,
    kind: AssetDBItemKind
}

state AssetDB
{
    assets: Map<[16]byte, AssetDBItem>
}
