--// Preventing Multiple Processes

pcall(function()
    getgenv().WallHack.Functions:Exit()
end)

--// Environment

getgenv().WallHack = {}
local Environment = getgenv().WallHack

--// Services

local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera

--// Variables

local LocalPlayer = Players.LocalPlayer
local Title = "Exunys Developer"
local FileNames = {"Wall Hack", "Configuration.json", "Visuals.json", "Crosshair.json"}
local ServiceConnections = {}

--// Cached Functions

local tonumber, tostring, next, pcall, type, loadstring = tonumber, tostring, next, pcall, type, loadstring
local Color3fromRGB, Vector2new, Vector3new, Drawingnew = Color3.fromRGB, Vector2.new, Vector3.new, Drawing.new
local stringmatch = string.match
local mathfloor = math.floor
local coroutinewrap = coroutine.wrap

--// Script Settings

Environment.WrappedPlayers = {}

loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Wall-Hack/main/Resources/Scripts/Manual%20Factory%20Reset%20Settings.lua"))()

Environment.Crosshair.Parts = {
    LeftLine = Drawingnew("Line"),
    RightLine = Drawingnew("Line"),
    TopLine = Drawingnew("Line"),
    BottomLine = Drawingnew("Line"),
    CenterDot = Drawingnew("Circle")
}

--// Core Functions

local function Encode(Table)
    if Table and type(Table) == "table" then
        local EncodedTable = HttpService:JSONEncode(Table)

        return EncodedTable
    end
end

local function Decode(String)
    if String and type(String) == "string" then
        local DecodedTable = HttpService:JSONDecode(String)

        return DecodedTable
    end
end

local function SendNotification(TitleArg, DescriptionArg, DurationArg)
    if Environment.Settings.SendNotifications then
        StarterGui:SetCore("SendNotification", {
            Title = TitleArg,
            Text = DescriptionArg,
            Duration = DurationArg
        })
    end
end

local function GetColor(Color)
    local R = tonumber(stringmatch(Color, "([%d]+)[%s]*,[%s]*[%d]+[%s]*,[%s]*[%d]+"))
    local G = tonumber(stringmatch(Color, "[%d]+[%s]*,[%s]*([%d]+)[%s]*,[%s]*[%d]+"))
    local B = tonumber(stringmatch(Color, "[%d]+[%s]*,[%s]*[%d]+[%s]*,[%s]*([%d]+)"))

    return Color3fromRGB(R, G, B)
end

local function GetPlayerTable(Player)
    for _, v in next, Environment.WrappedPlayers do
        if v.Name == Player.Name then
            return v
        end
    end
end

--// Visuals

local function AddESP(Player)
    local PlayerTable = GetPlayerTable(Player)

    PlayerTable.ESP = Drawingnew("Text")

    PlayerTable.Connections.ESP = RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("Head") and Player.Character:FindFirstChild("HumanoidRootPart") and Environment.Settings.Enabled then
            local Vector, OnScreen = Camera:WorldToViewportPoint(Player.Character.Head.Position)

            PlayerTable.ESP.Visible = Environment.Visuals.ESPSettings.Enabled

            local function UpdateESP()
                PlayerTable.ESP.Size = Environment.Visuals.ESPSettings.TextSize
                PlayerTable.ESP.Center = Environment.Visuals.ESPSettings.Center
                PlayerTable.ESP.Outline = Environment.Visuals.ESPSettings.Outline
                PlayerTable.ESP.OutlineColor = GetColor(Environment.Visuals.ESPSettings.OutlineColor)
                PlayerTable.ESP.Color = GetColor(Environment.Visuals.ESPSettings.TextColor)
                PlayerTable.ESP.Transparency = Environment.Visuals.ESPSettings.TextTransparency
                PlayerTable.ESP.Font = Environment.Visuals.ESPSettings.TextFont

                PlayerTable.ESP.Position = Vector2new(Vector.X, Vector.Y - 25)

                local Parts = {
                    Health = "("..tostring(Player.Character.Humanoid.Health)..")",
                    Distance = "["..tostring(mathfloor((Player.Character.HumanoidRootPart.Position - (LocalPlayer.Character.HumanoidRootPart.Position or Vector3new(0, 0, 0))).Magnitude)).."]",
                    Name = Player.Name
                }

                local Content = ""

                if Environment.Visuals.ESPSettings.DisplayName then
                    Content = Parts.Name..Content
                end

                if Environment.Visuals.ESPSettings.DisplayHealth then
                    if Environment.Visuals.ESPSettings.DisplayName then
                        Content = Parts.Health.." "..Content
                    else
                        Content = Parts.Health..Content
                    end
                end

                if Environment.Visuals.ESPSettings.DisplayDistance then
                    Content = Content.." "..Parts.Distance
                end

                PlayerTable.ESP.Text = Content
            end

            if OnScreen then
                if Environment.Visuals.ESPSettings.Enabled then
                    local Checks = {Alive = true, Team = true}

                    if Environment.Settings.AliveCheck then
                        Checks.Alive = (Player.Character:FindFirstChild("Humanoid").Health > 0)
                    else
                        Checks.Alive = true
                    end

                    if Environment.Settings.TeamCheck then
                        Checks.Team = (Player.TeamColor ~= LocalPlayer.TeamColor)
                    else
                        Checks.Team = true
                    end

                    if Checks.Alive and Checks.Team then
                        PlayerTable.ESP.Visible = true
                    else
                        PlayerTable.ESP.Visible = false
                    end

                    if PlayerTable.ESP.Visible then
                        UpdateESP()
                    end
                end
            else
                PlayerTable.ESP.Visible = false
            end
        else
            PlayerTable.ESP.Visible = false
        end
    end)
end

local function AddTracer(Player)
    local PlayerTable = GetPlayerTable(Player)

    PlayerTable.Tracer = Drawingnew("Line")

    PlayerTable.Connections.Tracer = RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") and Environment.Settings.Enabled then
            local HRPCFrame, HRPSize = Player.Character.HumanoidRootPart.CFrame, Player.Character.HumanoidRootPart.Size
            local Vector, OnScreen = Camera:WorldToViewportPoint(HRPCFrame * CFrame.new(0, -HRPSize.Y, 0).Position)

            PlayerTable.Tracer.Visible = Environment.Visuals.TracersSettings.Enabled

            local function UpdateTracer()
                PlayerTable.Tracer.Thickness = Environment.Visuals.TracersSettings.Thickness
                PlayerTable.Tracer.Color = GetColor(Environment.Visuals.TracersSettings.Color)
                PlayerTable.Tracer.Transparency = Environment.Visuals.TracersSettings.Transparency

                PlayerTable.Tracer.To = Vector2new(Vector.X, Vector.Y)

                if Environment.Visuals.TracersSettings.Type == 1 then
                    PlayerTable.Tracer.From = Vector2new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                elseif Environment.Visuals.TracersSettings.Type == 2 then
                    PlayerTable.Tracer.From = Vector2new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                elseif Environment.Visuals.TracersSettings.Type == 3 then
                    PlayerTable.Tracer.From = Vector2new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                else
                    PlayerTable.Tracer.From = Vector2new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                end
            end

            if OnScreen then
                if Environment.Visuals.TracersSettings.Enabled then
                    local Checks = {Alive = true, Team = true}

                    if Environment.Settings.AliveCheck then
                        Checks.Alive = (Player.Character:FindFirstChild("Humanoid").Health > 0)
                    else
                        Checks.Alive = true
                    end

                    if Environment.Settings.TeamCheck then
                        Checks.Team = (Player.TeamColor ~= LocalPlayer.TeamColor)
                    else
                        Checks.Team = true
                    end

                    if Checks.Alive and Checks.Team then
                        PlayerTable.Tracer.Visible = true
                    else
                        PlayerTable.Tracer.Visible = false
                    end

                    if PlayerTable.Tracer.Visible then
                        UpdateTracer()
                    end
                end
            else
                PlayerTable.Tracer.Visible = false
            end
        else
            PlayerTable.Tracer.Visible = false
        end
    end)
end

local function AddBox(Player)
    local PlayerTable = GetPlayerTable(Player)

    PlayerTable.Box.Square = Drawingnew("Square")

    PlayerTable.Box.TopLeftLine = Drawingnew("Line")
    PlayerTable.Box.TopLeftLine = Drawingnew("Line")
    PlayerTable.Box.TopRightLine = Drawingnew("Line")
    PlayerTable.Box.BottomLeftLine = Drawingnew("Line")
    PlayerTable.Box.BottomRightLine = Drawingnew("Line")

    PlayerTable.Connections.Box = RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("Head") and Player.Character:FindFirstChild("HumanoidRootPart") and Environment.Settings.Enabled then
            local Vector, OnScreen = Camera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position)

            local HRPCFrame, HRPSize = Player.Character.HumanoidRootPart.CFrame, Player.Character.HumanoidRootPart.Size * Environment.Visuals.BoxSettings.Increase

            local TopLeftPosition = Camera:WorldToViewportPoint(HRPCFrame * CFrame.new(HRPSize.X,  HRPSize.Y, 0).Position)
            local TopRightPosition = Camera:WorldToViewportPoint(HRPCFrame * CFrame.new(-HRPSize.X,  HRPSize.Y, 0).Position)
            local BottomLeftPosition = Camera:WorldToViewportPoint(HRPCFrame * CFrame.new(HRPSize.X, -HRPSize.Y, 0).Position)
            local BottomRightPosition = Camera:WorldToViewportPoint(HRPCFrame * CFrame.new(-HRPSize.X, -HRPSize.Y, 0).Position)

            local HeadOffset = Camera:WorldToViewportPoint(Player.Character.Head.Position + Vector3new(0, 0.5, 0))
			local LegsOffset = Camera:WorldToViewportPoint(Player.Character.HumanoidRootPart.Position - Vector3new(0, 3, 0))

            local function Visibility(Bool)
                if Environment.Visuals.BoxSettings.Type == 1 then
                    PlayerTable.Box.Square.Visible = not Bool

                    PlayerTable.Box.TopLeftLine.Visible = Bool
                    PlayerTable.Box.TopRightLine.Visible = Bool
                    PlayerTable.Box.BottomLeftLine.Visible = Bool
                    PlayerTable.Box.BottomRightLine.Visible = Bool
                elseif Environment.Visuals.BoxSettings.Type == 2 then
                    PlayerTable.Box.Square.Visible = Bool

                    PlayerTable.Box.TopLeftLine.Visible = not Bool
                    PlayerTable.Box.TopRightLine.Visible = not Bool
                    PlayerTable.Box.BottomLeftLine.Visible = not Bool
                    PlayerTable.Box.BottomRightLine.Visible = not Bool
                end
            end

            local function Visibility2(Bool)
                PlayerTable.Box.Square.Visible = Bool

                PlayerTable.Box.TopLeftLine.Visible = Bool
                PlayerTable.Box.TopRightLine.Visible = Bool
                PlayerTable.Box.BottomLeftLine.Visible = Bool
                PlayerTable.Box.BottomRightLine.Visible = Bool
            end

            Visibility(Environment.Visuals.BoxSettings.Enabled)

            local function Update2DBox()
                PlayerTable.Box.Square.Thickness = Environment.Visuals.BoxSettings.Thickness
                PlayerTable.Box.Square.Color = GetColor(Environment.Visuals.BoxSettings.Color)
                PlayerTable.Box.Square.Transparency = Environment.Visuals.BoxSettings.Transparency
                PlayerTable.Box.Square.Filled = Environment.Visuals.BoxSettings.Filled

                PlayerTable.Box.Square.Size = Vector2new(2000 / Vector.Z, HeadOffset.Y - LegsOffset.Y)
				PlayerTable.Box.Square.Position = Vector2new(Vector.X - PlayerTable.Box.Square.Size.X / 2, Vector.Y - PlayerTable.Box.Square.Size.Y / 2)
            end

            local function Update3DBox()
                PlayerTable.Box.TopLeftLine.Thickness = Environment.Visuals.BoxSettings.Thickness
                PlayerTable.Box.TopLeftLine.Transparency = Environment.Visuals.BoxSettings.Transparency
                PlayerTable.Box.TopLeftLine.Color = GetColor(Environment.Visuals.BoxSettings.Color)

                PlayerTable.Box.TopRightLine.Thickness = Environment.Visuals.BoxSettings.Thickness
                PlayerTable.Box.TopRightLine.Transparency = Environment.Visuals.BoxSettings.Transparency
                PlayerTable.Box.TopRightLine.Color = GetColor(Environment.Visuals.BoxSettings.Color)

                PlayerTable.Box.BottomLeftLine.Thickness = Environment.Visuals.BoxSettings.Thickness
                PlayerTable.Box.BottomLeftLine.Transparency = Environment.Visuals.BoxSettings.Transparency
                PlayerTable.Box.BottomLeftLine.Color = GetColor(Environment.Visuals.BoxSettings.Color)

                PlayerTable.Box.BottomRightLine.Thickness = Environment.Visuals.BoxSettings.Thickness
                PlayerTable.Box.BottomRightLine.Transparency = Environment.Visuals.BoxSettings.Transparency
                PlayerTable.Box.BottomRightLine.Color = GetColor(Environment.Visuals.BoxSettings.Color)

                PlayerTable.Box.TopLeftLine.From = Vector2new(TopLeftPosition.X, TopLeftPosition.Y)
                PlayerTable.Box.TopLeftLine.To = Vector2new(TopRightPosition.X, TopRightPosition.Y)

                PlayerTable.Box.TopRightLine.From = Vector2new(TopRightPosition.X, TopRightPosition.Y)
                PlayerTable.Box.TopRightLine.To = Vector2new(BottomRightPosition.X, BottomRightPosition.Y)

                PlayerTable.Box.BottomLeftLine.From = Vector2new(BottomLeftPosition.X, BottomLeftPosition.Y)
                PlayerTable.Box.BottomLeftLine.To = Vector2new(TopLeftPosition.X, TopLeftPosition.Y)

                PlayerTable.Box.BottomRightLine.From = Vector2new(BottomRightPosition.X, BottomRightPosition.Y)
                PlayerTable.Box.BottomRightLine.To = Vector2new(BottomLeftPosition.X, BottomLeftPosition.Y)
            end

            if OnScreen then
                if Environment.Visuals.BoxSettings.Enabled then
                    local Checks = {Alive = true, Team = true}

                    if Environment.Settings.AliveCheck then
                        Checks.Alive = (Player.Character:FindFirstChild("Humanoid").Health > 0)
                    else
                        Checks.Alive = true
                    end

                    if Environment.Settings.TeamCheck then
                        Checks.Team = (Player.TeamColor ~= LocalPlayer.TeamColor)
                    else
                        Checks.Team = true
                    end

                    if Checks.Alive and Checks.Team then
                        Visibility(true)
                    else
                        Visibility2(false)
                    end

                    if PlayerTable.Box.Square.Visible and not PlayerTable.Box.TopLeftLine.Visible and not PlayerTable.Box.TopRightLine.Visible and not PlayerTable.Box.BottomLeftLine.Visible and not PlayerTable.Box.BottomRightLine.Visible then
                        Update2DBox()
                    elseif not PlayerTable.Box.Square.Visible and PlayerTable.Box.TopLeftLine.Visible and PlayerTable.Box.TopRightLine.Visible and PlayerTable.Box.BottomLeftLine.Visible and PlayerTable.Box.BottomRightLine.Visible then
                        Update3DBox()
                    end
                end
            else
                PlayerTable.Box.Square.Visible = false
                PlayerTable.Box.TopLeftLine.Visible = false
                PlayerTable.Box.TopRightLine.Visible = false
                PlayerTable.Box.BottomLeftLine.Visible = false
                PlayerTable.Box.BottomRightLine.Visible = false
            end
        else
            PlayerTable.Box.Square.Visible = false
            PlayerTable.Box.TopLeftLine.Visible = false
            PlayerTable.Box.TopRightLine.Visible = false
            PlayerTable.Box.BottomLeftLine.Visible = false
            PlayerTable.Box.BottomRightLine.Visible = false
        end
    end)
end

local function AddHeadDot(Player)
    local PlayerTable = GetPlayerTable(Player)

    PlayerTable.HeadDot = Drawingnew("Circle")

    PlayerTable.Connections.HeadDot = RunService.RenderStepped:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("Head") and Environment.Settings.Enabled then
            local Vector, OnScreen = Camera:WorldToViewportPoint(Player.Character.Head.Position)

            PlayerTable.HeadDot.Visible = Environment.Visuals.HeadDotSettings.Enabled

            local function UpdateHeadDot()
                PlayerTable.HeadDot.Thickness = Environment.Visuals.HeadDotSettings.Thickness
                PlayerTable.HeadDot.Color = GetColor(Environment.Visuals.HeadDotSettings.Color)
                PlayerTable.HeadDot.Transparency = Environment.Visuals.HeadDotSettings.Transparency
                PlayerTable.HeadDot.NumSides = Environment.Visuals.HeadDotSettings.Sides
                PlayerTable.HeadDot.Filled = Environment.Visuals.HeadDotSettings.Filled
                PlayerTable.HeadDot.Radius = Environment.Visuals.HeadDotSettings.Size

                PlayerTable.HeadDot.Position = Vector2new(Vector.X, Vector.Y)
            end

            if OnScreen then
                if Environment.Visuals.HeadDotSettings.Enabled then
                    local Checks = {Alive = true, Team = true}

                    if Environment.Settings.AliveCheck then
                        Checks.Alive = (Player.Character:FindFirstChild("Humanoid").Health > 0)
                    else
                        Checks.Alive = true
                    end

                    if Environment.Settings.TeamCheck then
                        Checks.Team = (Player.TeamColor ~= LocalPlayer.TeamColor)
                    else
                        Checks.Team = true
                    end

                    if Checks.Alive and Checks.Team then
                        PlayerTable.HeadDot.Visible = true
                    else
                        PlayerTable.HeadDot.Visible = false
                    end

                    if PlayerTable.HeadDot.Visible then
                        UpdateHeadDot()
                    end
                end
            else
                PlayerTable.HeadDot.Visible = false
            end
        else
            PlayerTable.HeadDot.Visible = false
        end
    end)
end

local function AddCrosshair()
    local AxisX, AxisY = nil, nil

    pcall(function()
        ServiceConnections.AxisConnection, ServiceConnections.CrosshairConnection = RunService.RenderStepped:Connect(function()
            if Environment.Crosshair.CrosshairSettings.Type == 1 then
                AxisX, AxisY = UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y
            elseif Environment.Crosshair.CrosshairSettings.Type == 2 then
                AxisX, AxisY = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2
            else
                Environment.Crosshair.CrosshairSettings.Type = 1
            end
        end), RunService.RenderStepped:Connect(function()

            repeat wait() until AxisX and AxisY

            --// Left Line

            Environment.Crosshair.Parts.LeftLine.Visible = Environment.Settings.Enabled
            Environment.Crosshair.Parts.LeftLine.Color = GetColor(Environment.Crosshair.CrosshairSettings.Color)
            Environment.Crosshair.Parts.LeftLine.Thickness = Environment.Crosshair.CrosshairSettings.Thickness
            Environment.Crosshair.Parts.LeftLine.Transparency = Environment.Crosshair.CrosshairSettings.Transparency

            Environment.Crosshair.Parts.LeftLine.From = Vector2new(AxisX + Environment.Crosshair.CrosshairSettings.GapSize, AxisY)
            Environment.Crosshair.Parts.LeftLine.To = Vector2new(AxisX + Environment.Crosshair.CrosshairSettings.Size, AxisY)

            --// Right Line

            Environment.Crosshair.Parts.RightLine.Visible = Environment.Settings.Enabled
            Environment.Crosshair.Parts.RightLine.Color = GetColor(Environment.Crosshair.CrosshairSettings.Color)
            Environment.Crosshair.Parts.RightLine.Thickness = Environment.Crosshair.CrosshairSettings.Thickness
            Environment.Crosshair.Parts.RightLine.Transparency = Environment.Crosshair.CrosshairSettings.Transparency

            Environment.Crosshair.Parts.RightLine.From = Vector2new(AxisX - Environment.Crosshair.CrosshairSettings.GapSize, AxisY)
            Environment.Crosshair.Parts.RightLine.To = Vector2new(AxisX - Environment.Crosshair.CrosshairSettings.Size, AxisY)

            --// Top Line

            Environment.Crosshair.Parts.TopLine.Visible = Environment.Settings.Enabled
            Environment.Crosshair.Parts.TopLine.Color = GetColor(Environment.Crosshair.CrosshairSettings.Color)
            Environment.Crosshair.Parts.TopLine.Thickness = Environment.Crosshair.CrosshairSettings.Thickness
            Environment.Crosshair.Parts.TopLine.Transparency = Environment.Crosshair.CrosshairSettings.Transparency

            Environment.Crosshair.Parts.TopLine.From = Vector2new(AxisX, AxisY + Environment.Crosshair.CrosshairSettings.GapSize)
            Environment.Crosshair.Parts.TopLine.To = Vector2new(AxisX, AxisY + Environment.Crosshair.CrosshairSettings.Size)

            --// Bottom Line

            Environment.Crosshair.Parts.BottomLine.Visible = Environment.Settings.Enabled
            Environment.Crosshair.Parts.BottomLine.Color = GetColor(Environment.Crosshair.CrosshairSettings.Color)
            Environment.Crosshair.Parts.BottomLine.Thickness = Environment.Crosshair.CrosshairSettings.Thickness
            Environment.Crosshair.Parts.BottomLine.Transparency = Environment.Crosshair.CrosshairSettings.Transparency

            Environment.Crosshair.Parts.BottomLine.From = Vector2new(AxisX, AxisY - Environment.Crosshair.CrosshairSettings.GapSize)
            Environment.Crosshair.Parts.BottomLine.To = Vector2new(AxisX, AxisY - Environment.Crosshair.CrosshairSettings.Size)

            --// Center Dot

            Environment.Crosshair.Parts.CenterDot.Visible = Environment.Settings.Enabled and Environment.Crosshair.CrosshairSettings.CenterDot
            Environment.Crosshair.Parts.CenterDot.Color = GetColor(Environment.Crosshair.CrosshairSettings.CenterDotColor)
            Environment.Crosshair.Parts.CenterDot.Radius = Environment.Crosshair.CrosshairSettings.CenterDotSize
            Environment.Crosshair.Parts.CenterDot.Transparency = Environment.Crosshair.CrosshairSettings.CenterDotTransparency
            Environment.Crosshair.Parts.CenterDot.Filled = Environment.Crosshair.CrosshairSettings.CenterDotFilled

            Environment.Crosshair.Parts.CenterDot.Position = Vector2new(AxisX, AxisY)
        end)
    end)
end

--// Functions

local function SaveSettings()
    if isfile(Title.."/"..FileNames[1].."/"..FileNames[2]) then
        writefile(Title.."/"..FileNames[1].."/"..FileNames[2], Encode(Environment.Settings))
    end

    if isfile(Title.."/"..FileNames[1].."/"..FileNames[3]) then
        writefile(Title.."/"..FileNames[1].."/"..FileNames[3], Encode(Environment.Visuals))
    end

    if isfile(Title.."/"..FileNames[1].."/"..FileNames[4]) then
        writefile(Title.."/"..FileNames[1].."/"..FileNames[4], Encode(Environment.Crosshair.CrosshairSettings))
    end
end

local function Wrap(Player)
    local Table, Value = nil, {Name = Player.Name, Connections = {}, ESP = nil, Tracer = nil, HeadDot = nil, Box = {Square = nil, TopLeftLine = nil, TopRightLine = nil, BottomLeftLine = nil, BottomRightLine = nil}}

    for _, v in next, Environment.WrappedPlayers do
        if v[1] == Player.Name then
            Table = v
        end
    end

    if not Table then
        Environment.WrappedPlayers[#Environment.WrappedPlayers + 1] = Value

        AddESP(Player)
        AddTracer(Player)
        AddBox(Player)
        AddHeadDot(Player)
        AddCrosshair()
    end
end

local function UnWrap(Player)
    local Table, Index = nil, nil

    for i, v in next, Environment.WrappedPlayers do
        if v.Name == Player.Name then
            Table, Index = v, i
        end
    end

    if Table then
        for _, v in next, Table.Connections do
            v:Disconnect()
        end

        Table.ESP:Remove()
        Table.Tracer:Remove()
        Table.HeadDot:Remove()

        for _, v in next, Table.Box do
            v:Remove()
        end

        Environment.WrappedPlayers[Index] = nil
    end
end

local function Load()
    for _, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer then
            UnWrap(v)
        end
    end

    for _, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer then
            Wrap(v)
        end
    end

    ServiceConnections.PlayerAddedConnection = Players.PlayerAdded:Connect(function(v)
        if v ~= LocalPlayer then
            Wrap(v)
        end
    end)

    ServiceConnections.PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(v)
        if v ~= LocalPlayer then
            UnWrap(v)
        else
            SaveSettings()
        end
    end)
end

--// Create, Save & Load Settings

if Environment.Settings.SaveSettings then
    if not isfolder(Title) then
        makefolder(Title)
    end

    if not isfolder(Title.."/"..FileNames[1]) then
        makefolder(Title.."/"..FileNames[1])
    end

    if not isfile(Title.."/"..FileNames[1].."/"..FileNames[2]) then
        writefile(Title.."/"..FileNames[1].."/"..FileNames[2], Encode(Environment.Settings))
    else
        Environment.Settings = Decode(readfile(Title.."/"..FileNames[1].."/"..FileNames[2]))
    end

    if not isfile(Title.."/"..FileNames[1].."/"..FileNames[3]) then
        writefile(Title.."/"..FileNames[1].."/"..FileNames[3], Encode(Environment.Visuals))
    else
        Environment.Visuals = Decode(readfile(Title.."/"..FileNames[1].."/"..FileNames[3]))
    end

    if not isfile(Title.."/"..FileNames[1].."/"..FileNames[4]) then
        writefile(Title.."/"..FileNames[1].."/"..FileNames[4], Encode(Environment.Crosshair.CrosshairSettings))
    else
        Environment.Crosshair.CrosshairSettings = Decode(readfile(Title.."/"..FileNames[1].."/"..FileNames[4]))
    end

    coroutinewrap(function()
        while wait(10) do
            SaveSettings()
        end
    end)()
else
    if isfolder(Title) then
        delfolder(Title)
    end
end

--// API Check

if not Drawing or not writefile or not makefolder then
    SendNotification(Title, "Your exploit does not support this script", 3); return
end

--// Script Functions

Environment.Functions = {}

function Environment.Functions:Exit()
    SaveSettings()

    for _, v in next, ServiceConnections do
        v:Disconnect()
    end

    for _, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer then
            UnWrap(v)
        end
    end

    for _, v in next, Environment.Crosshair.Parts do
        v:Remove()
    end

    getgenv().WallHack = nil
end

function Environment.Functions:Restart()
    SaveSettings()

    for _, v in next, ServiceConnections do
        v:Disconnect()
    end

    for _, v in next, Players:GetPlayers() do
        if v ~= LocalPlayer then
            UnWrap(v)
        end
    end

    for _, v in next, Environment.Crosshair.Parts do
        v:Remove()
    end

    Load()
end

function Environment.Functions:ResetSettings()
    local Parts = {
        LeftLine = Environment.Crosshair.Parts.LeftLine,
        RightLine = Environment.Crosshair.Parts.RightLine,
        TopLine = Environment.Crosshair.Parts.TopLine,
        BottomLine = Environment.Crosshair.Parts.BottomLine,
        CenterDot = Environment.Crosshair.Parts.CenterDot
    }

    loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Wall-Hack/main/Resources/Scripts/Manual%20Factory%20Reset%20Settings.lua"))()
    
    Environment.Crosshair.Parts = Parts

    SaveSettings()
end

function Environment.Functions:GetDocumentation()
    setclipboard("https://github.com/Exunys/Wall-Hack"); SendNotification(Title, "GitHub Documentation Page copied to clipboard!", 3)
end

--// Main

Load(); SendNotification(Title, "Wall Hack script successfully loaded! Check the GitHub page on how to configure the script.", 5)

--// Reload On Teleport

if Environment.Settings.ReloadOnTeleport then
    local queueonteleport = queue_on_teleport or syn.queue_on_teleport

    if queue_on_teleport then
        queue_on_teleport(game:HttpGet("https://raw.githubusercontent.com/Exunys/Wall-Hack/main/Resources/Scripts/Main.lua"))
    else
        SendNotification(Title, "Your exploit does not support \"syn.queue_on_teleport()\"")
    end
end
