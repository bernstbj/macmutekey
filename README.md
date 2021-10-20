# MacMuteKey

![Picture of mute button](images/MuteButton.jpg)

Karabiner support for the mute keyboard device on macOS.

This solution was defined as a result of receiving a single-key mute keyboard from this manufacturer: [https://techkeys.us/collections/accessories/products/onekeyboard-mute-button-edition?variant=39598265598031](https://techkeys.us/collections/accessories/products/onekeyboard-mute-button-edition?variant=39598265598031) . The situation is that it was pre-programmed to send a Windows sequence and I needed it to send a Mac sequence. While there are simple solutions in macOS System Preferences to just swap control and command keys for a particular device, I leveraged Karabiner since I've been using that for years and also extended it to use an AppleScript to support mute when your video conferencing tool is not the foreground application.

Why is this on Github? Because Karabiner is unable to process files that come from internal websites (wiki, git, etc).

For help, contact me at briberns@ or brian@dronefone.com

**THIS README IS A WORK IN PROGRESS...**


## Support for Teleconferencing Apps

Current support:

Application | K-E Status | AppleScript Status | Comments
----------- | ---------- | ------------------ | --------
Amazon Chime | Working | Working |
Zoom | Working | Working | 
Microsoft Teams | ? | ? | Documentation says Command-Shift-M is (un)mute, but doesn't appear to have any keyboard shortcuts?
Skype | Testing | Testing | Need to validate with an actual call.
WebEx | Testing | Testing | Need to validate with an actual call.

### If you want support for another app...

I'm happy to add support for another teleconferencing application. Either raise a github ticket or send me an email as mentioned above. I need two things:

1. The name of the application.
2. What the application appears as to the Karabiner and AppleScript.
3. What is the key sequence to (un)mute the audio.


## Installation

coming soon.... check the intranet site


## Upgrading to New Release

coming soon, but for the most part you need to remove the MacMuteKey rules from Karabiner and then do the 'Installation' again. Most likely the Karabiner rules will go lockstep with the AppleScript, however, you can use the command line `what ~/.config/karabiner/sendMuteKeyToApps.scpt` to see what version it reports back and compare to what is noted as latest-and-greatest here.


As I said, work in progress....
