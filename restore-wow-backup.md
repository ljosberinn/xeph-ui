**Paths are always in relation to the `_retail_` folder (or whichever flavor you wanna restore a backup for).**


1. Start the Game and login to a character once.
  - installing the game only sets up the necessary folder structure for it to start. your macros and some CVars are stored server side, so logging into the game downloads and effectively restores those.
2. Close the game completely again. You can leave Battle.net open.

# Restore Game Settings

### Difficulty: Trivial
  - literally copy paste a single file into the correct folder
### Necessity: Low
  - while it doesn't hurt doing this, I'd recommend just redoing the settings, particularily Graphics following [this guide](https://github.com/tukui-org/ElvUI/wiki/performance-optimization).

In the `WTF` folder, make sure `Config.wtf` is present. If so, copy paste over your old `Config.wtf`, replacing the newly created one.

# Restore AddOns
### Difficulty: Trivial
  - copy pasting a bunch of folders from A to B
### Necessity: Medium
  - you likely have some addons installed you actually don't need. Reinstalling via CurseForge, WoWUp or similar is also easy because you have a list of addons. Take the time!

Verify the `Interface/AddOns` folder exists. If not, it's safe to create.

Copy paste the folders from the old `Interface/AddOns` folder into the new one. You're likely familiar with this.

If you reinstall via a client, make sure to not forget ~~P2Win~~ sub-only addons since those are only partially available.

# Restore Macros & AddOn State & Settings

### Difficulty: Severe
  - finnicky, buckle up
### Necessity: High

#### Macros & AddOn State

Macros should already be restored automatically after logging into your character(s). So make sure you logged into each character once and exited the game properly (no Alt-F4 etc.).

If not, here's how:
- in your backed up `WTF/Account` folder, there's a folder with either a number or your legacy Blizzard account name from ye olden times
- inside of that folder, there's folders for each realm you ever logged into as well as a `macros-cache.txt` and `macros-cache.old` file
  - move these files (`WTF/Account/macros-cache.txt` and `WTF/Account/macros-cache.old`) into the corresponding new folder
  - these are your global macros, not character specific
- now for the annoying part:
  - for each character that is missing its macros, go into the corresponding realm and then character folder
  - **due to Warbands, every realm folder has a subfolder for all your characters! make sure you're in the correct folder for this toon!**
  - e.g. `WTF/Account/12345/Blackrock/Xephyris` contains a `macros-cache.txt` and `macros-cache.old` file
  - copy paste the contents of the old file into the new one. again, **if the corresponding folder structure is missing for your fresh installation, log into the character first and let the game try to figure things out**
  - do the same with the `AddOns.txt`
    - this file holds info which addons are active for a character
  - if you have custom chat settings, do the same wtih `chat-cache.txt`

#### AddOn Settings
- in your backed up `WTF/Account/12345` folder, there's a `SavedVariables` folder
- copy paste this into the corresponding new folder
  - the files inside contain global addon settings, e.g. all your WeakAuras, MRT, RCLootCouncil etc.

- for each character, go into the corresponding realm and then character folder, just like above with Macros & AddOn State
  - if you skipped over above, make sure to read it regardless. the process is nearly identical, except different files
  - e.g. `WTF/Account/12345/Blackrock/Xephyris/SavedVariables`
  - copy paste the contents of the old file into the new one. again, **if the corresponding folder structure is missing for your fresh installation, log into the character first**

#### TLDR

- copy these from old to new. if the folder structure is missing, log into the character first
  - `WTF/Account/12345/REALM/CHARACTER/macros-cache.txt`
  - `WTF/Account/12345/REALM/CHARACTER/macros-cache.old`
  - `WTF/Account/12345/REALM/CHARACTER/AddOns.txt`
  - `WTF/Account/12345/REALM/CHARACTER/chat-cache.txt`
  - `WTF/Account/12345/REALM/CHARACTER/SavedVariables`
  - `WTF/Account/12345/macros-cache.txt`
  - `WTF/Account/12345/macros-cache.old`

# Restore Custom Sounds

If you were using the `SharedMedia` addon, you're already set up via above steps. If you have a `Sounds` folder in your old `Interface` folder, make sure to copy that over to the new one.

# Additional Links
- [Clean-Icons-Mechagnome-Edition](https://github.com/AcidWeb/Clean-Icons-Mechagnome-Edition/releases)
- [WCL Client](https://www.warcraftlogs.com/client/download)
- [Raider.IO Client](https://raider.io/addon)
- [CurseForge Client](https://www.curseforge.com/download/app#download-options)
- [WowUp Client](https://wowup.io/)
- [Wago Client](https://addons.wago.io/app)

# Further Resources

Technical in nature, largely for the curious and **likely outdated over time**.

- [How To Reduce WoW Loading Times](https://www.youtube.com/watch?v=jGvjgNXkSuw)
- [What Settings are killing your WoW FPS](https://www.youtube.com/watch?v=v4VljFsksmw)
- [What Addons are killing your WoW FPS](https://www.youtube.com/watch?v=G9eLjJlrC_M)