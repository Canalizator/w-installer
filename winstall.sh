#!/bin/bash
# Exit on errors, including in pipes
set -eo pipefail 

# --- Globals and Colors ---
GREEN_BOLD="\e[1;32m"
BLUE="\e[0;34m"
REVERSE="\e[7m"
RESET="\e[0m"

# --- Function Definitions ---

# Renders the interactive menu
show_menu() {
    local -a menu_items=("Install Worker" "Stats" "Stop Worker" "Uninstall Worker" "Exit")
    local selected_index=0
    tput civis; trap "tput cnorm; exit" SIGINT
    while true; do
        clear; echo -e "${GREEN_BOLD}"
cat <<'EOF'
                                                                                                   
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@    @@@@@@@    @@@@@@@@@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@          @@@@@@@@@@ @   @@@@@@@@@@@@@@@@@@@  @@   @@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@@@@            @@@@@   @@@@@@@@@@@ @@@   @@@@@@@@@@@@@@@@@  @@  @ @@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@      @@@@@@   @@@@@  @@@@@          @@@  @@@@@@@@@@@@@@@  @@@@ @           @@@@@@@ 
 @@@@@@@@@@@@@@  @@@@@@@@@@@  @@@@@  @@@@      @@  @@@@@ @@@@@@@@@@@@@@@  @@@@@     @@@@@@@ @@@@@@ 
 @@@@@@@@@@@@@@  @@@@  @@@@@  @@@@@ @@@@@  @@@@@@   @@ @ @@@@@@@@        @@@@@@@@@@@@@@   @@@@@@@@ 
 @@@@@@@@@@@@@@  @@@@   @@@@  @@@@@ @@@@@  @@@@@@ @ @@   @@@@@@    @@@@@@@@@@@@@@@@@@   @@@ @@@@@@ 
 @@@@@@@@@@@@@@  @@@@ @@@@    @@@@@ @@@@@    @@@@ @ @@@  @@@@@@ @@@@@@@@@@@@@@@@@@@@   @@  @@@@@@@ 
 @@@@@@@@@@@@@@  @@@@@@@@@@@  @@@@@  @@@@@ @@@@@@   @@@@ @@@@@@    @@@@@@@@@@@@@@@   @@  @@@@@@@@@ 
 @@@@@@@@@@@@@@  @@@@   @@@@@ @@@@@  @@@@@@@@@@@   @@@    @@@@@@@@    @@@@@@@@@@@@  @@  @@@@@@@@@@ 
 @@@@@@@@@@@@@@  @@@@   @@@@@ @@@@@    @@@@@@         @@    @@@@@@@@@ @@@@@@@@@@@@@ @  @@@@@@@@@@@ 
 @@@@@@@@@@@@@@  @@@@ @@@@@@  @@@@  @@@         @@ @@@@@ @@   @@@@@@  @@@@@@@@@@@@@  @ @@@@@@@@@@@ 
 @@@@@@@@@@@@@@  @@@@@@@@@                 @@@@@   @@@@@ @ @@  @@@@@ @@@@@    @@@@@@ @  @@@@@@@@@@ 
 @@@@@@@@@@@@@@  @@@@@              @@@@  @@@@@@@  @@@@@ @ @@@  @@@  @@@    @     @@@@@ @@@@@@@@@@ 
 @@@@@@@@@@@@@@            @ @@@@@  @@@@  @@@@@@@@ @@@@@ @ @@ @ @@  @@   @@ @@@@    @@@@@@@@@@@@@@ 
 @@@@@@@@@@@@       @ @@@@   @@@@@  @@@@  @@@@@@@@ @@@@@ @ @@   @@@    @@  @@@@@@@@    @@@@@@@@@@@ 
 @@@@@@@@@@@@  @@@@   @@@@   @@@@   @@@@  @@@@@@@@@@@@@@ @ @@   @@@       @@@@@@ @@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@  @@@@   @@@@@  @@@@   @@@@  @@@@  @@@@@@@@ @ @@   @    @@@@@@      @@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@  @@@@@ @@@@@@ @@@@    @@@@  @@@@@  @@@@@@@ @ @@@  @@@@@@@@@          @@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@  @@@@@ @@@@@@@@@@@    @@@@  @@@@@   @@@@@@ @ @@@  @@@@@     @@@@@@@    @@@@@@@@@@@@@ 
 @@@@@@@@@@@@@  @@@@@@@@ @@@@@@@ @  @@@@  @@@@@    @@@    @@@      @@@@  @@@@@@@@@ @   @@@@@@@@@@@ 
 @@@@@@@@@@@@@  @@@@@@@  @@@@@@@ @  @@@@  @@@@  @@@      @  @@@ @@@@@@@  @@@   @@@ @@@  @@@@@@@@@@ 
 @@@@@@@@@@@@@@  @@@@@@   @@@@@   @ @@@              @@@@  @@@@ @@@      @@@  @@@    @@  @@@@@@@@@ 
 @@@@@@@@@@@@@@  @@@@@@   @@@@    @@       @  @@@@@@ @@@   @@@@ @@@@ @@  @@@@@@@     @@@ @@@@@@@@@ 
 @@@@@@@@@@@@@@   @@@@           @@@  @@@@@ @@@@@@@  @@@   @@@@ @@@@@@@  @@@ @@@   @@@@@ @@@@@@@@@ 
 @@@@@@@@@@@@@@@         @@@   @  @ @@@@@@@ @  @@    @@@@@@@@@@ @@@      @@@ @@@@@  @ @ @@@@@@@@@@ 
 @@@@@@@@@@@@          @@@ @@@@@@@  @@@       @@@@ @ @@@@@ @@@@ @@@  @@  @@@  @@     @  @@@@@@@@@@ 
 @@@@@@           @@@@@   @@@  @@@  @@@@@@@ @ @@@@ @ @@@   @@@@ @@@@@@@              @@  @@@@@@@@@ 
 @@@@     @@@@@ @@@@@@@@  @@@       @@@@@@@   @@@@ @ @@@   @@@@ @@            @@@@@@@@@@ @@@@@@@@@ 
 @@@@  @@@@@@@  @@   @@@  @@@ @@@@@ @@@     @ @@@@ @ @@@               @@@@@@@@@@        @@@@@@@@@ 
 @@@@  @ @@@   @@@   @@@  @@@ @ @@@ @@@@@@@   @@@@         @@  @ @@@@@@@@@@@           @@@@@@@@@@@ 
 @@@@    @@@   @@@ @ @@@  @@@  @@@@ @@@@@@@ @       @@@@@@@@@@@@@@@          @@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@  @@@   @@@   @@@  @@@@@@@             @@@@@@@@@  @@@@           @@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@  @@@   @@@@@@@@      @      @@  @@@@@@@@@ @@@@        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@  @@@     @@@@     @@       @@@@@@@@@@          @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@  @@@   @@        @@@@ @@@@@@@@           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@       @@@ @@@@@@@@@            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@   @@@@@@@    @@     @@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@   @@@@  @       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 discord: dedbezmen     
                                                                                             
EOF
        echo -e "${RESET}"; echo "Use ▲/▼ to navigate, Enter to select"; echo "------------------------------------"
        for i in "${!menu_items[@]}"; do
            if [ "$i" -eq "$selected_index" ]; then echo -e "${GREEN_BOLD}${REVERSE}➤ ${menu_items[$i]}${RESET}"; else echo "  ${menu_items[$i]}"; fi
        done; echo "------------------------------------"
        read -rsn1 key; if [[ $key == $'\e' ]]; then read -rsn2 -t 0.1 key; fi
        case "$key" in
            '[A') selected_index=$(( (selected_index - 1 + ${#menu_items[@]}) % ${#menu_items[@]} ));;
            '[B') selected_index=$(( (selected_index + 1) % ${#menu_items[@]} ));;
            '') tput cnorm; case $selected_index in 0) main_install;; 1) show_stats;; 2) stop_worker;; 3) uninstall_worker;; 4) echo "Exiting."; exit 0;; esac; read -rp "Press Enter to return to the menu...";;
        esac
    done
}

show_stats() {
    tput civis # Hide cursor
    trap "tput cnorm" EXIT # Restore cursor on exit
    
    while true; do
        clear
        echo -e "${GREEN_BOLD}Worker Statistics (Live)${RESET}"
        
        export NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &>/dev/null
        if ! command -v pm2 &> /dev/null; then echo "PM2 not found."; sleep 5; continue; fi
        
        local pm2_data=$(pm2 jlist 2>/dev/null || echo "[]")
        local app_names=($(echo "$pm2_data" | jq -r '.[] | select((.name | startswith("wai-gpu-")) and .pm2_env.status == "online") | .name'))

        if [ ${#app_names[@]} -eq 0 ]; then echo -e "\nNo running 'wai-gpu-*' workers found."; fi

        printf "%-20s ${BLUE}|${RESET} %-15s ${BLUE}|${RESET} %s\n" "Instance" "Current Coins" "Coins/Hour"
        echo -e "${BLUE}---------------------|-----------------|-------------${RESET}"

        for app_name in "${app_names[@]}"; do
            local latest_log_line=$(pm2 logs "$app_name" --lines 100 --nostream 2>/dev/null | grep "You now have" | tail -1)
            local coin_count=0
            if [ -n "$latest_log_line" ]; then coin_count=$(echo "$latest_log_line" | awk '{print $(NF-2)}'); fi

            local uptime_ms=$(echo "$pm2_data" | jq ".[] | select(.name == \"$app_name\") | .pm2_env.uptime")
            local coins_per_hour="0.00"

            if [ "$uptime_ms" -gt 0 ] && [ "$coin_count" -gt 0 ]; then
                local uptime_hours=$(bc -l <<< "$uptime_ms / 1000 / 3600")
                if (( $(echo "$uptime_hours > 0" |bc -l) )); then
                     coins_per_hour=$(bc -l <<< "scale=2; $coin_count / $uptime_hours")
                fi
            fi
            printf "%-20s ${BLUE}|${RESET} ${GREEN_BOLD}%-15s${RESET} ${BLUE}|${RESET} ${GREEN_BOLD}%s${RESET}\n" "$app_name" "$coin_count" "$coins_per_hour"
        done
        
        echo -e "\n${BLUE}Updating in 10s... (Press any key to exit)${RESET}"
        
        for ((i=0; i<100; i++)); do
            read -t 0.1 -n 1 && break 2 
        done
    done
    
    tput cnorm 
    trap - EXIT
}

main_install() {
  clear
  read -rp "$(echo -e ${GREEN_BOLD}Enter the API key from app.w.ai/keys:${RESET} )" W_AI_API_KEY
  if [ -z "$W_AI_API_KEY" ]; then echo "Error: API key cannot be empty."; return; fi
  local api_key="$W_AI_API_KEY"; declare -a APP_NAMES_TO_START

  echo -e "${GREEN_BOLD}Starting installation...${RESET}"
  echo -e "${GREEN_BOLD}Updating packages and installing dependencies...${RESET}"; apt-get update && apt-get install -y build-essential nano screen curl git wget lz4 jq make gcc automake autoconf tmux htop nvme-cli pkg-config libssl-dev tar clang bsdmainutils ncdu unzip python3-pip python3-venv bc
  echo -e "${GREEN_BOLD}Checking for CUDA...${RESET}"; if command -v nvcc &> /dev/null; then echo "CUDA is already installed."; else
    echo "Downloading and installing CUDA 12.4..."; wget -q https://developer.download.nvidia.com/compute/cuda/12.4.0/local_installers/cuda_12.4.0_550.54.14_linux.run -O cuda.run
    sh cuda.run --silent --toolkit --override; export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}; echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}' >> ~/.bashrc; rm cuda.run; echo "CUDA installed.";
  fi
  
  echo -e "${GREEN_BOLD}Installing w.ai...${RESET}";
  curl -fsSL https://app.w.ai/install.sh | bash; export PATH=$HOME/.wai/bin:$PATH
  if ! command -v wai &> /dev/null; then
      echo -e "${GREEN_BOLD}Official script failed. Trying fallback...${RESET}"; curl -Lo ~/wai https://releases.w.ai/production/cli/wrapper/linux/wai
      chmod +x ~/wai; mv ~/wai /usr/bin/wai; if ! command -v wai &> /dev/null; then echo "Error: Fallback failed."; return 1; fi; echo "Fallback successful."
  else echo "w.ai installed successfully."; fi

  if ! command -v node &> /dev/null; then
    echo "Node.js not found. Installing via NVM..."; curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash;
  fi;
  export NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; nvm install 22 &>/dev/null; nvm use 22 &>/dev/null; nvm alias default 22 &>/dev/null;
  echo -e "${GREEN_BOLD}Installing PM2 and Yarn globally...${RESET}"; npm install -g pm2 yarn
  
  if ! grep -q "This loads nvm" ~/.bashrc; then
      echo "Adding NVM to ~/.bashrc for persistent access..."; echo -e '\n# NVM Loader\nexport NVM_DIR="$HOME/.nvm"\n[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.bashrc
  fi

  local attempt_num=1; while true; do
    echo "Attempting to initialize 'wai' (Attempt #${attempt_num})..."; echo "Displaying logs below. Waiting for the 'Starting w.ai worker...' message (30-minute timeout)..."
    W_AI_API_KEY=$api_key wai run 2>&1 | tee wai_init.log & WAI_PID=$!
    if timeout 30m grep -q "Starting w.ai worker..." <(tail -f wai_init.log); then 
        echo -e "${GREEN_BOLD}Worker initialized successfully.${RESET}"; kill $WAI_PID; sleep 2; rm wai_init.log; break; 
    else
        echo "Timed out waiting for worker. Retrying..."; kill $WAI_PID &> /dev/null || true; rm -f wai_init.log; attempt_num=$((attempt_num + 1)); sleep 3;
    fi
  done
  
  create_pm2_config() {
    if ! command -v nvidia-smi &> /dev/null; then echo "nvidia-smi not found."; exit 1; fi
    mapfile -t vrams_mb < <(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits);
    if [ ${#vrams_mb[@]} -eq 0 ]; then echo "No NVIDIA GPUs found."; exit 1; fi
    
    local instance_counts=() total_apps=0
    echo "Calculating instance counts for ${#vrams_mb[@]} GPUs..."
    for vram in "${vrams_mb[@]}"; do
        local instances=$(bc <<< "scale=2; vram=${vram}; vram/1024/1.8" | cut -d. -f1)
        if [ "$instances" -lt 1 ]; then instances=1; fi
        instance_counts+=($instances)
        total_apps=$((total_apps + instances))
    done

    echo "Found $total_apps total instances to create. Generating wai.config.js..."
    cat > wai.config.js <<EOF
module.exports = { apps: [
EOF
    local app_count=0; for i in "${!instance_counts[@]}"; do
      for ((j=0; j<${instance_counts[$i]}; j++)); do
        local app_name="wai-gpu-${i}-${j}"; APP_NAMES_TO_START+=("$app_name"); app_count=$((app_count + 1))
        local comma=""; if [ "$app_count" -lt "$total_apps" ]; then comma=","; fi
        cat >> wai.config.js <<EOF
    { "name": "$app_name", "script": "wai", "args": "run -g $i", "instances": 1, "autorestart": true, "watch": false, "max_memory_restart": "1G", "env": { "NODE_ENV": "production", "W_AI_API_KEY": "$1" } }$comma
EOF
      done
    done; cat >> wai.config.js <<EOF
]};
EOF
    echo -e "${GREEN_BOLD}wai.config.js created.${RESET}"; 
  }
  create_pm2_config "$api_key";
  
  echo -e "${GREEN_BOLD}Starting PM2 processes sequentially...${RESET}"; for app_name in "${APP_NAMES_TO_START[@]}"; do
    echo "Starting instance: ${app_name}..."; pm2 start wai.config.js --only "${app_name}"; echo "Waiting 15 seconds..."; sleep 15; 
  done
  
  echo -e "${GREEN_BOLD}Configuring PM2 to start on system boot...${RESET}";
  pm2 startup | tail -n 1 | sudo bash; pm2 save
  echo -e "${GREEN_BOLD}Installation is complete! Run 'source ~/.bashrc' or re-login for 'pm2' command.${RESET}"
}

stop_worker() { clear; echo -e "${GREEN_BOLD}Stopping all 'wai' worker processes...${RESET}"; if command -v pm2 &> /dev/null; then pm2 stop all; echo "All processes stopped."; else echo "PM2 not in PATH."; fi; }

uninstall_worker() {
    clear; read -p "Are you sure you want to completely uninstall the worker? (y/n) " -n 1 -r; echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${GREEN_BOLD}Starting uninstallation...${RESET}"; if command -v pm2 &> /dev/null; then
            pm2 delete all >/dev/null 2>&1 || true; pm2 unstartup >/dev/null 2>&1 || true
            pm2 kill >/dev/null 2>&1 || true; npm uninstall -g pm2 yarn >/dev/null 2>&1 || true
        fi
        rm -rf "$HOME/.wai"; rm -f /usr/bin/wai; rm -f "$(pwd)/wai.config.js" wai_init.log &>/dev/null || true
        sed -i '/# NVM Loader/,/This loads nvm/d' ~/.bashrc
        echo -e "${GREEN_BOLD}Uninstallation complete.${RESET}";
    else echo "Uninstallation cancelled."; fi
}

# --- Script Entry Point ---
show_menu
