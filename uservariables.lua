-- (No requirements)

local _M = {
    terminal   = os.getenv("TERMINAL") or "wezterm",
    editor     = os.getenv("EDITOR") or "nvim",
    browser    = os.getenv("BROWSER") or "kbrowser",
    editor_cmd = "wezterm start -- nvim",
    logs_cmd   = "wezterm start -- tail -f /var/log/nginx/nginx.log",
    modkey     = "Mod4",
    altkey     = "Mod1"
}

return _M
