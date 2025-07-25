

# W\.AI GPU Completely brainless installation Script

Automates the installation and configuration of W.AI GPU workers on NVIDIA-powered systems.

- Installs all required dependencies.
- Checks for the installed CUDA version and reinstalls it if it's not **12.4**.
- Detects the number of available GPUs.
- Calculates available VRAM and starts worker instances at a rate of **1.8 GB per instance**.
- Optionally, restarts all workers every **30 minutes**.

---

## 📋 Requirements

* **OS:** Ubuntu or any Debian-based distribution
* **GPU:** One or more **NVIDIA** GPUs
* **Access:** `root` or a user with `sudo` privileges

---

## 🛠️ How to Use

### 1. Download the script

```bash
wget https://raw.githubusercontent.com/Canalizator/w-installer/refs/heads/main/winstall.sh -O wai-gpu-manager.sh
```

### 2. Make it executable

```bash
chmod +x wai-gpu-manager.sh
```

### 3. Run the script

```bash
./wai-gpu-manager.sh
```

**or one-liner:**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Canalizator/w-installer/main/winstall.sh)
```

Once started, the main menu will appear.



