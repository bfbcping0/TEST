# set-executionpolicy remotesigned

param (
    [string]$file1,
    [string]$file2 = $null
)

if (-not (Test-Path -Path $file1)) {
    Write-Host "File '$file1' does not exist."
    exit
}

if ($file2 -ne $null) {
    if (-not (Test-Path -Path $file2)) {
        Write-Host "File '$file2' does not exist."
        exit
    }

    # Get the timestamps of the second file
    $file2CreationTime = (Get-Item $file2).CreationTime
    $file2LastWriteTime = (Get-Item $file2).LastWriteTime
    $file2LastAccessTime = (Get-Item $file2).LastAccessTime

    # Set the timestamps of the first file to match the second file
    (Get-Item $file1).CreationTime = $file2CreationTime
    (Get-Item $file1).LastWriteTime = $file2LastWriteTime
    (Get-Item $file1).LastAccessTime = $file2LastAccessTime

    Write-Host "Timestamps of '$file1' have been updated to match '$file2'."
} else {
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
