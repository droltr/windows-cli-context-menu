param (
    [Parameter(Mandatory=$true)]
    [string]$InputPath,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputPath
)

Add-Type -AssemblyName System.Drawing

function Convert-PngToIco-HighQuality {
    param($pngPath, $icoPath)
    
    try {
        $bytes = [System.IO.File]::ReadAllBytes($pngPath)
        
        # Get Dimensions using System.Drawing to be safe
        $img = [System.Drawing.Image]::FromFile($pngPath)
        $width = $img.Width
        $height = $img.Height
        $img.Dispose()

        # Constraints: Windows ICO PNGs usually max out at 256x256. 
        # If larger, we should probably resize, but for now assuming download sources are sane (128px is ideal).
        # Width/Height 0 means 256.
        
        $wByte = if ($width -ge 256) { 0 } else { $width }
        $hByte = if ($height -ge 256) { 0 } else { $height }

        $stream = New-Object System.IO.FileStream($icoPath, [System.IO.FileMode]::Create)
        $writer = New-Object System.IO.BinaryWriter($stream)

        # 1. ICONDIR (6 bytes)
        $writer.Write([int16]0) # Reserved
        $writer.Write([int16]1) # Type (1=Icon)
        $writer.Write([int16]1) # Count (1 image)

        # 2. ICONDIRENTRY (16 bytes)
        $writer.Write([byte]$wByte) # Width
        $writer.Write([byte]$hByte) # Height
        $writer.Write([byte]0)      # Colors (0=No palette)
        $writer.Write([byte]0)      # Reserved
        $writer.Write([int16]1)     # Planes
        $writer.Write([int16]32)    # BitCount (32 for PNG)
        $writer.Write([int32]$bytes.Length) # Image Size
        $writer.Write([int32](6 + 16))      # Image Offset (Header + Entry)

        # 3. Image Data
        $writer.Write($bytes)

        $writer.Close()
        $stream.Close()
        
        return $true
    }
    catch {
        Write-Error "Failed to create High-Quality ICO: $_"
        return $false
    }
}

if (Test-Path $InputPath) {
    if (Convert-PngToIco-HighQuality -pngPath $InputPath -icoPath $OutputPath) {
        Write-Output "Successfully converted $InputPath to $OutputPath (High Quality)"
    }
} else {
    Write-Error "Input file not found: $InputPath"
}