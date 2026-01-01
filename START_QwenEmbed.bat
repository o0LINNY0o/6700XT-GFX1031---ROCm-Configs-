@echo off
echo Starting Embedding Model Server...
echo.

cd /d C:\llamaROCM

llama-server.exe ^
  --model "C:\llamaROCM\models-embeddings\Qwen3-Embedding-0.6B-q6_k_m.gguf" ^
  --embedding ^
  --pooling last ^
  --host 127.0.0.1 ^
  --port 8181 ^
  --threads -1 ^
  --gpu-layers -1 ^
  --ctx-size 4096 ^
  --batch-size 1024 ^
  --sleep-idle-seconds 30 ^
  --no-models-autoload ^
  --verbose

echo.
echo Server stopped.
pause