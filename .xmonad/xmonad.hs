import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.Tabbed
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Themes
import System.IO

mlp_borderWidth = 0
mlp_focusedBorderColor = "#007777"
mlp_layoutHook = avoidStruts $ layoutHook defaultConfig ||| tabbed shrinkText (theme kavonForestTheme)
mlp_manageHook = manageDocks <+> manageHook defaultConfig
mlp_modMask = mod4Mask
mlp_normalBorderColor = "#ffffff"
mlp_terminal = "urxvt"

mlp_PP :: PP
mlp_PP = defaultPP {
    ppCurrent = wrap "<fc=#ff0000>[" "]</fc>"
    , ppTitle = xmobarColor "green" "" . shorten 60
    , ppVisible = wrap "(" ")"
    }

main = do
    pipe <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"	
    xmonad =<< xmobar defaultConfig { 
        borderWidth = mlp_borderWidth
        , focusedBorderColor = mlp_focusedBorderColor
        , layoutHook = mlp_layoutHook
        , logHook = dynamicLogWithPP $ mlp_PP { ppOutput = hPutStrLn pipe }
        , manageHook = mlp_manageHook
        , modMask = mlp_modMask
        , normalBorderColor = mlp_normalBorderColor
        , terminal = mlp_terminal
        }
