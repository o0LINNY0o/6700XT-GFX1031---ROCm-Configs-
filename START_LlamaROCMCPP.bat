@echo off
setlocal

:: Define the root working directory
set "WORK_DIR=C:\llamaROCM"

echo.
echo === VERIFYING FILES ===

:: 1. Check for llama-swap
if not exist "%WORK_DIR%\llama-swap.exe" (
    echo ERROR: llama-swap.exe NOT FOUND in %WORK_DIR%
    pause
    exit /b 1
)

:: 2. Check for Embedding Batch file
if not exist "%WORK_DIR%\START_QwenEmbed.bat" (
    echo ERROR: START_QwenEmbed.bat NOT FOUND in %WORK_DIR%
    pause
    exit /b 1
)

:: 3. Check for Docling
if not exist "%WORK_DIR%\Docling\docling.bat" (
    echo ERROR: docling.bat NOT FOUND in %WORK_DIR%\Docling
    pause
    exit /b 1
)

:: 4. Check for Whisper
if not exist "%WORK_DIR%\whisper.cpp\Whisper_Vulkan.bat" (
    echo ERROR: Whisper_Vulkan.bat NOT FOUND in %WORK_DIR%\whisper.cpp
    pause
    exit /b 1
)

:: 5. Check for Fast-Kokoro
if not exist "%WORK_DIR%\Fast-Kokoro\Fast-Kokoro-ONNX.py" (
    echo ERROR: Fast-Kokoro-ONNX.py NOT FOUND in %WORK_DIR%\Fast-Kokoro
    pause
    exit /b 1
)

echo.
echo === LAUNCHING SERVICES ===
echo Root: %WORK_DIR%

:: --- 1. LLM ---
echo Launching Local LLM...
start "Local LLM Models" cmd /k "cd /d %WORK_DIR% && llama-swap.exe"
timeout /t 1 >nul

:: --- 2. EMBEDDING ---
echo Launching Embedding...
start "Embedding" cmd /k "cd /d %WORK_DIR% && START_QwenEmbed.bat"
timeout /t 1 >nul

:: --- 3. DOCLING ---
echo Launching Docling...
start "Docling Service" cmd /k "cd /d %WORK_DIR%\Docling && docling.bat"
timeout /t 1 >nul

:: --- 4. WHISPER ---
echo Launching Whisper...
start "Whisper STT" cmd /k "cd /d %WORK_DIR%\whisper.cpp && Whisper_Vulkan.bat"
timeout /t 1 >nul

:: --- 5. KOKORO TTS ---
echo Launching Fast-Kokoro...
:: Note: Assumes python is in your system PATH. 
:: If you use a specific venv, change "python" to "your_venv\Scripts\python.exe"
start "Kokoro TTS" cmd /k "cd /d %WORK_DIR%\Fast-Kokoro && python Fast-Kokoro-ONNX.py"

echo.
echo Launcher complete. All services started.
echo This window will now close.
timeout /t 2
exit