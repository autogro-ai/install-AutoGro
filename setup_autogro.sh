#!/bin/sh

cd "$HOME"
failed_tasks=""

if [ ! -d "bin" ]; then
    mkdir bin
    echo "Created 'bin' directory."
else
    echo "'bin' directory already exists."
fi

cd "$HOME/bin/"
if git clone https://github.com/autogro-ai/AutoGro.git; then
    echo "AutoGro repository cloned successfully."
    cd "$HOME/bin/AutoGro/"
    sudo chmod 755 AutoGro/
    if sudo chmod 755 AutoGro/; then
        "Permissions set successfully for 'AutoGro' directory."
    else
    echo "Failed to set permissions for 'AutoGro' directory."
    failed_tasks="Permission setup "
    fi
    cd "$HOME/bin/AutoGro/Scripts"
    
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

    if pip3 install adafruit-circuitpython-mcp3xxx; then
        echo "Installed adafruit-circuitpython-mcp3xxx library."
        echo "Successfully downloaded AutoGro and set up environment."
        echo "Confused on what to do next? Read the docs at https://autogro.gitbook.io/autogro-docs/."
        echo "Found a bug? Let us know: https://github.com/autogro-ai/AutoGro/issues"
        echo "Join our community at: https://discord.gg/mWMFBDhg!"
        echo "Thank you for your support. We couldn't do this without our community."
    else
        echo "Failed to install adafruit-circuitpython-mcp3xxx library."
        failed_tasks+="Library installation "
    fi
else
    echo "Failed to clone AutoGro repository."
    failed_tasks+="Repository cloning "
fi

echo "Path of the current file: $(readlink -f $0)"
echo "Tasks that failed: $failed_tasks"
