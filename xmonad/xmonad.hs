-- I really have a very vague idea of what this stuff does.

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook ( NoUrgencyHook(NoUrgencyHook), withUrgencyHook )
import XMonad.Util.EZConfig
import XMonad.Util.Run ( spawnPipe )
import XMonad.Util.WorkspaceCompare

main :: IO ()
main = do
    conky  <- spawnPipe dzenConky

    xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig
    {
          normalBorderColor = "#181818"
        , focusedBorderColor = "#555555"
        , borderWidth = 2
        , terminal   = "urxvt"
        , clickJustFocuses = True
        , manageHook = composeAll
            [ isFullscreen --> doFullFloat
            , manageHook defaultConfig
            ]
    } `additionalKeysP`
        [ ("M-q", spawn "killall dzen2; xmonad --recompile && xmonad --restart")
        , ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 3%+")
        , ("<XF86AudioLowerVolume>", spawn "amixer sset Master 3%-")
        , ("<XF86AudioMute>",        spawn "amixer sset Master toggle")
    ]

-- 
dzenConky = "conky -c ~/.conkyrc | dzen2 -ta l -w 1600 -p -xs 1 -fn Verdana-10 -e 'onstart=lower'"

-- | The unexported X.H.DynamicLog.toggleStrutsKey
toggleStrutsKey :: XConfig l -> (KeyMask, KeySym)
toggleStrutsKey XConfig { modMask = modm } = (modm, xK_b)
