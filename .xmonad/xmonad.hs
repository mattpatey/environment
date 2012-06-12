import qualified XMonad.StackSet as W
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout
import XMonad.Layout.IndependentScreens
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Themes
import System.IO

mlp_borderWidth = 1
mlp_focusedBorderColor = "#ff6666"
mlp_layoutHook = smartBorders (avoidStruts $ magnifier (Tall 1 (3/100) (1/2)) ||| Full )
mlp_manageHook = composeAll [
                     className =? "XCalc" --> doFloat
	             , className =? "Vlc" --> doFloat
                 ]
                 <+> manageDocks
                 <+> manageHook defaultConfig
mlp_modMask = mod4Mask
mlp_normalBorderColor = "#555555"
mlp_terminal = "urxvt"

mlp_PP :: PP
mlp_PP = defaultPP {
    ppCurrent = wrap "<fc=#ff0000>[" "]</fc>"
    , ppTitle = xmobarColor "green" "" . shorten 60
    , ppVisible = wrap "(" ")"
    }

myKeys =
    [   ((mlp_modMask .|. shiftMask, xK_v), spawn "amixer -c 0 set PCM 2dB-")
      , ((mlp_modMask .|. shiftMask, xK_b), spawn "amixer -c 0 set PCM 2dB+")
      , ((mlp_modMask .|. shiftMask, xK_y), sendMessage MirrorShrink)
      , ((mlp_modMask .|. shiftMask, xK_n), sendMessage MirrorExpand)
      , ((mlp_modMask .|. shiftMask, xK_m), sendMessage Toggle) -- toggle window magnify
    ]
    ++
    [((m .|. mlp_modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [1,0,2]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

main = do
    pipe <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
    xmonad $ defaultConfig {
        borderWidth = mlp_borderWidth
        , focusedBorderColor = mlp_focusedBorderColor
        , layoutHook = mlp_layoutHook
        , logHook = dynamicLogWithPP $ mlp_PP { ppOutput = hPutStrLn pipe }
        , manageHook = mlp_manageHook
        , modMask = mlp_modMask
        , normalBorderColor = mlp_normalBorderColor
        , terminal = mlp_terminal
        , workspaces = myWorkspaces
        } `additionalKeys` myKeys
