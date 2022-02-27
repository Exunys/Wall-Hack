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
    Size = 12,
    Thickness = 1,
    Color = "0, 255, 0",
    Transparency = 1,
    GapSize = 5,
    CenterDot = false,
    CenterDotColor = "0, 255, 0",
    CenterDotSize = 1,
    CenterDotTransparency = 1,
    CenterDotFilled = true,
  },

  Parts = {
    LeftLine = getgenv().WallHack.Crosshair.CrosshairSettings.Parts.LeftLine,
    RightLine = getgenv().WallHack.Crosshair.CrosshairSettings.Parts.RightLine,
    TopLine = getgenv().WallHack.Crosshair.CrosshairSettings.Parts.TopLine,
    BottomLine = getgenv().WallHack.Crosshair.CrosshairSettings.Parts.BottomLine,
    CenterDot = getgenv().WallHack.Crosshair.CrosshairSettings.CenterDot
  }
}

getgenv().WallHack.Settings = {
    SendNotifications = true,
    Debug = true, -- Prints any errors / Informs if your exploit is supported
    SaveSettings = true, -- Re-execute upon changing
    ReloadOnTeleport = true,
    Enabled = true,
    TeamCheck = false,
    AliveCheck = true
}
