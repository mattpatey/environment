import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Layout.NoBorders

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/mlp/.xmobarrc"
    xmonad $ defaultConfig {
        manageHook = manageDocks <+> manageHook defaultConfig,
        layoutHook = avoidStruts . smartBorders $  layoutHook defaultConfig,
	logHook = dynamicLogWithPP xmobarPP
	    { ppOutput = hPutStrLn xmproc,
              ppTitle = xmobarColor "green" "" . shorten 50 },
        modMask = mod4Mask
        }
        `additionalKeys`
	[ ((mod4Mask .|. shiftMask, xK_z), spawn "gnome-screensaver-command --lock") ]