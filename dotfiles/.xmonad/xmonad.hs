import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

main = do
     xmproc <- spawnPipe "/usr/bin/xmobar"
     xmonad $ defaultConfig
         { borderWidth        = 2
         , terminal           = "urxvt"
         , normalBorderColor  = "#cccccc"
         , focusedBorderColor = "#cd8b00"
         , manageHook         = manageDocks <+> manageHook defaultConfig
         , layoutHook         = avoidStruts  $  layoutHook defaultConfig
         , logHook            = dynamicLogWithPP xmobarPP
             { ppOutput       = hPutStrLn xmproc
     	     , ppTitle        = xmobarColor "green" "" . shorten 50
             }
         , modMask            = mod4Mask
         } `additionalKeys`
         [ ((mod4Mask .|. shiftMask, xK_z), spawn "xscreensaver-command -lock")
         , ((mod4Mask,               xK_p), spawn "dmenu_run -nb '#222222' -sb '#222222' -nf '#cccccc' -sf gold -fn Inconsolata-10:style=Bold")
         ]
