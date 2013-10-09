-------------------------------------------------------------------------------
-- |
--
-- xmonad.hs, pbrisbin 2012
--
-- <https://github.com/pbrisbin/xmonad-config>
--
-------------------------------------------------------------------------------
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Util.EZConfig
import XMonad.Util.WorkspaceCompare

main :: IO ()
main = do
    conf <- statusBar "conky | dzen2 -ta l -w 1600 -p -xs 1 -fn Verdana-10 -e 'onstart=lower'"
                dzenPP
                    { ppHidden = pad
                    , ppTitle  = pad . dzenColor "#bbb" "" . dzenEscape
                    , ppLayout = const ""
                    , ppSort   = getSortByXineramaRule
                    }
                toggleStrutsKey
                $ withUrgencyHook NoUrgencyHook
                $ defaultConfig
                    { normalBorderColor = "#181818"
                    , focusedBorderColor = "#555555"
                    , borderWidth = 2
                    , terminal   = "urxvt"
                    , clickJustFocuses = True
                    , manageHook = composeAll
                        [ isFullscreen --> doFullFloat
                        , manageHook defaultConfig
                        ]
                    }
                    `additionalKeysP`
                        [ ("M-p", spawn "x=$(yeganesh -x -- -i -fn Verdana-12) && exec $x")
                        , ("M-q", spawn "killall dzen2; xmonad --recompile && xmonad --restart")
                        , ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 3%+")
                        , ("<XF86AudioLowerVolume>", spawn "amixer sset Master 3%-")
                        , ("<XF86AudioMute>",        spawn "amixer sset Master toggle")
                        ]

    xmonad conf

-- | The unexported X.H.DynamicLog.toggleStrutsKey
toggleStrutsKey :: XConfig l -> (KeyMask, KeySym)
toggleStrutsKey XConfig { modMask = modm } = (modm, xK_b)
