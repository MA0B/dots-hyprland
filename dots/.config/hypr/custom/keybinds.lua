-- This file will not be overwritten across dots-hyprland updates.
-- The file name is for the sake of organization and does not matter
-- See the corresponding files in ~/.config/hypr/hyprland for examples

hl.bind("SUPER + SHIFT + H", hl.dsp.exec_cmd(HOME .. "/.config/hypr/custom/scripts/hdr-toggle.sh"),
    { description = "Monitor: alternar SDR/HDR" })
