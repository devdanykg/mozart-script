# mozart-script
Custom emoji selector for macOS

# Install script
Open terminal & paste this command:
````
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" && \
brew install hammerspoon && \
git clone https://github.com/devdanykg/mozart-script.git ~/.devdany && \
mkdir -p ~/.hammerspoon/ && \
cp ~/.devdany/init.lua ~/.hammerspoon/ && \
cp ~/.devdany/version.txt ~/.hammerspoon/ && \
rm -Rf ~/.devdany/ && \
open -a Hammerspoon
````
