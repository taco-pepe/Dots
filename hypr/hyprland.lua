------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

---------------------
----  PROGRAMS   ----
---------------------
local terminal = "kitty --config ~/.taco/kitty/kitty.conf"
local fileManager = "dolphin"
local menu = "wofi --conf ~/.taco/wofi/config --style ~/.taco/wofi/style.css --show drun"

-------------------
--- wallpapers ----
-------------------
-- put your wallpaper paths here as vars
local wallpaper = os.getenv("HOME") .. "/.taco/wallpapers/cat.png"

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
	-- Start Shell Bar.
	hl.exec_cmd("qs -p $HOME/.taco/bar/shell.qml")

	-- hl.exec_cmd("espanso service start --unmanaged") espnaso. uncheck for systems that have espanso as a systemd or openrc service

	-- wallpaper start.
	hl.exec_cmd(string.format("swaybg -i %s -m fill &", wallpaper))
	hl.exec_cmd("mako --config $HOME/.taco/mako/config")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 2,

		border_size = 2,

		col = {
			-- Catppuccin Mocha: blue -> mauve.
			active_border = { colors = { "rgba(89b4faee)", "rgba(cba6f7ee)" }, angle = 45 },
			inactive_border = "rgba(495068aa)",
		},

		resize_on_border = false,
		allow_tearing = false,

		layout = "dwindle",
	},

	decoration = {
		-- Square corners. edit rounding to change roundness "0 means not rounded"
		rounding = 0,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0xee11111b, -- Catppuccin crust
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "quick", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 3, bezier = "quick" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 3, bezier = "quick" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 5, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 5, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 3, bezier = "quick", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 3, bezier = "quick" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 3, bezier = "quick" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 3, bezier = "quick", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

hl.config({
	dwindle = {
		preserve_split = true, -- You probably want this
	},
})

hl.config({
	master = {
		new_status = "master",
	},
})

hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(.
		-- sorry hyprland :(
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = false,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- configure mouse per device
-- hl.device({
--  name = "mouse-name",
--	sensitivity = -0.5,
--})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Screenshots: grim + slurp

-- Print Screen: select region and save
hl.bind(
	"PRINT",
	hl.dsp.exec_cmd(
		'mkdir -p "$HOME/Pictures/Screenshots" && grim -g "$(slurp)" "$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"'
	)
)

-- SUPER + PRINT: select region and copy to clipboard
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

-- SUPER + SHIFT + PRINT: full-screen screenshot
hl.bind(
	mainMod .. " + SHIFT + PRINT",
	hl.dsp.exec_cmd(
		'mkdir -p "$HOME/Pictures/Screenshots" && grim "$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"'
	)
)

-- SUPER + RETURN: Open terminal
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
-- SUPER + Q: close application
local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- SUPER + M: ShutDown Hyprland
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

-- SUPER+ SPAce: Open the menu "wofi"
hl.bind(mainMod .. " + SPAce", hl.dsp.exec_cmd(menu))

-- SUPER + E: Open File file Manager
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))

-- SUPER + V: Make window float :)
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- SUPER + R: Also open menu?
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))

-- SUPER + P: toggle pseudo? idk
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- SUPER + J: toggle spilit?? idk
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- SUPER + ARROW: Move focus :D
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- SUPER + [0-9]: Switch workspaces btw.
-- SUPER + SHIFT + [0-9]: Move active window to a workspace btw.
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad: i dont use it so i dont know.
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- SUPER + scroll: Scroll through existing workspaces :D
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- SUPER + [RMB-LMB]: Move/resize windows
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness :D
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.layer_rule({
	name = "bar",
	match = { namespace = "quickshell:bar" },
	blur = true,
	ignore_alpha = 0.1,
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})
