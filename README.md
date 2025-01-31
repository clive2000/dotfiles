xhuang's dotfiles

## Install yadm

```bash
sudo mkdir -p /usr/local/bin
sudo curl -fLo /usr/local/bin/yadm https://github.com/yadm-dev/yadm/raw/master/yadm && sudo chmod a+x /usr/local/bin/yadm
```

## Install xcode command line tools

```bash
xcode-select -p &> /dev/null
if [ $? -ne 0 ]; then
  echo "Command Line Tools for Xcode not found. Installing from softwareupdate…"
# This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
  softwareupdate -i "$PROD" --verbose;
else
  echo "Command Line Tools for Xcode have been installed."
fi
```

## Scripts

wget

```
wget -qO- https://raw.githubusercontent.com/clive2000/dotfiles/refs/heads/master/.config/bootstrap/run.sh | bash
```

OR 

```
wget -q https://raw.githubusercontent.com/clive2000/dotfiles/refs/heads/master/.config/bootstrap/run.sh -O run.sh
bash run.sh
```

curl

```
curl -sL https://raw.githubusercontent.com/clive2000/dotfiles/refs/heads/master/.config/bootstrap/run.sh | bash
```

OR

```
curl -sLO https://raw.githubusercontent.com/clive2000/dotfiles/refs/heads/master/.config/bootstrap/run.sh
bash run.sh
```

## Post-install

On MacOS, please re-run `yadm bootstrap` after bootstrap process.