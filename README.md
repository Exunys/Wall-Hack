# Wall Hack
## Information
This project represents a collection of visuals / wall hacks (Tracers, ESP, Boxes (2D & 3D), Head Dots & Crosshair).
This script is also undetected because it uses [Synapse X's Drawing Library](https://x.synapse.to/docs/reference/drawing_lib.html).
### License
This project is completely free and open sourced. But, that does not mean you own rights to it. Read this [document](https://github.com/Exunys/Wall-Hack/blob/main/LICENSE) for more information.
You can re-use / stitch this script or any system of this project into any of your repositories, as long as you credit the developer [Exunys](https://github.com/Exunys).
## Notices
* This script will not run unless your exploit supports / includes these following functions / libraries:
  - `isfolder()`, `makefolder()` & `delfolder()`
  - `isfile()`, `writefile()` & `delfile()`
  - `Drawing`
  - `getgenv()`
  - `syn.queue_on_teleport()`
* This script will store your changed settings every 10 seconds passed or upon leaving. You can also disable this feature, tutorial on how will appear later on in this document.
* This script is indeed universal, but it might not run on games with specific character constructions (custom characters).
* A recommended exploit to run this script on is [Synapse X](https://x.synapse.to).
## Environment
The script's environment is stored as:
```lua
getgenv().WallHack
```
More on how to configure the visuals below this part.
## Configuration
This script includes settings which can be easily configured to your preference.
### Preview Of The Settings
```lua
getgenv().WallHack.Visuals = {
    ESPSettings = {
        Enabled = true,
        TextColor = "20, 90, 255",
        TextSize = 14,
        Center = true,
        Outline = true,
        OutlineColor = "0, 0, 0",
        TextTransparency = 0.7,
        TextFont = Drawing.Fonts.Monospace, -- UI, System, Plex, Monospace
        DisplayDistance = true,
        DisplayHealth = true,
        DisplayName = true
    },

    TracersSettings = {
        Enabled = true,
        Type = 1, -- 1 - Bottom; 2 - Center; 3 - Mouse
        Transparency = 0.7,
        Thickness = 1,
        Color = "50, 120, 255"
    },

    BoxSettings = {
        Enabled = true,
        Type = 1; -- 1 - 3D; 2 - 2D;
        Color = "50, 120, 255",
        Transparency = 0.7,
        Thickness = 1,
        Filled = false, -- For 2D
        Increase = 1
    },

    HeadDotSettings = {
        Enabled = true,
        Color = "50, 120, 255",
        Transparency = 0.5,
        Thickness = 1,
        Filled = true,
        Sides = 30,
        Size = 2
    }
}

getgenv().WallHack.Crosshair = {
    CrosshairSettings = {
        Enabled = true,
        Type = 1, -- 1 - Mouse; 2 - Center
        Color = "255, 255, 255",
        Transparency = 1,
        Thickness = 1,
        Size = 20
    },

    Parts = {
        X = getgenv().WallHack.Crosshair.CrosshairSettings.Parts.X,
        Y = getgenv().WallHack.Crosshair.CrosshairSettings.Parts.Y
    }
}

getgenv().WallHack.Settings = {
    SendNotifications = true,
    SaveSettings = true, -- Re-execute upon changing
    ReloadOnTeleport = true,
    Enabled = true,
    TeamCheck = false,
    AliveCheck = true
}
```
* You can also find the JSON format (which is the way they get stored) [here](https://github.com/Exunys/Wall-Hack/tree/main/Resources/Settings).
* The Lua format of the settings / the factory reset script can be found [here](https://github.com/Exunys/Wall-Hack/blob/main/Resources/Scripts/Manual%20Factory%20Reset%20Settings.lua).

By reading the visual representation of the configuration part of the environment table, it should be pretty easy to configure the script afterwards. Here are some examples:

### Script Examples

The following script will disable the visuals temporarily: 
```lua
getgenv().WallHack.Settings.Enabled = false
```
You can also change the color of some type of visual, say, tracers:
```lua
getgenv().WallHack.Visuals.TracersSettings.Color = "50, 255, 70" -- The colors must be fed as strings in RGB format. [(R)ed (0 - 255); (G)reen (0 - 255); (B)lue (0 - 255)]
```
**The script only accepts RGB configurations in strings as colors, if you input anything else, the script will break and not execute. Read below on how to fix this.**

You can also disable some visual incase you don't find it useful / don't need it:
```lua
getgenv().WallHack.Visuals.ESPSettings.Enabled = false
```
The options are endless, you can configure the visuals in any way you desire.

Read about the input types and more information about the drawing library in use for the visuals (to learn how to configure them) [here](https://x.synapse.to/docs/reference/drawing_lib.html).
## Fixes
If the script is not running upon execution, try a few of the solutions below:
### Solutions
* There is possibly a configuration that is unacceptable at most cases. Execute [this script](https://github.com/Exunys/Wall-Hack/blob/main/Resources/Scripts/Delete%20Settings%20-%20Fix%20Script.lua) and restart your game for changes to take effect.
* Open your exploit's root folder, find a folder named `workspace` and look for a folder named `Exunys Developer`. Once you find it, delete this folder and restart your game.

If none of these solutions work, check if your exploit is supported (read the **Notices** part). If the script still doesn't work, contact Exunys & report the problem you are experiencing in detail.

Check if your exploit is supported [here](https://github.com/Exunys/Wall-Hack/blob/main/Resources/Scripts/Support%20Checker.lua).
## Functions
This script includes built-in functions to control the Wall Hack.
The functions can be accessed by indexing **Functions** in the Environment. Example:
```lua
getgenv().WallHack.Functions
```
### Their purposes
* `Functions:Exit()`
  - Exits (unexecutes) the script and leaves no traces back.
* `Functions:Restart()`
  - Restarts the script, good for incase the script starts lagging.
* `Functions:ResetSettings()`
  - Factory resets the settings and wipes the previous ones that were saved to the workspace.

- Exit
```lua
getgenv().WallHack.Functions:Exit()
```
- Restart
```lua
getgenv().WallHack.Functions:Restart()
```
- Reset Settings
```lua
getgenv().WallHack.Functions:ResetSettings()
```
## Previews
![Untitled](https://user-images.githubusercontent.com/76539058/146678421-5ad0c836-e004-4c1a-87e2-acaad9e7ab5d.png)

![Untitled2](https://user-images.githubusercontent.com/76539058/146678599-c1d4fc84-ce9d-4d26-8346-0b703f2bf280.png)

Settings for the picture above:
```lua
getgenv().WallHack.Visuals.ESPSettings.Enabled = false
getgenv().WallHack.Visuals.TracersSettings.Type = 3
getgenv().WallHack.Visuals.BoxSettings.Type = 2
getgenv().WallHack.Visuals.HeadDotSettings.Color = "255, 50, 50"
getgenv().WallHack.Visuals.BoxSettings.Color = "100, 255, 100"
getgenv().WallHack.Visuals.TracersSettings.Color = "150, 40, 60"
```

![Untitled3](https://user-images.githubusercontent.com/76539058/146678839-fdd1730c-11e0-40ac-bd18-0d535020ad4e.png)

Settings for the picture above:
```lua
getgenv().WallHack.Visuals.ESPSettings.DisplayName = false
getgenv().WallHack.Visuals.ESPSettings.DisplayHealth = false
getgenv().WallHack.Visuals.ESPSettings.TextColor = "255, 50, 255"
getgenv().WallHack.Visuals.ESPSettings.Outline = false
getgenv().WallHack.Visuals.TracersSettings.Enabled = false
getgenv().WallHack.Visuals.BoxSettings.Type = 2
getgenv().WallHack.Visuals.HeadDotSettings.Color = "200, 50, 200"
getgenv().WallHack.Visuals.BoxSettings.Color = "200, 50, 200"
```

https://user-images.githubusercontent.com/76539058/146678683-96f439e6-16ee-4da5-b56d-eb90299d5168.mp4

The video above presents the `Environment.Functions:ResetSettings()` function. Read the **Functions** part for more.
```lua
getgenv().WallHack.Functions:ResetSettings()
```

https://user-images.githubusercontent.com/76539058/146678929-9ad25367-e25c-477e-996b-bb7683c1f8b4.mp4

The video above presents the `Environment.Functions:Exit()` function. Read the **Functions** part for more.
```lua
getgenv().WallHack.Functions:Exit()
```
## Script
Load the script by copying it from [here](https://github.com/Exunys/Wall-Hack/blob/main/Resources/Scripts/Main.lua) or by executing the code below.
```lua
--// Script

loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Wall-Hack/main/Resources/Scripts/Main.lua"))()

--// Script / Global Settings

getgenv().WallHack.Settings.Enabled = true
getgenv().WallHack.Settings.TeamCheck = false
getgenv().WallHack.Settings.AliveCheck = true

--// Visuals Settings

getgenv().Wallhack.Visuals.ESPSettings.Enabled = true
getgenv().Wallhack.Visuals.TracersSettings.Enabled = true
getgenv().Wallhack.Visuals.BoxSettings.Enabled = true
getgenv().Wallhack.Visuals.HeadDotSettings.Enabled = true

--// Crosshair

getgenv().Wallhack.Crosshair.CrosshairSettings.Enabled = true
```
## Contact Information
- [Email](mailto:exunys@gmail.com)
- [Discord](https://discord.com/users/611111398818316309)
- [Roblox](https://www.roblox.com/users/330279990/profile)
