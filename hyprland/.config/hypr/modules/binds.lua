local terminal = 'ghostty'
local fileManager = 'dolphin'
local browser = 'zen-browser'
local editor = "code"

local colorpicker = 'hyprpicker -a'

local mainMod = "SUPER"

-- MiSh
hl.bind(mainMod .. " + V", hl.dsp.global("quickshell:clipboard"))
hl.bind(mainMod .. " + SUPER_L", hl.dsp.global("quickshell:applauncher"))
hl.bind(mainMod .. " + M", hl.dsp.global("quickshell:wallpaper"))

-- App Launch
hl.bind(mainMod .. "+ Backspace", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. "+ E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. "+ T", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. "+ C", hl.dsp.exec_cmd(editor))

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -z -m region --clipboard-only"))

-- Lock screen
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))

-- Color picker
hl.bind("F11", hl.dsp.exec_cmd(colorpicker))

-- Exit Hyprland via UWSM
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("uwsm stop"))

-- Mouse binds
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Window management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())

-- Move active window to a workspace with mainMod + SHIFT + mouse buttons
hl.bind(mainMod .. " + SHIFT + mouse:276", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + mouse:275", hl.dsp.window.move({ workspace = "e-1" }))

-- Switch to specific workspace & move active window
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + 0", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "special:magic" }))
