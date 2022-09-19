-- (No requirements)

local _M = {
    terminal   = os.getenv("TERMINAL") or "wezterm",
    editor     = os.getenv("EDITOR") or "nvim",
    --browser    = os.getenv("BROWSER") or "firefox",
    -- browser    = os.getenv("BROWSER") or "qutebrowser",
    browser    = os.getenv("BROWSER") or "kbrowser",
    editor_cmd = "wezterm start -- nvim",
    modkey     = "Mod4",
    altkey     = "Mod1"
}

return _M
