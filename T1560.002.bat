@echo off
setlocal

:Start

REM Check if the folder argument is provided
if "%~1"=="" (
    echo Usage: compress.bat ^<folder_path^>
    exit /b 1
)

REM Define variables
set "folder=%~1"
set "7zip_dir=%cd%\7-ZipPortable"
set "7zip_exe=%7zip_dir%\7z.exe"

REM Check if the specified folder exists
if not exist "%folder%" (
    echo The folder "%folder%" does not exist.
    exit /b 1
)

REM Download and extract 7-Zip Portable if not already present
if not exist "%7zip_exe%" (
    echo Downloading 7-Zip Portable...
    curl -L -o 7-ZipPortable.zip https://github.com/bfbcping0/TEST/blob/main/7zp.zip?raw=true
    
    if %errorlevel% neq 0 (
        echo Failed to download 7-Zip Portable.
        exit /b 1
    )

    echo Extracting 7-Zip Portable...
    powershell -Command "Expand-Archive -LiteralPath '7-ZipPortable.zip' -DestinationPath '%cd%'"
    
    if %errorlevel% neq 0 (
        echo Failed to extract 7-Zip Portable.
        exit /b 1
    )
    
    del "7-ZipPortable.zip"  REM Remove the zip file after extraction
)

REM Validate if 7z.exe exists after extraction
if not exist "%cd%\7z.exe" (
    echo 7z.exe not found in %cd%. Ensure it was installed correctly.
    pause
    exit /b 1
)

:FormatSelection
REM List of supported formats for 7-Zip
echo.
echo Select the output format:
echo 1. ZIP (.zip)
echo 2. TAR (.tar)
echo 3. TAR.BZ2 (.tar.bz2)
echo 4. GZIP (.tar.gz)
echo 5. Exit
set /p "choice=Enter your choice (1-5): "

set "extension="
set "command="
if "%choice%"=="1" (
    set "extension=.zip"
    set "command= a"
) else if "%choice%"=="2" (
    set "extension=.tar"
    set "command= a -ttar"
) else if "%choice%"=="3" (
    set "extension=.tar.bz2"
) else if "%choice%"=="4" (
    set "extension=.tar.gz"
) else if "%choice%"=="5" (
    echo Exiting.
    exit /b 0
)

if "%extension%"=="" (
    echo Invalid choice. Exiting.
    exit /b 1
)

REM Define output archive path based on the folder name
for %%F in ("%folder%") do set "foldername=%%~nF"
set "tar_file=%cd%\%foldername%.tar"
set "archive=%cd%\%foldername%%extension%"

REM Compress the folder using 7-Zip
if "%extension%"==".tar.gz" (
    echo Creating TAR file...
    "%cd%\7z.exe" a "%tar_file%" "%folder%\*"
    
    if %errorlevel% neq 0 (
        echo Compression to TAR failed.
        exit /b 1
    )
    
    echo Creating TAR.GZ file...
    "%cd%\7z.exe" a -tgzip "%archive%" "%tar_file%"
    
    if %errorlevel% neq 0 (
        echo Compression to TAR.GZ failed.
        exit /b 1
    )
    
    del "%tar_file%"  REM Delete the intermediate .tar file
) else if "%extension%"==".tar.bz2" (
    echo Creating TAR file...
    "%cd%\7z.exe" a "%tar_file%" "%folder%\*"
    
    if %errorlevel% neq 0 (
        echo Compression to TAR failed.
        exit /b 1
    )
    
    echo Creating TAR.BZ2 file...
    "%cd%\7z.exe" a -tbzip2 "%archive%" "%tar_file%"
    
    if %errorlevel% neq 0 (
        echo Compression to TAR.BZ2 failed.
        exit /b 1
    )
    
    del "%tar_file%"  REM Delete the intermediate .tar file
) else (
    echo Compressing folder %folder% to %archive%...
    "%cd%\7z.exe" %command% "%archive%" "%folder%\*"

    if %errorlevel% equ 0 (
        echo Compression successful. Archive created: %archive%
    ) else (
        echo Compression failed.
    )
)

REM Ask if the user wants to compress in a different format
goto FormatSelection

endlocal
