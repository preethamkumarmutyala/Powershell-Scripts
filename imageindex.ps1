# Prompt the user for the ISO path
$isoPath = Read-Host "Please enter the full path to the ISO file"

# Check if the file exists
if (-Not (Test-Path -Path $isoPath)) {
    Write-Host "The file at path $isoPath does not exist. Please check the path and try again." -ForegroundColor Red
    exit
}

try {
    # Mount the ISO file
    $mountResult = Mount-DiskImage -ImagePath $isoPath -PassThru -ErrorAction Stop

    # Get the drive letter of the mounted ISO
    $driveLetter = ($mountResult | Get-Volume).DriveLetter + ":"

    # Path to the install.wim file in the mounted ISO
    $wimPath = "$driveLetter\sources\install.wim"

    # Get the list of images in the WIM file
    $images = Get-WindowsImage -ImagePath $wimPath

    # Display the images
    $images | Format-Table -Property ImageIndex, ImageName, ImageDescription

} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
} finally {
    # Dismount the ISO
    Dismount-DiskImage -ImagePath $isoPath
    Write-Host "ISO file has been dismounted." -ForegroundColor Green
}
