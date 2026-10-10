# waste-detection

Deteksi sampah **organik** dan **anorganik** dengan YOLO26 (Ultralytics, PyTorch).
Dataset: [waste Detection](https://universe.roboflow.com/capstone-catzw/waste-detection-yle4x) dari Roboflow Universe (CC BY 4.0).

| Kondisi | Output |
|---|---|
| Tidak ada sampah terdeteksi | Tidak ada output |
| Ada sampah organik | `organik` |
| Ada sampah anorganik | `anorganik` |

## Struktur folder

```
waste-detection/
├── .venv/                  # dibuat oleh setup.sh
├── data/                   # dataset hasil unduhan Roboflow
├── runs/                   # hasil training & evaluasi YOLO
├── models/                 # bobot model (pretrained + terbaik)
├── waste_detection.ipynb
├── requirements.txt
├── setup.sh
├── .env.example
├── .gitignore
└── README.md
```

`data/`, `runs/`, `models/`, `.venv/`, dan `.env` tidak ikut ke git.

## 1. Pasang environment (Linux / macOS)

```bash
cd waste-detection
bash setup.sh
```

`setup.sh` akan:
1. Membuat `.venv`
2. Memasang PyTorch **CUDA** kalau ada GPU NVIDIA (`nvidia-smi` jalan), atau **CPU** kalau tidak
3. Memasang semua library di `requirements.txt`
4. Mendaftarkan kernel Jupyter **Python (waste-detection)**

Butuh Python 3.10 sampai 3.14. Kalau `python3` di sistemmu versi lain:

```bash
PYTHON=python3.12 bash setup.sh
```

### Mengaktifkan environment

```bash
source .venv/bin/activate     # aktifkan
deactivate                    # keluar
```

### Pasang manual (tanpa setup.sh, mis. di Windows)

```bash
python -m venv .venv
.venv\Scripts\activate                     # Windows
# GPU NVIDIA:
pip install torch==2.14.1 torchvision==0.29.1 --index-url https://download.pytorch.org/whl/cu130
# Tanpa GPU:
pip install torch==2.14.1 torchvision==0.29.1 --index-url https://download.pytorch.org/whl/cpu
pip install -r requirements.txt
pip uninstall -y opencv-python-headless
pip install --force-reinstall --no-deps opencv-python==5.0.0.93
python -m ipykernel install --user --name waste-detection --display-name "Python (waste-detection)"
```

## 2. Pilih kernel

**VS Code**
1. Buka folder `waste-detection`
2. Buka `waste_detection.ipynb`
3. Klik **Select Kernel** (kanan atas) → **Jupyter Kernel** → **Python (waste-detection)**

   Atau: **Python Environments** → pilih `.venv/bin/python`

**Jupyter Lab / Notebook**

```bash
source .venv/bin/activate
jupyter lab
```

Lalu menu **Kernel → Change Kernel → Python (waste-detection)**.

## 3. Isi Roboflow API key

Ambil key di [app.roboflow.com](https://app.roboflow.com) → **Settings → API Keys** → salin **Private API Key**.

Pilih salah satu:

**Lokal: file `.env`** (disarankan)

```bash
cp .env.example .env
# edit .env:
# ROBOFLOW_API_KEY=key_kamu
```

**Lokal: environment variable**

```bash
export ROBOFLOW_API_KEY=key_kamu
```

Kalau tidak ada satu pun, notebook akan meminta key saat dijalankan.

## 4. Webcam (lokal saja)

Di sel terakhir bagian inference, ubah `RUN_WEBCAM = True`, jalankan, tekan **Q** untuk berhenti.
