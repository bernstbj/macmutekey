(*
    @(#) sendMuteKeyToApps.scpt v2.0.1

    Sends the (un)mute key sequence to the teleconferencing tool determined to be in use.

    2021-10-11, Brian J. Bernstein (brian@dronefone.com, briberns@)

    Revision History:
        1.0.0   - initial release, only supporting Chime.
        2.0.0   - Reworked to support multiple applications, defaults, prioritization.
                  Now supports chime, zoom, skype, teams, and webex.
        2.0.1   - 2021-10-28 - optimized the frontmost switch and check algorithm which eliminates
                  the need for the switchAppDelay setting.
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
--                  valid defaults: chime, zoom, skype, teams, webex.
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


-- CONFIG: END



(*
** Determine current frontmost app.
*)
set frontApp to (path to frontmost application as text)


(*
** Figure out what teleconferencing apps are running.
*)
set the hasChime to false
set the hasZoom to false
set the hasSkype to false
set the hasTeams to false
set the hasWebex to false
set the hasFaceTime to false

tell application "System Events"
    set theList to get name of every process
    repeat with theItem in theList
        if the (theItem as string) is "Amazon Chime" then
            set the hasChime to true
        end if
        
        if the (theItem as string) is "zoom.us" then
            set the hasZoom to true
        end if
        
        if the (theItem as string) is "Skype" then
            set the hasSkype to true
        end if
        
        if the (theItem as string) is "Teams" then
            set the hasTeams to true
        end if
        
        if the (theItem as string) is "webexmta" then
            set the hasWebex to true
        end if

        if the (theItem as string) is "FaceTime" then
            set the hasFaceTime to true
        end if
    end repeat
end tell



(*
** Determine which key sequence we want to trigger based on preferences
** and what is actually running right now.
*)
global appl
global keyy
global modifier

global defaultApp
global hasChime
global hasZoom
global hasSkype
global hasTeams
global hasWebex
global hasFaceTime

if the prioritizeDefault is true
    detectAndSetDefault()
else
    if the defaultApp is not "chime" and the hasChime is true then
        setChimeKeys()
    else if the defaultApp is not "zoom" and the hasZoom is true then
        setZoomKeys()
    else if the defaultApp is not "skype" and the hasSkype is true then
        setSkypeKeys()
    else if the defaultApp is not "teams" and the hasTeams is true then
        setTeamsKeys()
    else if the defaultApp is not "webex" and the hasWebex is true then
        setWebexKeys()
    else if the defaultApp is not "FaceTime" and the hasFaceTime is true then
        setFaceTimeKeys()
    else
        detectAndSetDefault()
    end if
end if


(*
** Bring our target teleconferencing app to the foreground, send the key
** sequence, then bring the prior foreground app back to the front.
*)
if frontApp is not equal to appl then
    tell application appl
        reopen
        activate
    end tell
        
    repeat until application appl is frontmost
        delay 0.1
    end repeat
end if

tell application "System Events" to keystroke keyy using modifier

if frontApp is not equal to appl then
    tell application frontApp
        reopen
        activate
    end tell
end if



(*
** Set up the application names and key sequences as functions.
*)
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
    set appl to "Meeting Center"
    set keyy to "m"
    set modifier to {command down, shift down}
end setWebexKeys

on setSkypeKeys()
    set appl to "Skype"
    set keyy to "m"
    set modifier to {command down, shift down}
end setSkypeKeys

on setTeamsKeys()
    set appl to "Teams"
    set keyy to "m"
    set modifier to {command down, shift down}
end setTeamsKeys

on setFaceTimeKeys()
    set appl to "FaceTime"
    set keyy to "y"
    set modifier to command down
end setFaceTimeKeys


(*
** Find if the default app is running and if so, set the key sequence
** as appropriate for the default app.
*)
on detectAndSetDefault()
    if the defaultApp is "chime" and the hasChime is true then
        setChimeKeys()
    else if the defaultApp is "zoom" and the hasZoom is true then
        setZoomKeys()
    else if the defaultApp is "skype" and the hasSkype is true then
        setSkypeKeys()
    else if the defaultApp is "teams" and the hasTeams is true then
        setTeamsKeys()
    else if the defaultApp is "webex" and the hasWebex is true then
        setWebexKeys()
    else if the defaultApp is "FaceTime" and the hasFaceTime is true then
        setFaceTimeKeys()
    end if

    return false
end detectAndSetDefault


