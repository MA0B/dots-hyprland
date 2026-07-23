-- LG 27GN750-B: 10-bit sempre; modo HDR/SDR controlado pelo arquivo de estado
-- (SUPER+SHIFT+H alterna via scripts/hdr-toggle.sh, que grava o estado e dá reload)
-- HDR: cm = "hdredid" usa a colorimetria de fábrica do EDID (idêntica ao ICC oficial da LG)
--      sdrbrightness compensa o conteúdo SDR, que fica escuro em modo HDR (1.0–2.0+)
-- SDR: perfil ICC oficial da LG (27GN7.icm — gamma 2.2 e primárias de fábrica)
local hdr_state = "hdr"
local f = io.open(HOME .. "/.config/hypr/custom/scripts/hdr-state", "r")
if f then
    hdr_state = f:read("*l") or "hdr"
    f:close()
end

if hdr_state == "sdr" then
    hl.monitor({
        output = "DP-3",
        mode = "1920x1080@240",
        position = "auto",
        scale = 1,
        bitdepth = 10,
        cm = "srgb",
        icc = HOME .. "/.local/share/icc/27GN7.icm",
    })
else
    hl.monitor({
        output = "DP-3",
        mode = "1920x1080@240",
        position = "auto",
        scale = 1,
        bitdepth = 10,
        cm = "hdredid",
        sdrbrightness = 2.2,
    })
end

-- Custom general settings for keyboard layout
hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "intl",
    },
    misc = {
        vrr = 2, -- FreeSync/VRR apenas em janelas fullscreen (jogos)
    },
    render = {
        direct_scanout = false,
    }
})
