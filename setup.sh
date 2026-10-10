#!/usr/bin/env bash
# Membuat .venv, memasang library sesuai hardware, dan mendaftarkan kernel Jupyter.
# Pakai:  bash setup.sh
# Pilih Python tertentu:  PYTHON=python3.12 bash setup.sh
set -euo pipefail
cd "$(dirname "$0")"

PYTHON="${PYTHON:-python3}"
KERNEL_NAME="waste-detection"
KERNEL_DISPLAY="Python (waste-detection)"

# --- 1. Cek versi Python (PyTorch 2.14 butuh 3.10 - 3.14) ---
"$PYTHON" - <<'EOF'
import sys
v = sys.version_info
if not ((3, 10) <= (v.major, v.minor) <= (3, 14)):
    sys.exit(f"Python {v.major}.{v.minor} tidak didukung. Pakai 3.10 - 3.14, mis. PYTHON=python3.12 bash setup.sh")
print(f"Python {v.major}.{v.minor}.{v.micro} OK")
EOF

# --- 2. Virtual environment ---
if [ ! -d .venv ]; then
    "$PYTHON" -m venv .venv
    echo "Virtual environment dibuat: .venv"
fi
# shellcheck disable=SC1091
source .venv/bin/activate
python -m pip install --upgrade pip

# --- 3. PyTorch sesuai hardware ---
TORCH_PIN=$(grep -E '^torch==' requirements.txt)
VISION_PIN=$(grep -E '^torchvision==' requirements.txt)

if command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi >/dev/null 2>&1; then
    echo "GPU NVIDIA terdeteksi -> memasang PyTorch versi CUDA"
    pip install "$TORCH_PIN" "$VISION_PIN"
else
    echo "GPU NVIDIA tidak terdeteksi -> memasang PyTorch versi CPU"
    pip install "$TORCH_PIN" "$VISION_PIN" --index-url https://download.pytorch.org/whl/cpu
fi

# --- 4. Library lain ---
pip install -r requirements.txt

# roboflow ikut memasang opencv-python-headless, yang membuat cv2.imshow (webcam) tidak jalan.
# Hapus versi headless lalu pasang ulang opencv-python biasa.
OPENCV_PIN=$(grep -E '^opencv-python==' requirements.txt)
pip uninstall -y opencv-python-headless >/dev/null 2>&1 || true
pip install --force-reinstall --no-deps "$OPENCV_PIN"

# --- 5. Daftarkan kernel Jupyter ---
python -m ipykernel install --user --name "$KERNEL_NAME" --display-name "$KERNEL_DISPLAY"

# --- 6. Cek akhir ---
python - <<'EOF'
import cv2, torch, ultralytics, roboflow, matplotlib
print("torch      :", torch.__version__)
print("CUDA       :", torch.cuda.is_available(), "-", torch.cuda.get_device_name(0) if torch.cuda.is_available() else "CPU saja")
print("ultralytics:", ultralytics.__version__)
print("roboflow   :", roboflow.__version__)
print("opencv     :", cv2.__version__, "| GUI:", "ya" if "GTK" in cv2.getBuildInformation() or "QT" in cv2.getBuildInformation() else "tidak")
EOF

echo
echo "Selesai. Pilih kernel \"$KERNEL_DISPLAY\" saat membuka waste_detection.ipynb"
