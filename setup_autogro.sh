#!/bin/sh
sudo chmod 755 setup_autogro.sh

failed_tasks=""

if pip3 install adafruit-circuitpython-mcp3xxx; then
    echo "Installed adafruit-circuitpython-mcp3xxx library."
else
    echo "Failed to install adafruit-circuitpython-mcp3xxx library."
    failed_tasks+=""
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

# Set the path to the target directory
target_dir="$HOME/bin/AutoGro"

if [ -d "$target_dir" ]; then
    # Prompt the user for confirmation
    while true; do
        echo "\n\n**NOTE** Pressing yes will delete your current AutoGro folder and update it with the latest version. If you have any local sensor data or files, it will all be deleted. Please make sure there is nothing you need from your old project folder before pressing yes."
        echo -n "The AutoGro directory already exists. Do you want to delete it? (y/n): "
        read confirmation
        case "$confirmation" in
            [Yy]* )
                # Delete the target directory
                rm -rf "$target_dir"
                echo "Existing AutoGro directory deleted."
                break;;
            [Nn]* )
                echo "Aborted. Existing AutoGro directory was not deleted."
                exit;;
            * )
                echo "Please answer 'y' for yes or 'n' for no.";;
        esac
    done
fi

# Create the "bin" directory if it doesn't exist
mkdir -p "$HOME/bin"

# Change to the "bin" directory
cd "$HOME/bin" || exit

# Clone the AutoGro repository
if git clone "$repository"; then
    echo "AutoGro repository cloned successfully."
    cd "$target_dir" || exit
    # Perform any additional installation steps here, if needed
else
    echo "Failed to clone AutoGro repository."
    failed_tasks+="Repository cloning failed."
fi


cd "$HOME/bin/AutoGro/Scripts"
sudo cp rc.local /etc/
sudo chmod 755 crontab.pi

crontab_file="$HOME/bin/AutoGro/Scripts/crontab.pi"

# Update crontab with sudo
if sudo crontab "$crontab_file"; then
    echo "Crontab file added to the cron scheduler."
else
    echo "Failed to add crontab file. Command execution failed."
    failed_tasks+="Crontab setup "
fi

# Check if crontab entry is present
if crontab -l | grep -q "Setting up logs to record at midnight, see more at /Scripts/crontab.pi"; then
    echo "Crontab file already added to the cron scheduler."
else
    echo "Failed to add crontab file. Verification failed."
    failed_tasks+="Crontab Setup\n\nRUN THE FOLLOW COMMANDS MANUALLY:\nsudo crontab crontab.pi\ncrontab -l\n\nYou should see something like this now --> 0 0 * * * /home/pi/bin/AutoGro/Scripts/wrap &\n"
fi


echo "\n=========================================================================="
echo "Successfully downloaded AutoGro and set up the environment.\n\n"
echo "Check out our docs at https://autogro.gitbook.io/autogro-docs/."
echo "Found a bug? Let us know: https://github.com/autogro-ai/AutoGro/issues"
echo "\n==Join our Discord Community==\n\nhttps://discord.gg/mWMFBDhg!\n"
echo "Thank you for your support. We couldn't do this without our community."
echo "=========================================================================="
echo "ERROR LOGS:\n"
echo "Tasks that failed to install: $failed_tasks"
