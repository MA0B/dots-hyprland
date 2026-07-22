-- Custom environment variables to fix cedilla globally via Fcitx5
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")

-- Wine/jogos: menos logging (mais desempenho) e cache de shaders NVIDIA sem limpeza automática
hl.env("WINEDEBUG", "-all")
hl.env("__GL_SHADER_DISK_CACHE_SKIP_CLEANUP", "1")
