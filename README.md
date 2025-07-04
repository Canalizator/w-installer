

# W\.AI GPU Installer Script

Automates the installation and configuration of W\.AI GPU workers on NVIDIA-powered systems.

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

---

## 📚 Menu Options

### 1. **Install Worker**

Performs a full automated system setup:

* 🔑 **API Key Prompt:** You'll be asked for your API key from [app.w.ai/keys](https://app.w.ai/keys)
* 📦 **Dependencies:** Installs system packages such as `build-essential`, `git`, `curl`, `jq`, `bc`, etc.
* ⚙️ **CUDA 12.4 Installation:** Checks for existing CUDA installation. If missing, downloads the official installer, performs a silent install, and appends to `.bashrc`
* 🧠 **W\.AI CLI Setup:** Downloads and installs the official `w.ai` CLI (with fallback if needed)
* 🟢 **Node.js Environment:**

  * Installs `nvm`, then Node.js v22
  * Installs `yarn` and `pm2` globally
* 🚀 **Worker Initialization:**

  * Runs `wai run` with your API key
  * Waits for the log message `Starting w.ai worker...` (up to 30 minutes)
  * Automatically terminates the init process after successful detection

**Instance Calculation & Configuration:**

* Uses `nvidia-smi` to detect each GPU and its VRAM
* Calculates the number of instances (1 per 1.8 GB of VRAM)
* Generates `wai.config.js` for use with `pm2`

**Safe Sequential Launch:**

* Starts instances one by one with a 15-second delay
* Configures `pm2` to auto-start all workers after reboot

---

### 2. **Stats**

Launches a live dashboard to monitor running workers.

---

### 3. **Stop Worker**

Stops all processes with names starting with `wai-gpu-` via `pm2`.

---

### 4. **Uninstall Worker**

Fully removes everything installed by the script.

---

### 5. **Exit**

Exits the script cleanly.

---

## 📎 License

MIT (or specify another license if needed)

---

Let me know if you also need a logo, usage GIF, or badges (e.g. shell-check, last commit, license).
