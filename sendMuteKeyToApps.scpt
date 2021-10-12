(*
    @(#) sendMuteKeyToApps.scpt v2.0.0

    Sends the (un)mute key sequence to the conferencing tool determined to be in use.

    2021-10-11, Brian J. Bernstein
*)


-- CONFIG: START

-- prioritizeChime - Do we prioritize Chime as the receipient of (un)mute over other conference tools.
--
--                   if TRUE, then if we find Chime alongside other conference tools, then we will
--                   send mute sequences to Chime. This is if you always want Chime to receive mute
--                   sequences regardless of what else is running.
--
--                   if FALSE, we assume that other tools will get mute sequences if they are running.
--                   This is for those who always run Chime, but only run (say) Zoom when they need to
--                   and will close Zoom down when they're done, i.e. if we find a non-Chime tool running,
--                   then we assume that is the tool that needs to be (un)muted.
set the prioritizeChime to false

-- CONFIG: END




(* DETERMINE CURRENT FRONTMOST APP *)
set frontApp to (path to frontmost application as text)


(* FIGURE OUT WHAT APPS ARE RUNNING *)
set the hasChime to false
set the hasZoom to false
set the hasTeams to false
set the hasWebex to false

--tell application "System Events" to get name of every process
-- Cisco WebEx Start, Meeting Center, Teams, zoom.us
--copy "starting" to stdout
--display dialog "Starting"
tell application "System Events" -- to get name of every process
    set theList to get name of every process
    repeat with theItem in theList
        --        copy "item: " to stdout
        --        copy theItem to stdout
        -- display dialog "item: " & theItem
        if the (theItem as string) is "Amazon Chime" then
            set the hasChime to true
            --            display dialog "Found chime"
        end if
        
        if the (theItem as string) is "zoom.us" then
            set the hasZoom to true
            --            display dialog "found zoom"
        end if
        
        if the (theItem as string) is "Teams" then
            set the hasTeams to true
            --            display dialog "found teams"
        end if
        
        if the (theItem as string) is "webexmta" then
            set the hasWebex to true
            --            display dialog "found webex"
        end if
        
    end repeat
end tell

--display dialog "Has chime: " & hasChime


(* SEND UN/MUTE SEQUENCE TO DETERMINED APP *)
set appl to "Amazon Chime"
set keyy to "y"
set modifier to command down

if the prioritizeChime is true and the hasChime is true then
    -- appl, keyy, and modifier already set to chime by default
--    display dialog "Sending mute to chime"
else
    if the hasZoom is true then
        set appl to "zoom.us"
        set keyy to "a"
        set modifier to {command down, shift down}
        --display dialog "Sending mute to zoom"
    else if the hasWebex is true then
        set appl to "webexmta"
        set keyy to "m"
        set modifier to {command down, shift down}
        --display dialog "Sending mute to webex"
    else if the hasTeams is true then
        -- not sure if this is correct key sequence for teams?
        set appl to "Teams"
        set keyy to "m"
        set modifier to {command down, shift down}
        --display dialog "Sending mute to teams"
    else
    -- appl, keyy, and modifier already set to chime by default
        --display dialog "Sending mute to chime (because found nothing else running)"
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

    -- IF YOU ARE GETTING INCONSISTENT (UN)MUTE BEHAVIOR, TRY INCREASING THE VALUE
    -- BELOW FROM 0.1 TO 0.5 OR EVEN 1.0
    delay 0.1
end if

tell application "System Events" to keystroke keyy using modifier

if frontApp is not equal to appl then
    tell application frontApp
        reopen
        activate
    end tell
end if

