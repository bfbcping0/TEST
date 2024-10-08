# set-executionpolicy remotesigned

param (
    [string]$file1,
    [string]$file2
)

if (-not (Test-Path -Path $file1)) {
    Write-Host "File '$file1' does not exist."
    exit
}
if (-not (Test-Path -Path $file2)) {
    Write-Host "File '$file2' does not exist."
    exit
}

# Get the last write time of the second file
$file2Time = (Get-Item $file2).LastWriteTime

# Set the last write time of the first file to match the second file
(Get-Item $file1).LastWriteTime = $file2Time

Write-Host "Date modified of '$file1' has been updated to match '$file2'."
