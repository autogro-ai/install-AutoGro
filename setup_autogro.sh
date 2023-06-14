#!/bin/bash

cd "$HOME"
if [ ! -d "bin" ]; then
    mkdir bin
    echo "Created 'bin' directory."
else
    echo "'bin' directory already exists."
fi
cd "$HOME/bin/"
git clone https://github.com/autogro-ai/AutoGro.git
cd "$HOME/bin/AutoGro"
echo "Sucessfully downloaded AutoGro."
echo "Confused on what to do next? Read the docs at https://autogro.gitbook.io/autogro-docs/.\n\nFound a bug? Let us know: https://github.com/autogro-ai/AutoGro/issues\n\nJoin our community at: 
https://discord.gg/mWMFBDhg!\n\n Thank you for your support. We couldn't do this without our community." 

