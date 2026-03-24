# mozart-script
Custom emoji selector for macOS

# Review

<img width="345" height="301" alt="Screenshot 2026-03-24 at 9 14 04 PM" src="https://github.com/user-attachments/assets/e86b1b8c-64d8-4e13-9cec-3aff9efabd8e" />


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
