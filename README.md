

# W\.AI GPU Completely brainless installation Script

Automates the installation and configuration of W\.AI GPU workers on NVIDIA-powered systems.
It will install all dependencies, check CUDA, and reinstall if the version is other than 12.4. 
It will calculate the number of workers based on 1.8GB VRAM per instance, and start them with 30sec delay. 
Otionally, It will  restart all workers every 30 min.

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



