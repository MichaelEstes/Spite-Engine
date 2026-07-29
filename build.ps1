param(
    [switch]$Debug
)

$ErrorActionPreference = "Stop"

$msvcBin = "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\bin\Hostx64\x64"
$msvcLib = "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.44.35207\lib\x64"
$winSdkLib = "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.26100.0"
$vulkanSdk = if ($env:VULKAN_SDK) { $env:VULKAN_SDK } else { "C:\VulkanSDK\1.4.304.1" }

$dumpbin = Join-Path $msvcBin "dumpbin.exe"
$libExe = Join-Path $msvcBin "lib.exe"
$linkExe = Join-Path $msvcBin "link.exe"

$buildDir = Join-Path $PSScriptRoot "Build"
$dlls = Get-ChildItem -Path (Join-Path $PSScriptRoot "Src") -Recurse -Filter *.dll
$genLibDir = Join-Path $buildDir "GeneratedLibs"
New-Item -ItemType Directory -Force -Path $genLibDir | Out-Null

$libDirs = New-Object System.Collections.Generic.HashSet[string]
$libNames = New-Object System.Collections.Generic.List[string]

foreach ($dll in $dlls) {
    $checkedInLibPath = [System.IO.Path]::ChangeExtension($dll.FullName, ".lib")

    if (Test-Path $checkedInLibPath) {
        [void]$libDirs.Add($dll.DirectoryName)
        $libNames.Add([System.IO.Path]::GetFileName($checkedInLibPath))
        continue
    }

    Write-Host "Generating import lib for $($dll.Name)"
    $libPath = Join-Path $genLibDir ([System.IO.Path]::ChangeExtension($dll.Name, ".lib"))
    $defPath = Join-Path $genLibDir ([System.IO.Path]::ChangeExtension($dll.Name, ".def"))

    $exports = & $dumpbin /exports $dll.FullName |
        Select-String '^\s*\d+\s+[0-9A-Fa-f]+\s+[0-9A-Fa-f]+\s+(\S+)' |
        ForEach-Object { $_.Matches[0].Groups[1].Value }

    if (-not $exports) {
        Write-Warning "No exports found in $($dll.Name), skipping"
        continue
    }

    @("LIBRARY $($dll.BaseName)", "EXPORTS") + $exports | Set-Content -Path $defPath -Encoding ASCII

    & $libExe /DEF:$defPath /OUT:$libPath /MACHINE:X64 /NOLOGO | Out-Null

    Remove-Item -Force $defPath -ErrorAction SilentlyContinue

    [void]$libDirs.Add($genLibDir)
    $libNames.Add([System.IO.Path]::GetFileName($libPath))
}

$objPath = Join-Path $PSScriptRoot "Build\a.obj"
$outPath = Join-Path $PSScriptRoot "Build\SpiteEngine.exe"
$pdbPath = Join-Path $PSScriptRoot "Build\SpiteEngine.pdb"

$libPathArgs = @(
    "/LIBPATH:$msvcLib"
    "/LIBPATH:$winSdkLib\ucrt\x64"
    "/LIBPATH:$winSdkLib\um\x64"
    "/LIBPATH:$vulkanSdk\Lib"
) + ($libDirs | ForEach-Object { "/LIBPATH:$_" })

$staticLibs = @(
    "kernel32.lib"
    "msvcrt.lib"
    "libucrt.lib"
    "libvcruntime.lib"
    "oldnames.lib"
    "legacy_stdio_definitions.lib"
    "vulkan-1.lib"
    "Rpcrt4.lib"
    "User32.lib"
) + $libNames

$debugArgs = if ($Debug) { @("/DEBUG", "/PDB:$pdbPath") } else { @() }

& $linkExe /OUT:$outPath $objPath @libPathArgs @staticLibs @debugArgs

foreach ($dll in $dlls) {
    Copy-Item -Path $dll.FullName -Destination $buildDir -Force
}

robocopy (Join-Path $PSScriptRoot "Resource") (Join-Path $buildDir "Resource") /MIR /NFL /NDL /NJH /NJS /NC /NS /NP | Out-Null

Remove-Item -Recurse -Force $genLibDir -ErrorAction SilentlyContinue
