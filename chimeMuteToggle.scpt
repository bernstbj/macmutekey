--
-- chimeMuteToggle.scpt
--
-- Activates Chime, sends the mute toggle key sequence, and reactivates whatever was
-- foremost application if it wasn't Chime to begin with.
--
-- 2021-09-17, Brian J. Bernstein (briberns@)
--

on run params
	set frontApp to (path to frontmost application as text)
    set appl to "Amazon Chime"
    set keyy to "y"
    set modifier to command down
	
	if frontApp is not equal to appl then
		
		tell application appl
			reopen
			activate
		end tell
		
		repeat until application appl is running
			delay 1
		end repeat
		delay 0.5
	end if
	
    tell application "System Events" to keystroke keyy using modifier

	if frontApp is not equal to appl then
        tell application frontApp
            reopen
            activate
        end tell
    end if
	
end run
