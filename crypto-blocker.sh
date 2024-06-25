#!/bin/bash

# Define the paths for the scripts and service files
SCRIPT_PATH="/usr/local/bin/crypto_miner_blocker.sh"
SERVICE_PATH="/etc/systemd/system/crypto_miner_blocker.service"
INITD_SERVICE_PATH="/etc/init.d/crypto_miner_blocker"

# Function to detect the package manager
detect_package_manager() {
    if command -v apt-get &> /dev/null; then
        echo "apt-get"
    elif command -v yum &> /dev/null; then
        echo "yum"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v zypper &> /dev/null; then
        echo "zypper"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    else
        echo "unknown"
    fi
}

# Function to create the crypto mining blocker script
create_crypto_miner_blocker_script() {
    cat << 'EOF' > $SCRIPT_PATH
#!/bin/bash

# Define the list of known crypto mining and server process names
processes=("minerd" "xmrig" "xmr-stak" "cryptonight" "ethminer" "miner" "ccminer" "cgminer" "bfgminer" "srbminer" "cpuminer" "nicehash" "fahclient" "python" "java")

# Function to block processes on the host
block_host_processes() {
    for proc in "${processes[@]}"; do
        # Check if the process is running
        if pgrep -x "$proc" > /dev/null; then
            echo "Killing $proc process..."
            pkill -f "$proc"
        fi
    done
}

# Function to block processes within Docker containers
block_docker_processes() {
    # Get IDs of all running Docker containers
    container_ids=$(docker ps -q)

    for container_id in $container_ids; do
        # Check if the container is running a known process
        for proc in "${processes[@]}"; do
            if docker exec "$container_id" pgrep -x "$proc" > /dev/null; then
                echo "Killing $proc process in Docker container $container_id..."
                docker exec "$container_id" pkill -f "$proc"
            fi
        done
    done
}

# Run the blocking functions in an infinite loop with a sleep interval
while true; do
    block_host_processes
    block_docker_processes
    echo "Processes blocked. Sleeping for 1 minute..."
    sleep 60
done
EOF
    chmod +x $SCRIPT_PATH
}

# Function to create the systemd service file
#!/bin/bash

# Define the paths for the scripts and service files
SCRIPT_PATH="/usr/local/bin/crypto_miner_blocker.sh"
SERVICE_PATH="/etc/systemd/system/crypto_miner_blocker.service"
INITD_SERVICE_PATH="/etc/init.d/crypto_miner_blocker"

# Function to detect the package manager
detect_package_manager() {
    if command -v apt-get &> /dev/null; then
        echo "apt-get"
    elif command -v yum &> /dev/null; then
        echo "yum"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v zypper &> /dev/null; then
        echo "zypper"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    else
        echo "unknown"
    fi
}

# Function to create the crypto mining blocker script
create_crypto_miner_blocker_script() {
    cat << 'EOF' > $SCRIPT_PATH
#!/bin/bash

# Define the list of known crypto mining and server process names
processes=("minerd" "xmrig" "xmr-stak" "cryptonight" "ethminer" "miner" "ccminer" "cgminer" "bfgminer" "srbminer" "cpuminer" "nicehash" "fahclient" "python" "java")

# Function to block processes on the host
block_host_processes() {
    for proc in "${processes[@]}"; do
        # Check if the process is running
        if pgrep -x "$proc" > /dev/null; then
            echo "Killing $proc process..."
            pkill -f "$proc"
        fi
    done
}

# Function to block processes within Docker containers
block_docker_processes() {
    # Get IDs of all running Docker containers
    container_ids=$(docker ps -q)

    for container_id in $container_ids; do
        # Check if the container is running a known process
        for proc in "${processes[@]}"; do
            if docker exec "$container_id" pgrep -x "$proc" > /dev/null; then
                echo "Killing $proc process in Docker container $container_id..."
                docker exec "$container_id" pkill -f "$proc"
            fi
        done
    done
}

# Run the blocking functions in an infinite loop with a sleep interval
while true; do
    block_host_processes
    block_docker_processes
    echo "Processes blocked. Sleeping for 1 minute..."
    sleep 60
done
EOF
    chmod +x $SCRIPT_PATH
}

# Function to create the systemd service file
create_systemd_service() {
    cat << EOF > $SERVICE_PATH
[Unit]
Description=Crypto Miner Blocker Service
After=network.target

[Service]
ExecStart=$SCRIPT_PATH
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable crypto_miner_blocker.service
    systemctl start crypto_miner_blocker.service
    systemctl status crypto_miner_blocker.service
}

# Function to create the init.d service file
create_initd_service() {
    cat << EOF > $INITD_SERVICE_PATH
#!/bin/sh
### BEGIN INIT INFO
# Provides:          crypto_miner_blocker
# Required-Start:    \$remote_fs \$syslog
# Required-Stop:     \$remote_fs \$syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Crypto Miner Blocker Service
# Description:       Block crypto mining processes on the host and in Docker containers.
### END INIT INFO

case "\$1" in
    start)
        echo "Starting crypto_miner_blocker"
        $SCRIPT_PATH &
        ;;
    stop)
        echo "Stopping crypto_miner_blocker"
        pkill -f $SCRIPT_PATH
        ;;
    restart)
        \$0 stop
        \$0 start
        ;;
    status)
        pgrep -f $SCRIPT_PATH && echo "Running" || echo "Stopped"
        ;;
    *)
        echo "Usage: \$0 {start|stop|restart|status}"
        exit 1
esac

exit 0
EOF
    chmod +x $INITD_SERVICE_PATH
    update-rc.d crypto_miner_blocker defaults
    service crypto_miner_blocker start
    service crypto_miner_blocker status
}

# Main script execution
main() {
    create_crypto_miner_blocker_script

    if command -v systemctl &> /dev/null; then
        create_systemd_service
    elif [ -d /etc/init.d ]; then
        create_initd_service
    else
        echo "Unsupported init system."
        exit 1
    fi
}

main
￼Entercreate_systemd_service() {
    cat << EOF > $SERVICE_PATH
[Unit]
Description=Crypto Miner Blocker Service
After=network.target

[Service]
ExecStart=$SCRIPT_PATH
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    systemctl enable crypto_miner_blocker.service
    systemctl start crypto_miner_blocker.service
    systemctl status crypto_miner_blocker.service
}

# Function to create the init.d service file
create_initd_service() {
    cat << EOF > $INITD_SERVICE_PATH
#!/bin/sh
### BEGIN INIT INFO
# Provides:          crypto_miner_blocker
ired-Start:    \$remote_fs \$syslog
# Required-Stop:     \$remote_fs \$syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Crypto Miner Blocker Service
# Description:       Block crypto mining processes on the host and in Docker containers.
### END INIT INFO

case "\$1" in
    start)
        echo "Starting crypto_miner_blocker"
        $SCRIPT_PATH &
        ;;
    stop)
        echo "Stopping crypto_miner_blocker"
        pkill -f $SCRIPT_PATH
        ;;
    restart)
        \$0 stop
        \$0 start
        ;;
    status)
        pgrep -f $SCRIPT_PATH && echo "Running" || echo "Stopped"
        ;;
    *)
        echo "Usage: \$0 {start|stop|restart|status}"
