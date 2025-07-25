#!/bin/bash
# Exit on errors, including in pipes
set -eo pipefail 

# --- Globals and Colors ---
GREEN_BOLD="\e[1;32m"
BLUE="\e[0;34m"
YELLOW_BOLD="\e[1;33m"
REVERSE="\e[7m"
RESET="\e[0m"

# --- Globals for Periodic Restart ---
PID_FILE="/tmp/wai_restarter.pid"
LOG_FILE="/tmp/wai_restarter.log"

# --- Function Definitions ---

# Renders the interactive menu
show_menu() {
    local -a menu_items=("Install Worker" "Stats" "Manage Periodic Restart" "Stop Worker" "Start Worker" "Uninstall Worker" "Exit")
    local selected_index=0
    tput civis; trap "tput cnorm; exit" SIGINT
    while true; do
        clear; echo -e "${GREEN_BOLD}"
cat <<'EOF'
                                                                                                   
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
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
 @@@@@@           @@@@@   @@@  @@@  @@@@@@@ @ @@@@ @ @@@   @@@@ @@@  @@  @@@  @@     @  @@@@@@@@@@ 
 @@@@@@@@@@@@          @@@ @@@@@@@  @@@       @@@@ @ @@@@@ @@@@ @@@  @@  @@@  @@     @  @@@@@@@@@@ 
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
 descord:dedbezmen
EOF
        echo -e "${RESET}"; echo "Use ▲/▼ to navigate, Enter to select"; echo "------------------------------------"
        for i in "${!menu_items[@]}"; do
            if [ "$i" -eq "$selected_index" ]; then echo -e "${GREEN_BOLD}${REVERSE}➤ ${menu_items[$i]}${RESET}"; else echo "  ${menu_items[$i]}"; fi
        done; echo "------------------------------------"

        local status_text=""
        if [ "$selected_index" -eq 2 ]; then # Special text for "Manage Periodic Restart"
            if [ -f "$PID_FILE" ] && ps -p "$(cat "$PID_FILE")" > /dev/null; then
                status_text="(${YELLOW_BOLD}ACTIVE${RESET})"
            else
                status_text="(${BLUE}INACTIVE${RESET})"
            fi
            echo -e "Status: $status_text"
        fi
        
        echo -e "${BLUE}Helpful Commands:${RESET}"
        printf "  %-45s - %s\n" "${YELLOW_BOLD}tail -f ${LOG_FILE}${RESET}" "To track the background restarter"
        printf "  %-45s - %s\n" "${YELLOW_BOLD}source ~/.bashrc${RESET}" "To enable 'pm2' in your terminal"
        echo "------------------------------------"

        read -rsn1 key; if [[ $key == $'\e' ]]; then read -rsn2 -t 0.1 key; fi
        case "$key" in
            '[A') selected_index=$(( (selected_index - 1 + ${#menu_items[@]}) % ${#menu_items[@]} ));;
            '[B') selected_index=$(( (selected_index + 1) % ${#menu_items[@]} ));;
            '') tput cnorm; case $selected_index in 0) main_install;; 1) show_stats;; 2) manage_periodic_restart;; 3) stop_worker;; 4) start_worker;; 5) uninstall_worker;; 6) echo "Exiting."; exit 0;; esac; read -rp "Press Enter to return to the menu...";;
        esac
    done
}

# --- Core logic for the periodic restart ---
periodic_restart() {
    # Log the fact that the background process has started successfully.
    echo "Periodic Restart: Background process started successfully at $(date). PID: $$. Monitoring log: $LOG_FILE"
    
    # This function runs in the background indefinitely.
    while true; do
        echo "---"
        echo "Periodic Restart: Starting a cycle at $(date)"

        if [ -s "$NVM_DIR/nvm.sh" ]; then
             # shellcheck source=/dev/null
             \. "$NVM_DIR/nvm.sh" &>/dev/null
        else
            echo "Periodic Restart: NVM script not found at $NVM_DIR. Sleeping for 30 minutes."
            sleep 1800
            continue
        fi
        
        if ! command -v pm2 &> /dev/null || ! command -v jq &> /dev/null; then
            echo "Periodic Restart: 'pm2' or 'jq' not found in PATH. Make sure NVM is sourced. PATH is: $PATH. Sleeping for 30 minutes."
            sleep 1800 # 30 minutes
            continue
        fi

        local pm2_data
        pm2_data=$(pm2 jlist 2>/dev/null || echo "[]")
        local app_names=()
        readarray -t app_names < <(echo "$pm2_data" | jq -r '.[] | select(.name | startswith("wai-gpu-")) | .name')

        if [ ${#app_names[@]} -gt 0 ]; then
            echo "Periodic Restart: Found ${#app_names[@]} instances. Restarting sequentially."
            for app_name in "${app_names[@]}"; do
                echo "Periodic Restart: Restarting '$app_name'..."
                pm2 restart "$app_name" --no-color
                echo "Periodic Restart: Waiting 30 seconds..."
                sleep 30
            done
            echo "Periodic Restart: Cycle complete."
        else
            echo "Periodic Restart: No 'wai-gpu-*' workers found to restart."
        fi
        
        echo "Periodic Restart: Sleeping for 30 minutes until the next cycle."
        sleep 1800 # 30 minutes
    done
}

# --- Menu option to manage the periodic restart ---
manage_periodic_restart() {
    clear
    if [ -f "$PID_FILE" ] && ps -p "$(cat "$PID_FILE")" > /dev/null; then
        local pid
        pid=$(cat "$PID_FILE")
        echo -e "${YELLOW_BOLD}Periodic restart is currently ACTIVE (PID: $pid).${RESET}"
        echo "Logs can be viewed with the command: tail -f $LOG_FILE"
        echo ""
        read -p "Do you want to STOP the periodic restart? (y/n) " -n 1 -r; echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Stopping the background process..."
            kill "$pid"
            rm -f "$PID_FILE"
            echo -e "${GREEN_BOLD}Periodic restart has been disabled.${RESET}"
        else
            echo "No action taken."
        fi
    else
        rm -f "$PID_FILE" # Clean up old file just in case
        echo -e "${YELLOW_BOLD}Periodic restart is currently INACTIVE.${RESET}"
        read -p "Do you want to START it? (y/n) " -n 1 -r; echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo "Starting the periodic restart process in the background..."
            
            export NVM_DIR="$HOME/.nvm"
            # shellcheck source=/dev/null
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            
            if ! command -v jq &> /dev/null || ! command -v pm2 &> /dev/null; then
                echo "Error: 'jq' or 'pm2' is not in the PATH. Cannot start periodic restarter."
                echo "Try running 'source ~/.bashrc' and then run this script again."
                return 1
            fi
            
            touch "$LOG_FILE"
            
            nohup env PATH="$PATH" NVM_DIR="$NVM_DIR" bash -c "$(declare -f periodic_restart); periodic_restart" >> "$LOG_FILE" 2>&1 &
            echo $! > "$PID_FILE"
            
            echo -e "${GREEN_BOLD}Periodic restart is now ACTIVE (PID: $(cat "$PID_FILE")).${RESET}"
            echo "To monitor, use the command: tail -f $LOG_FILE"
        else
            echo "No action taken."
        fi
    fi
}

show_stats() {
    tput civis; trap "tput cnorm" EXIT
    while true; do
        clear
        echo -e "${GREEN_BOLD}Worker Statistics (Live)${RESET}"
        
        export NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &>/dev/null
        if ! command -v pm2 &> /dev/null; then echo "PM2 not found. Have you run 'source ~/.bashrc'?"; sleep 5; continue; fi
        
        local pm2_data; pm2_data=$(pm2 jlist 2>/dev/null || echo "[]")
        local app_names; app_names=($(echo "$pm2_data" | jq -r '.[] | select((.name | startswith("wai-gpu-")) and .pm2_env.status == "online") | .name'))

        if [ ${#app_names[@]} -eq 0 ]; then echo -e "\nNo running 'wai-gpu-*' workers found."; fi

        printf "%-27s ${BLUE}|${RESET} %-15s\n" "Instance" "Current Coins"
        echo -e "${BLUE}----------------------------|-----------------${RESET}"

        for app_name in "${app_names[@]}"; do
            local latest_log_line; latest_log_line=$(pm2 logs "$app_name" --lines 100 --nostream 2>/dev/null | grep "You now have" | tail -1)
            local coin_count=0
            if [ -n "$latest_log_line" ]; then coin_count=$(echo "$latest_log_line" | awk '{print $(NF-2)}'); fi
            
            printf "%-27s ${BLUE}|${RESET} ${GREEN_BOLD}%-15s${RESET}\n" "$app_name" "$coin_count"
        done
        
        echo -e "\n${BLUE}Updating in 10s... (Press any key to exit)${RESET}"
        
        read -t 10 -n 1 && break
    done
    tput cnorm; trap - EXIT
}

main_install() {
  clear
  # --- FIXED: The complex 'read' command is broken into two simpler lines for robustness ---
  local prompt_text
  prompt_text=$(echo -e "${GREEN_BOLD}Enter the API key from app.w.ai/keys:${RESET} ")
  read -rp "$prompt_text" W_AI_API_KEY
  
  if [ -z "$W_AI_API_KEY" ]; then echo "Error: API key cannot be empty."; return; fi
  local api_key="$W_AI_API_KEY"; declare -a APP_NAMES_TO_START

  echo -e "${GREEN_BOLD}Starting installation...${RESET}"
  echo -e "${GREEN_BOLD}Updating packages and installing dependencies...${RESET}"; apt-get update && apt-get install -y build-essential nano screen curl git wget lz4 jq make gcc automake autoconf tmux htop nvme-cli pkg-config libssl-dev tar clang bsdmainutils ncdu unzip python3-pip python3-venv bc
  echo -e "${GREEN_BOLD}Installing libxml2 dependency...${RESET}"; apt-get install -y libxml2

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
        local instances; instances=$(bc <<< "scale=2; vram=${vram}; vram/1024/1.8" | cut -d. -f1)
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
    echo "Starting instance: ${app_name}..."; pm2 start wai.config.js --only "${app_name}"; echo "Waiting 30 seconds..."; sleep 30; 
  done
  
  echo -e "${GREEN_BOLD}Configuring PM2 to start on system boot...${RESET}";
  pm2 startup | tail -n 1 | sudo bash; pm2 save
  
  echo -e "\n${GREEN_BOLD}Installation is complete!${RESET}"
  echo -e "${YELLOW_BOLD}---------------------------------------------------------------"
  echo -e "IMPORTANT: To use 'pm2' and other commands in your terminal,"
  echo -e "you must now either:"
  echo -e "1. Run the command: ${GREEN_BOLD}source ~/.bashrc${YELLOW_BOLD}"
  echo -e "OR"
  echo -e "2. Log out and log back in to your session."
  echo -e "This is a one-time action for your current terminal session."
  echo -e "---------------------------------------------------------------${RESET}"
}

stop_worker() { 
    clear; echo -e "${GREEN_BOLD}Stopping all 'wai' worker processes...${RESET}"; 
    export NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &>/dev/null
    if command -v pm2 &> /dev/null; then pm2 stop all; echo "All processes stopped."; else echo "PM2 not found in PATH. Try running 'source ~/.bashrc' first."; fi
}

start_worker() {
    clear; echo -e "${GREEN_BOLD}Restarting all 'wai' worker processes...${RESET}";
    export NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &>/dev/null
    if command -v pm2 &> /dev/null; then pm2 restart all; echo "All processes restarted."; else echo "PM2 not found in PATH. Try running 'source ~/.bashrc' first."; fi
}

uninstall_worker() {
    clear; read -p "Are you sure you want to completely uninstall the worker? This action is irreversible. (y/n) " -n 1 -r; echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${GREEN_BOLD}Starting uninstallation...${RESET}";
        if [ -f "$PID_FILE" ] && ps -p "$(cat "$PID_FILE")" > /dev/null; then
            echo "Stopping periodic restarter..."
            kill "$(cat "$PID_FILE")"
            rm -f "$PID_FILE"
        fi
        rm -f "$LOG_FILE"
        
        export NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &>/dev/null
        if command -v pm2 &> /dev/null; then
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
