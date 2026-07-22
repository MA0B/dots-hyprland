#!/usr/bin/env bash
# Alterna o LG 27GN750 (DP-3) entre modo SDR e HDR10.
# Grava o modo em hdr-state e recarrega a config — custom/general.lua lê o
# estado e aplica a regra de monitor correspondente. (Toggle via hyprctl eval
# não é confiável no 0.56: regras aplicadas após um reload param de surtir efeito.)
# HDR: cm hdredid (colorimetria de fábrica do EDID) + branco SDR ~176 nits.
# SDR: perfil ICC oficial da LG (gamma 2.2), brilho controlado no OSD.

STATE_FILE="$HOME/.config/hypr/custom/scripts/hdr-state"

# a fonte da verdade é o arquivo de estado: com ICC ativo, o preset
# reportado pelo hyprctl fica desatualizado (stale) e não serve de referência
current=$(cat "$STATE_FILE" 2>/dev/null || echo hdr)

if [[ "$current" == "hdr" ]]; then
    echo "sdr" > "$STATE_FILE"
    hyprctl reload
    notify-send -a "HDR" -i video-display "HDR desligado" "Modo SDR com perfil ICC oficial da LG (brilho pelo OSD)"
else
    echo "hdr" > "$STATE_FILE"
    hyprctl reload
    notify-send -a "HDR" -i video-display "HDR ligado" "HDR10 ativo — SDR mapeado a ~176 nits"
fi
