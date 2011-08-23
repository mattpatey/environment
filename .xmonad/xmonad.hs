import Data.Ratio
import System.IO (hPutStrLn)
import XMonad
import XMonad.Actions.CopyWindow
import XMonad.Actions.UpdatePointer
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout
import XMonad.Layout.Circle
import XMonad.Layout.Grid
import XMonad.Layout.LayoutHints
import XMonad.Layout.Magnifier
import XMonad.Layout.NoBorders
import XMonad.Prompt
import XMonad.Prompt.Ssh
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run (spawnPipe)
import qualified Data.Map as M
import qualified XMonad.StackSet as W

import qualified XMonad.Core as XMonad
    (workspaces,manageHook,numlockMask,keys,logHook,startupHook,borderWidth,mouseBindings
    ,layoutHook,modMask,terminal,normalBorderColor,focusedBorderColor,focusFollowsMouse
    ,handleEventHook)

focusedBorderColor :: String
focusedBorderColor = "darkgreen"

borderWidth :: Dimension
borderWidth = 2

myLayoutHook = smartBorders (avoidStruts (tiled ||| Mirror tiled ||| Circle ||| magnify Grid ||| Full))

    where
      tiled = Tall nmaster delta ratio
      nmaster = 1
      delta = 3/100
      ratio = 1/2
      magnify = magnifiercz (12%10)

myManageHook = composeAll [ className =? "XCalc" --> doFloat
                          , className =? "display" --> doFloat ]
newManageHook = myManageHook <+> manageHook defaultConfig <+> manageDocks

myKeys x =
    [((m .|. modMask x, k), windows $ f i)
         | (i, k) <- zip (workspaces x) [xK_1 ..]
         , (f, m) <- [(W.view, 0), (W.shift, shiftMask), (copy, shiftMask .|. controlMask)]]
    ++
    [  ((modMask x .|. controlMask, xK_s), sshPrompt defaultXPConfig)
     , ((modMask x .|. shiftMask, xK_z), spawn "gnome-screensaver-command --lock")
     , ((modMask x, xK_p), spawn "exe=`dmenu_run -nb '#111111' -nf '#FFFFFF' -sb '#FF0000' -fn xft:Consolas:size=10:antialias=true` && eval \"exec $exe\"")]
newKeys x = M.union (keys defaultConfig x) (M.fromList (myKeys x))

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig {
        XMonad.borderWidth = Main.borderWidth,
        XMonad.focusedBorderColor = Main.focusedBorderColor,
        manageHook = newManageHook,
        layoutHook = myLayoutHook,
        modMask = mod4Mask,
        keys = newKeys,
	terminal = "urxvt",
	logHook = dynamicLogWithPP xmobarPP
	    { ppOutput = hPutStrLn xmproc,
              ppTitle = xmobarColor "green" "" }
        }
