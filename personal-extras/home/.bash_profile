#
# ~/.bash_profile
#

# Auto start Hyprland on tty1 (bypass SDDM)
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  mkdir -p ~/.cache
  exec start-hyprland > ~/.cache/hyprland.log 2>&1
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc


# Added by Antigravity CLI installer
export PATH="/home/morrice/.local/bin:$PATH"
