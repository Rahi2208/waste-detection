# waste-detection

Detect **organic** and **inorganic** waste with YOLO26 (Ultralytics, PyTorch).
Dataset: [waste Detection](https://universe.roboflow.com/capstone-catzw/waste-detection-yle4x) from Roboflow Universe (CC BY 4.0).

this repo is inspired by Computer vision with python and tensorflow by freecodecamp.org, but we use pytorch instead

| What's in the image | Output |
|---|---|
| No waste detected | Nothing |
| Organic waste | `organik` |
| Inorganic waste | `anorganik` |

## Folder structure

```
waste-detection/
├── .venv/                  # created by setup.sh
├── data/                   # dataset downloaded from Roboflow
├── runs/                   # YOLO training & evaluation results
├── models/                 # model weights (pretrained + best)
├── waste_detection.ipynb
├── requirements.txt
├── setup.sh
├── .env.example
├── .gitignore
└── README.md
```

`data/`, `runs/`, `models/`, `.venv/`, and `.env` don't get pushed to git.

## 1. Set up the environment (Linux / macOS)

```bash
cd waste-detection
bash setup.sh
```

`setup.sh` will:
1. Create `.venv`
2. Install the **CUDA** version of PyTorch if you have an NVIDIA GPU (`nvidia-smi` works), or the **CPU** version if you don't
3. Install all the libraries in `requirements.txt`
4. Register the Jupyter kernel **Python (waste-detection)**

You need Python 3.10 to 3.14. If your `python3` is a different version:

```bash
PYTHON=python3.12 bash setup.sh
```

### Turning the environment on and off

```bash
source .venv/bin/activate     # turn on
deactivate                    # turn off
```

### Manual install (no setup.sh, e.g. on Windows)

```bash
python -m venv .venv
.venv\Scripts\activate                     # Windows
# NVIDIA GPU:
pip install torch==2.14.1 torchvision==0.29.1 --index-url https://download.pytorch.org/whl/cu130
# No GPU:
pip install torch==2.14.1 torchvision==0.29.1 --index-url https://download.pytorch.org/whl/cpu
pip install -r requirements.txt
pip uninstall -y opencv-python-headless
pip install --force-reinstall --no-deps opencv-python==5.0.0.93
python -m ipykernel install --user --name waste-detection --display-name "Python (waste-detection)"
```

## 2. Pick the kernel

**VS Code**
1. Open the `waste-detection` folder
2. Open `waste_detection.ipynb`
3. Click **Select Kernel** (top right) → **Jupyter Kernel** → **Python (waste-detection)**

   Or: **Python Environments** → pick `.venv/bin/python`

**Jupyter Lab / Notebook**

```bash
source .venv/bin/activate
jupyter lab
```

Then go to **Kernel → Change Kernel → Python (waste-detection)**.

## 3. Add your Roboflow API key

Get your key at [app.roboflow.com](https://app.roboflow.com) → **Settings → API Keys** → copy the **Private API Key**.

Pick one:

**Local: `.env` file** (recommended)

```bash
cp .env.example .env
# edit .env:
# ROBOFLOW_API_KEY=your_key
```

**Local: environment variable**

```bash
export ROBOFLOW_API_KEY=your_key
```

If you skip both, the notebook will ask for the key when you run it.

## 4. Webcam (local only)

In the last cell of the inference section, set `RUN_WEBCAM = True`, run it, and press **Q** to stop.
