#!/bin/sh

failed_tasks=""

if pip3 install adafruit-circuitpython-mcp3xxx; then
    echo "Installed adafruit-circuitpython-mcp3xxx library."
else
    echo "Failed to install adafruit-circuitpython-mcp3xxx library."
    failed_tasks+="Library installation "
fi

cd "$HOME"

if [ ! -d "bin" ]; then
    mkdir bin
    echo "Created 'bin' directory."
else
    echo "'bin' directory already exists."
fi

cd "$HOME/bin/"

repository="https://github.com/autogro-ai/AutoGro.git"

target_dir="$HOME/bin/AutoGro"

mkdir -p "$HOME/bin"

cd "$HOME/bin" || exit

if git clone "$repository"; then
    echo "AutoGro repository cloned successfully."
    cd "$target_dir" || exit
else
    echo "Failed to clone AutoGro repository."
    failed_tasks+="Repository cloning "
fi

cd "$HOME/bin/AutoGro/Scripts"

sudo cp rc.local /etc/
sudo crontab crontab.pi
if crontab crontab.pi; then
    if crontab -l | grep -q "Setting up logs to record at midnight, see more at /Scripts/crontab.pi"; then
        echo "Crontab file added to the cron scheduler."
    else
        echo "Failed to add crontab file. Verification failed."
        failed_tasks+="Crontab setup "
    fi
else
    echo "Failed to add crontab file. Command execution failed."
    failed_tasks+="Crontab setup "
fi


echo "\n=========================================================================="
echo "Successfully downloaded AutoGro and set up the environment.\n\n"
echo "Check out our docs at https://autogro.gitbook.io/autogro-docs/."
echo "Found a bug? Let us know: https://github.com/autogro-ai/AutoGro/issues"
echo "\n==Join our Discord Community==\n\nhttps://discord.gg/mWMFBDhg!\n"
echo "Thank you for your support. We couldn't do this without our community."
echo "==========================================================================\n"


echo "Tasks that failed to install: $failed_tasks"
