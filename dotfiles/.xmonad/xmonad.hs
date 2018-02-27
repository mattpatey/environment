import qualified XMonad.Layout.IndependentScreens as LIS
import XMonad.Util.Scratchpad
import XMonad.Util.Dmenu
import qualified XMonad.StackSet as W
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout
import XMonad.Layout.IndependentScreens
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.Themes
import System.IO

mlp_borderWidth = 2
mlp_focusedBorderColor = "#ff3"
mlp_modMask = mod4Mask
mlp_normalBorderColor = "#555555"
scratchpad_terminal = "urxvt -bg 'rgba:0000/0000/0000/c800' -fg '#ffff00' -b 20"
mlp_terminal = "urxvt"
manageScratchPad :: ManageHook
manageScratchPad = scratchpadManageHook (W.RationalRect l t w h)
  where
    h = 0.3
    w = 1
    t = 1 - h
    l = 1 - w
mlp_manageHook = manageScratchPad <+> manageDocks <+> manageHook defaultConfig
mlp_layoutHook = smartBorders (avoidStruts $ layoutHook defaultConfig)
mlp_PP :: PP
mlp_PP = defaultPP {
    ppCurrent = wrap "<fc=#ff0000>[" "]</fc>"
    , ppVisible = wrap "(" ")"
    , ppHidden = noScratchPad
    , ppHiddenNoWindows = noScratchPad
    }
    where
      noScratchPad ws = if ws == "NSP" then "" else ws


myKeys =
    [   ((mlp_modMask, xK_v), spawn "amixer -c 0 set PCM 2dB-")
      , ((mlp_modMask, xK_b), spawn "amixer -c 0 set PCM 2dB+")
      , ((mlp_modMask, xK_i), scratchPad)
      , ((mlp_modMask .|. shiftMask, xK_f), spawn "/usr/bin/thunar")
      , ((mlp_modMask .|. shiftMask, xK_l), spawn "/usr/bin/xscreensaver-command -lock")
    ]
    ++
    [((m .|. mlp_modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [1,0,2]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    where
      scratchPad = scratchpadSpawnActionTerminal scratchpad_terminal

myWorkspaces = ["1","2","3","4"]

main = do
    xmonad $ defaultConfig {
        borderWidth = mlp_borderWidth
        , modMask = mlp_modMask
        , manageHook = mlp_manageHook
        , layoutHook = mlp_layoutHook
        , focusedBorderColor = mlp_focusedBorderColor
        , normalBorderColor = mlp_normalBorderColor
        , terminal = mlp_terminal
        , workspaces = myWorkspaces
        } `additionalKeys` myKeys
