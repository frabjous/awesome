-- (No requirements)

local _M = {
    terminal   = os.getenv("TERMINAL") or "wezterm",
    editor     = os.getenv("EDITOR") or "nvim",
    browser    = os.getenv("BROWSER") or "firefox",
    editor_cmd = "wezterm -- nvim",
    modkey     = "Mod4",
    altkey     = "Mod1"
}

return _M
