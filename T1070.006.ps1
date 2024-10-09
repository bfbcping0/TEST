# set-executionpolicy remotesigned

param (
    [string]$file1
)

if (-not (Test-Path -Path $file1)) {
    Write-Host "File '$file1' does not exist."
    exit
}

# Prompt the user to select the action
$actionChoice = Read-Host "What do you want to do? Enter 'C' for Clone timestamps, 'M' for Modify timestamps manually"

if ($actionChoice.ToUpper() -eq 'C') {
    # Prompt the user for the source file to clone timestamps from
    $sourceFile = Read-Host "Enter the path to the source file"

    if (-not (Test-Path -Path $sourceFile)) {
        Write-Host "Source file '$sourceFile' does not exist."
        exit
    }

    # Get the timestamps of the source file
    $sourceCreationTime = (Get-Item $sourceFile).CreationTime
    $sourceLastWriteTime = (Get-Item $sourceFile).LastWriteTime
    $sourceLastAccessTime = (Get-Item $sourceFile).LastAccessTime

    # Set the timestamps of the target file to match the source file
    (Get-Item $file1).CreationTime = $sourceCreationTime
    (Get-Item $file1).LastWriteTime = $sourceLastWriteTime
    (Get-Item $file1).LastAccessTime = $sourceLastAccessTime

    Write-Host "Timestamps of '$file1' have been updated to match '$sourceFile'."
}
elseif ($actionChoice.ToUpper() -eq 'M') {
    # Prompt the user to select which timestamp to change
    $timestampChoice = Read-Host "Which timestamp do you want to change? Enter 'C' for Creation, 'M' for Modification, 'A' for Last Access"

    # Prompt the user for the new date and time
    $newDate = Read-Host "Enter the new date (e.g., 2024-10-09)"
    $newTime = Read-Host "Enter the new time (e.g., 14:30)"

    # Combine the date and time
    $newDateTime = Get-Date "$newDate $newTime"

    switch ($timestampChoice.ToUpper()) {
        'C' {
            (Get-Item $file1).CreationTime = $newDateTime
            Write-Host "Creation date of '$file1' has been updated to $newDateTime."
        }
        'M' {
            (Get-Item $file1).LastWriteTime = $newDateTime
            Write-Host "Modification date of '$file1' has been updated to $newDateTime."
        }
        'A' {
            (Get-Item $file1).LastAccessTime = $newDateTime
            Write-Host "Last access date of '$file1' has been updated to $newDateTime."
        }
        Default {
            Write-Host "Invalid choice. Please enter 'C', 'M', or 'A'."
        }
    }
}
else {
    Write-Host "Invalid choice. Please enter 'C' or 'M'."
}
