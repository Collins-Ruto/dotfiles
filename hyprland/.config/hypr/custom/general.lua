-- General configuration
-- https://wiki.hyprland.org/Configuring/Variables/

-- Runs every reload (exec semantics)
hl.exec_cmd("gsettings set $GNOME_SCHEMA font-name 'MesloLGSNerdFont-Bold'")

hl.config({
    input = {
        sensitivity   = 0.3,
        accel_profile = "adaptive",
    },
    decoration = {
        blur = {
            enabled           = true,
            size              = 8,
            passes            = 2,
            ignore_opacity    = true,
            new_optimizations = true,
        },
    },
    xwayland = {
        force_zero_scaling = true,
    },
})
