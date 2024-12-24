### A script to set up my .zshrc
from pathlib import Path

text_to_add = """
# Setting up Pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Load Shell tools that I use
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
eval "$(fnm env --use-on-cd --shell zsh)"
"""

zshrc = Path.home()/".zshrc"

content = zshrc.read_text() if zshrc.exists() else ""

# Add text block if not present
if text_to_add.strip() not in content:
    with open(zshrc,"a") as f:
        f.write(f"\n{text_to_add}")