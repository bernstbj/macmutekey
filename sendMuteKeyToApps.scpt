(*
    @(#) sendMuteKeyToApps.scpt v2.0.0

    Sends the (un)mute key sequence to the teleconferencing tool determined to be in use.

    2021-10-11, Brian J. Bernstein (brian@dronefone.com, briberns@)
*)


-- CONFIG: START

-- defaultApp:      Default teleconferencing app. This is the one that you or your organization uses
--                  by default, i.e. the one that you always have open.
--
--                  The idea is that some companies will always use a particular conferencing app for
--                  internal calls, but sometimes you might need to join a call with another app
--                  (e.g. someone at AWS will always have Chime running, but might have to periodically
--                  join a Zoom call). Since the logic of this script knows how to handle several
--                  different conferencing apps, the defaultApp setting can be used as a bit of a
--                  tie-breaker. See 'prioritizeDefault' setting.
--  
--                  valid defaults: chime, zoom, teams, webex.
set the defaultApp to "chime"


-- prioritizeDefault: Do we prioritize our default app as the recipient of (un)mute over other conference
--                    tools.
--
--                  If TRUE, then if we find our default alongside other conference tools, then we will
--                  send mute sequences to the default. This is if you always want the default app to
--                  receive mute sequences regardless of what else is running.
--
--                  If FALSE, we assume that other tools will get mute sequences if they are running.
--                  This is for those who always run their default app, but only run (say) Zoom when they
--                  need to and will close Zoom down when they're done, i.e. if we find a non-Chime tool
--                  running, then we assume that is the tool that needs to be (un)muted.
set the prioritizeDefault to false


-- switchAppDelay:  Time that we wait after activating the conferencing tool before sending the key
--                  sequence. Ideally this is a small value (e.g. 0.1 seconds) as it minimizes the
--                  disruption caused by the script when it switches apps, but making it too small on
--                  a slow/struggling Mac will cause the key sequence to be misfired and thus ineffective.
--                  If you are experiencing inconsistent (un)mute behavior, this value might be too low
--                  and you need to increase it; setting it to 1.0 /should/ be sufficient.
set the switchAppDelay to 0.1

-- CONFIG: END



(* DETERMINE CURRENT FRONTMOST APP *)
set frontApp to (path to frontmost application as text)


(* FIGURE OUT WHAT APPS ARE RUNNING *)
set the hasChime to false
set the hasZoom to false
set the hasTeams to false
set the hasWebex to false

tell application "System Events"
    set theList to get name of every process
    repeat with theItem in theList
        if the (theItem as string) is "Amazon Chime" then
            set the hasChime to true
        end if
        
        if the (theItem as string) is "zoom.us" then
            set the hasZoom to true
        end if
        
        if the (theItem as string) is "Teams" then
            set the hasTeams to true
        end if
        
        if the (theItem as string) is "webexmta" then
            set the hasWebex to true
        end if
    end repeat
end tell



(* SEND UN/MUTE SEQUENCE TO DETERMINED APP *)
global appl
global keyy
global modifier

if the prioritizeDefault is true
    detectAndSetDefault()
else
    if the defaultApp is not "chime" and the hasChime is true then
        setChimeKeys()
    else if the defaultApp is not "zoom" and the hasZoom is true then
        setZoomKeys()
    else if the defaultApp is not "teams" and the hasTeams is true then
        setTeamsKeys()
    else if the defaultApp is not "webex" and the hasWebex is true then
        setWebexKeys()
    else
        detectAndSetDefault()
    end if
end if


if frontApp is not equal to appl then
    tell application appl
        reopen
        activate
    end tell
        
    repeat until application appl is running
        delay 0.1
    end repeat

    delay switchAppDelay
end if

tell application "System Events" to keystroke keyy using modifier

if frontApp is not equal to appl then
    tell application frontApp
        reopen
        activate
    end tell
end if



(* SETUP OF APP KEY SEQUENCES *)
on setChimeKeys()
    set appl to "Amazon Chime"
    set keyy to "y"
    set modifier to command down
end setChimeKeys

on setZoomKeys()
    set appl to "zoom.us"
    set keyy to "a"
    set modifier to {command down, shift down}
end setZoomKeys

on setWebexKeys()
    set appl to "webexmta"
    set keyy to "m"
    set modifier to {command down, shift down}
end setWebexKeys

on setTeamsKeys()
    set appl to "Teams"
    set keyy to "m"
    set modifier to {command down, shift down}
end setTeamsKeys

on detectAndSetDefault()
    if the defaultApp is "chime" and the hasChime is true then
        setChimeKeys()
    else if the defaultApp is "zoom" and the hasZoom is true then
        setZoomKeys()
    else if the defaultApp is "teams" and the hasTeams is true then
        setTeamsKeys()
    else if the defaultApp is "webex" and the hasWebex is true then
        setWebexKeys()
    end if

    return false
end detectAndSetDefault

