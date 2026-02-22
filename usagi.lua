--[[
    Usagi Library v1.1
    Inspired by Rayfield, Designed for Usagi
    Theme: Rabbit (Cream, Pink, Dark Brown)
    Created by: Antigravity AI
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local Usagi = {
    Flags = {},
    Theme = {
        Background = Color3.fromRGB(255, 249, 215), -- Cream
        Sidebar = Color3.fromRGB(255, 245, 200),
        Accent = Color3.fromRGB(249, 168, 182), -- Pink
        Text = Color3.fromRGB(62, 39, 35), -- Dark Brown
        SecondaryText = Color3.fromRGB(100, 80, 75),
        Outline = Color3.fromRGB(62, 39, 35),
        ElementBackground = Color3.fromRGB(249, 239, 205),
        ElementHover = Color3.fromRGB(245, 225, 185)
    }
}

-- Utility: Modern Dragging
local function AddDrag(Frame, DragPart)
    local Dragging = false
    local DragInput, DragStart, StartPos

    local function Update(Input)
        local Delta = Input.Position - DragStart
        TweenService:Create(Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        }):Play()
    end

    DragPart.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPos = Frame.Position
            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)

    DragPart.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = Input end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then Update(Input) end
    end)
end

-- Loader / Splash Screen
function Usagi:Loader(Config)
    local Name = Config.Name or "Usagi UI"
    
    -- Pick random configuration (1 or 2)
    local ConfigIndex = math.random(1, 2)
    local Assets = {
        [1] = { Video = "rbxassetid://77102052458690", Sound = "rbxassetid://130981886816527" }, 
        [2] = { Video = "rbxassetid://77102052458690", Sound = "rbxassetid://123263136059897" }  
    }
    local CurrentAsset = Assets[ConfigIndex]

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UsagiLoader"
    ScreenGui.Parent = CoreGui
    ScreenGui.IgnoreGuiInset = true

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BackgroundTransparency = 0
    Main.Parent = ScreenGui

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(0, 400, 0, 300)
    Content.Position = UDim2.new(0.5, -200, 0.5, -150)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Position = UDim2.new(0, 0, 0.7, 0)
    Title.Text = Name
    Title.TextColor3 = self.Theme.Accent
    Title.Font = Enum.Font.FredokaOne
    Title.TextSize = 40
    Title.TextTransparency = 1
    Title.Parent = Content

    local VideoFrame = Instance.new("ImageLabel")
    VideoFrame.Size = UDim2.new(0, 180, 0, 180)
    VideoFrame.Position = UDim2.new(0.5, -90, 0.2, -30)
    VideoFrame.BackgroundTransparency = 1
    VideoFrame.Image = CurrentAsset.Video
    VideoFrame.ImageTransparency = 1
    VideoFrame.Parent = Content
    
    local VideoCorner = Instance.new("UICorner")
    VideoCorner.CornerRadius = UDim.new(1, 0)
    VideoCorner.Parent = VideoFrame

    -- Play Random Sound
    local s = Instance.new("Sound")
    s.SoundId = CurrentAsset.Sound
    s.Volume = 2
    s.Parent = CoreGui
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)

    local BarBackground = Instance.new("Frame")
    BarBackground.Size = UDim2.new(0.8, 0, 0, 6)
    BarBackground.Position = UDim2.new(0.1, 0, 0.9, 0)
    BarBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    BarBackground.Parent = Content
    
    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(0, 0, 1, 0)
    BarFill.BackgroundColor3 = self.Theme.Accent
    BarFill.Parent = BarBackground

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = BarBackground
    local UICorner2 = UICorner:Clone()
    UICorner2.Parent = BarFill

    TweenService:Create(VideoFrame, TweenInfo.new(1), {ImageTransparency = 0}):Play()
    TweenService:Create(Title, TweenInfo.new(1), {TextTransparency = 0}):Play()
    
    wait(0.5)
    local FillTween = TweenService:Create(BarFill, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    FillTween:Play()
    
    FillTween.Completed:Wait()
    wait(0.5)
    
    TweenService:Create(Main, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Content, TweenInfo.new(0.5), {GroupTransparency = 1}):Play()
    wait(0.5)
    ScreenGui:Destroy()
end

-- Main Window
function Usagi:CreateWindow(Config)
    local Title = Config.Name or "Usagi UI"
    
    self:Loader({Name = Title})

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UsagiLibrary"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 600, 0, 450)
    Main.Position = UDim2.new(0.5, -300, 0.5, -225)
    Main.BackgroundColor3 = self.Theme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    
    -- Modern Scale-In Animation
    local MainScale = Instance.new("UIScale", Main)
    MainScale.Scale = 0
    TweenService:Create(MainScale, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = Main

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = self.Theme.Outline
    MainStroke.Thickness = 2.5
    MainStroke.Parent = Main

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, 0)
    Sidebar.BackgroundColor3 = self.Theme.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main
    
    -- Sidebar Slide-In
    Sidebar.Position = UDim2.new(-0.3, 0, 0, 0)
    TweenService:Create(Sidebar, TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    SidebarCorner.Parent = Sidebar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 50)
    TitleLabel.Position = UDim2.new(0, 0, 0, 10)
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.Font = Enum.Font.FredokaOne
    TitleLabel.TextSize = 24
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Sidebar

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -20, 1, -80)
    TabContainer.Position = UDim2.new(0, 10, 0, 70)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 0
    TabContainer.Parent = Sidebar
    
    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 6)
    TabList.Parent = TabContainer

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -180, 1, -20)
    Container.Position = UDim2.new(0, 170, 0, 10)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    AddDrag(Main, Sidebar)

    local Window = {
        Tabs = {},
        CurrentTab = nil
    }

    function Window:CreateTab(Name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 36)
        TabButton.BackgroundColor3 = Usagi.Theme.ElementBackground
        TabButton.Text = Name
        TabButton.Font = Enum.Font.GothamBold
        TabButton.TextSize = 13
        TabButton.TextColor3 = Usagi.Theme.Text
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabContainer
        
        local TBCorner = Instance.new("UICorner")
        TBCorner.CornerRadius = UDim.new(0, 8)
        TBCorner.Parent = TabButton
        
        local TBStroke = Instance.new("UIStroke")
        TBStroke.Color = Usagi.Theme.Outline
        TBStroke.Thickness = 1.5
        TBStroke.Enabled = false
        TBStroke.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 3
        Page.ScrollBarImageColor3 = Usagi.Theme.Accent
        Page.Parent = Container
        
        local CanvasGroup = Instance.new("CanvasGroup")
        CanvasGroup.Size = UDim2.new(1, 0, 1, 0)
        CanvasGroup.BackgroundTransparency = 1
        CanvasGroup.GroupTransparency = 1
        CanvasGroup.Parent = Page
        
        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 8)
        PageList.Parent = CanvasGroup

        TabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab == TabButton then return end
            Window.CurrentTab = TabButton
            
            for _, t in pairs(Window.Tabs) do
                if t.Button ~= TabButton then
                    t.Page.Visible = false
                    t.Button.BackgroundColor3 = Usagi.Theme.ElementBackground
                    t.Button.UIStroke.Enabled = false
                end
            end
            
            Page.Visible = true
            CanvasGroup.GroupTransparency = 1
            TweenService:Create(CanvasGroup, TweenInfo.new(0.4), {GroupTransparency = 0}):Play()
            
            TabButton.BackgroundColor3 = Usagi.Theme.Accent
            TabButton.UIStroke.Enabled = true
        end)

        local Tab = {
            Button = TabButton,
            Page = Page
        }
        table.insert(Window.Tabs, Tab)

        if #Window.Tabs == 1 then
            Page.Visible = true
            CanvasGroup.GroupTransparency = 0
            TabButton.BackgroundColor3 = Usagi.Theme.Accent
            TabButton.UIStroke.Enabled = true
            Window.CurrentTab = TabButton
        end

        local TabFeatures = {}

        function TabFeatures:AddLabel(Text)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, 0, 0, 30)
            Label.BackgroundTransparency = 1
            Label.Text = "  " .. Text
            Label.Font = Enum.Font.GothamBold
            Label.TextSize = 14
            Label.TextColor3 = Usagi.Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = CanvasGroup
            
            return Label
        end

        function TabFeatures:AddButton(Text, Callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 44)
            Button.BackgroundColor3 = Usagi.Theme.ElementBackground
            Button.Text = "  " .. Text
            Button.Font = Enum.Font.GothamSemibold
            Button.TextSize = 14
            Button.TextColor3 = Usagi.Theme.Text
            Button.TextXAlignment = Enum.TextXAlignment.Left
            Button.AutoButtonColor = false
            Button.Parent = CanvasGroup
            
            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 10)
            BCorner.Parent = Button
            
            local BStroke = Instance.new("UIStroke")
            BStroke.Color = Usagi.Theme.Outline
            BStroke.Thickness = 1
            BStroke.Parent = Button

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundColor3 = Usagi.Theme.ElementHover}):Play()
            end)
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundColor3 = Usagi.Theme.ElementBackground}):Play()
            end)
            Button.MouseButton1Down:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {Size = UDim2.new(1, -6, 0, 40)}):Play()
            end)
            Button.MouseButton1Up:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 44)}):Play()
                Callback()
            end)
            
            return Button
        end

        function TabFeatures:AddSwitch(Text, Callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 44)
            ToggleFrame.BackgroundColor3 = Usagi.Theme.ElementBackground
            ToggleFrame.Parent = CanvasGroup
            
            local TFCorner = Instance.new("UICorner")
            TFCorner.CornerRadius = UDim.new(0, 10)
            TFCorner.Parent = ToggleFrame
            
            local TFStroke = Instance.new("UIStroke")
            TFStroke.Color = Usagi.Theme.Outline
            TFStroke.Thickness = 1
            TFStroke.Parent = ToggleFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Text = Text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 14
            Label.TextColor3 = Usagi.Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = ToggleFrame

            local Switch = Instance.new("TextButton")
            Switch.Size = UDim2.new(0, 44, 0, 24)
            Switch.Position = UDim2.new(1, -56, 0.5, -12)
            Switch.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            Switch.Text = ""
            Switch.AutoButtonColor = false
            Switch.Parent = ToggleFrame
            
            local SCorner = Instance.new("UICorner")
            SCorner.CornerRadius = UDim.new(1, 0)
            SCorner.Parent = Switch

            local Dot = Instance.new("Frame")
            Dot.Size = UDim2.new(0, 20, 0, 20)
            Dot.Position = UDim2.new(0, 2, 0.5, -10)
            Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dot.Parent = Switch
            
            local DCorner = Instance.new("UICorner")
            DCorner.CornerRadius = UDim.new(1, 0)
            DCorner.Parent = Dot

            local Toggled = false
            local function Set(bool)
                Toggled = bool
                local TargetPos = Toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                local TargetColor = Toggled and Usagi.Theme.Accent or Color3.fromRGB(180, 180, 180)
                
                TweenService:Create(Dot, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = TargetPos}):Play()
                TweenService:Create(Switch, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {BackgroundColor3 = TargetColor}):Play()
                
                Callback(Toggled)
            end

            Switch.MouseButton1Click:Connect(function()
                Set(not Toggled)
            end)
            
            return {
                Set = Set
            }
        end

        function TabFeatures:AddSlider(Text, Min, Max, Default, Callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            SliderFrame.BackgroundColor3 = Usagi.Theme.ElementBackground
            SliderFrame.Parent = CanvasGroup
            
            local SFCorner = Instance.new("UICorner")
            SFCorner.CornerRadius = UDim.new(0, 10)
            SFCorner.Parent = SliderFrame
            
            local SFStroke = Instance.new("UIStroke")
            SFStroke.Color = Usagi.Theme.Outline
            SFStroke.Thickness = 1
            SFStroke.Parent = SliderFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 30)
            Label.Position = UDim2.new(0, 12, 0, 5)
            Label.Text = Text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 14
            Label.TextColor3 = Usagi.Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 50, 0, 30)
            ValueLabel.Position = UDim2.new(1, -62, 0, 5)
            ValueLabel.Text = tostring(Default)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextSize = 14
            ValueLabel.TextColor3 = Usagi.Theme.Accent
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Parent = SliderFrame

            local SliderBar = Instance.new("TextButton")
            SliderBar.Size = UDim2.new(1, -24, 0, 7)
            SliderBar.Position = UDim2.new(0, 12, 0.75, -3)
            SliderBar.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            SliderBar.Text = ""
            SliderBar.AutoButtonColor = false
            SliderBar.Parent = SliderFrame
            
            local SBCorner = Instance.new("UICorner")
            SBCorner.CornerRadius = UDim.new(1, 0)
            SBCorner.Parent = SliderBar

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = Usagi.Theme.Accent
            Fill.Parent = SliderBar
            
            local FCorner = Instance.new("UICorner")
            FCorner.CornerRadius = UDim.new(1, 0)
            FCorner.Parent = Fill

            local Dragging = false
            local function Update()
                local Percentage = math.clamp((UserInputService:GetMouseLocation().X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local Value = math.floor(Min + (Max - Min) * Percentage)
                
                ValueLabel.Text = tostring(Value)
                TweenService:Create(Fill, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {Size = UDim2.new(Percentage, 0, 1, 0)}):Play()
                Callback(Value)
            end

            SliderBar.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    Update()
                end
            end)
            UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(Input)
                if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then Update() end
            end)
        end

        function TabFeatures:AddTextBox(Text, Callback)
            local BoxFrame = Instance.new("Frame")
            BoxFrame.Size = UDim2.new(1, 0, 0, 44)
            BoxFrame.BackgroundColor3 = Usagi.Theme.ElementBackground
            BoxFrame.Parent = CanvasGroup
            
            local BCorner = Instance.new("UICorner")
            BCorner.CornerRadius = UDim.new(0, 10)
            BCorner.Parent = BoxFrame
            
            local BStroke = Instance.new("UIStroke")
            BStroke.Color = Usagi.Theme.Outline
            BStroke.Thickness = 1
            BStroke.Parent = BoxFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.5, 0, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Text = Text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 14
            Label.TextColor3 = Usagi.Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = BoxFrame

            local TextBox = Instance.new("TextBox")
            TextBox.Size = UDim2.new(0.4, 0, 0, 26)
            TextBox.Position = UDim2.new(1, -12, 0.5, -13)
            TextBox.AnchorPoint = Vector2.new(1, 0)
            TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.Text = ""
            TextBox.PlaceholderText = "..."
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 14
            TextBox.TextColor3 = Usagi.Theme.Text
            TextBox.Parent = BoxFrame
            
            local TBCorner = Instance.new("UICorner")
            TBCorner.CornerRadius = UDim.new(0, 6)
            TBCorner.Parent = TextBox

            TextBox.FocusLost:Connect(function(Enter)
                Callback(TextBox.Text)
                TweenService:Create(BoxFrame, TweenInfo.new(0.2), {BackgroundColor3 = Usagi.Theme.Accent}):Play()
                task.wait(0.2)
                TweenService:Create(BoxFrame, TweenInfo.new(0.4), {BackgroundColor3 = Usagi.Theme.ElementBackground}):Play()
            end)
            
            return TextBox
        end

        function TabFeatures:AddDropdown(Text, Callback)
            local Dropdown = {
                Items = {},
                Open = false
            }

            local DropFrame = Instance.new("Frame")
            DropFrame.Size = UDim2.new(1, 0, 0, 44)
            DropFrame.BackgroundColor3 = Usagi.Theme.ElementBackground
            DropFrame.ClipsDescendants = true
            DropFrame.Parent = CanvasGroup
            
            local DCorner = Instance.new("UICorner")
            DCorner.CornerRadius = UDim.new(0, 10)
            DCorner.Parent = DropFrame
            
            local DStroke = Instance.new("UIStroke")
            DStroke.Color = Usagi.Theme.Outline
            DStroke.Thickness = 1
            DStroke.Parent = DropFrame

            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -40, 0, 44)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Text = Text
            Label.Font = Enum.Font.GothamSemibold
            Label.TextSize = 14
            Label.TextColor3 = Usagi.Theme.Text
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Parent = DropFrame

            local Icon = Instance.new("ImageLabel")
            Icon.Size = UDim2.new(0, 20, 0, 20)
            Icon.Position = UDim2.new(1, -30, 0, 12)
            Icon.BackgroundTransparency = 1
            Icon.Image = "rbxassetid://6031091000"
            Icon.ImageColor3 = Usagi.Theme.Text
            Icon.Parent = DropFrame

            local Container = Instance.new("Frame")
            Container.Size = UDim2.new(1, -20, 0, 0)
            Container.Position = UDim2.new(0, 10, 0, 44)
            Container.BackgroundTransparency = 1
            Container.Parent = DropFrame
            
            local List = Instance.new("UIListLayout")
            List.Padding = UDim.new(0, 4)
            List.Parent = Container

            local function Toggle(State)
                Dropdown.Open = State
                local TargetHeight = State and (44 + Container.UIListLayout.AbsoluteContentSize.Y + 10) or 44
                TweenService:Create(DropFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, TargetHeight)}):Play()
                TweenService:Create(Icon, TweenInfo.new(0.3), {Rotation = State and 180 or 0}):Play()
            end

            Label.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Toggle(not Dropdown.Open)
                end
            end)

            function Dropdown:Add(ItemName)
                local Item = Instance.new("TextButton")
                Item.Size = UDim2.new(1, 0, 0, 30)
                Item.BackgroundColor3 = Usagi.Theme.ElementHover
                Item.Text = ItemName
                Item.Font = Enum.Font.Gotham
                Item.TextSize = 13
                Item.TextColor3 = Usagi.Theme.Text
                Item.Parent = Container
                
                local ICorner = Instance.new("UICorner")
                ICorner.CornerRadius = UDim.new(0, 6)
                ICorner.Parent = Item

                Item.MouseButton1Click:Connect(function()
                    Label.Text = Text .. ": " .. ItemName
                    Callback(ItemName)
                    Toggle(false)
                end)
            end

            function Dropdown:Clear()
                for _, v in pairs(Container:GetChildren()) do
                    if v:IsA("TextButton") then v:Destroy() end
                end
                if Dropdown.Open then Toggle(false) end
            end

            return Dropdown
        end

        function TabFeatures:Show()
            for _, t in pairs(Window.Tabs) do t.Page.Visible = false end
            Page.Visible = true
        end

        return TabFeatures
    end

    return Window
end

-- Notifications
function Usagi:Notify(Config)
    local Title = Config.Title or "Notification"
    local Content = Config.Content or "Successfully executed!"
    local Image = Config.Image or "rbxassetid://77102052458690"
    local Sound = Config.Sound or 79918510646632 
    local Duration = Config.Duration or 5

    local NotifyGui = CoreGui:FindFirstChild("UsagiNotify")
    if not NotifyGui then
        NotifyGui = Instance.new("ScreenGui")
        NotifyGui.Name = "UsagiNotify"
        NotifyGui.Parent = CoreGui
        
        local Container = Instance.new("Frame")
        Container.Name = "NotifyContainer"
        Container.Size = UDim2.new(0, 300, 1, 0)
        Container.Position = UDim2.new(1, -310, 0, 10)
        Container.BackgroundTransparency = 1
        Container.Parent = NotifyGui
        
        local List = Instance.new("UIListLayout")
        List.VerticalAlignment = Enum.VerticalAlignment.Bottom
        List.Padding = UDim.new(0, 10)
        List.Parent = Container
    end

    local NotifyFrame = Instance.new("Frame")
    NotifyFrame.Size = UDim2.new(1, 0, 0, 80)
    NotifyFrame.BackgroundColor3 = self.Theme.Background
    NotifyFrame.BackgroundTransparency = 0.1
    NotifyFrame.Parent = NotifyGui.NotifyContainer
    
    local NFCorner = Instance.new("UICorner")
    NFCorner.CornerRadius = UDim.new(0, 10)
    NFCorner.Parent = NotifyFrame
    
    local NFStroke = Instance.new("UIStroke")
    NFStroke.Color = self.Theme.Outline
    NFStroke.Thickness = 1.5
    NFStroke.Parent = NotifyFrame

    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 50, 0, 50)
    Icon.Position = UDim2.new(0, 10, 0.5, -25)
    Icon.BackgroundTransparency = 1
    Icon.Image = Image
    Icon.Parent = NotifyFrame
    
    local ICorner = Instance.new("UICorner")
    ICorner.CornerRadius = UDim.new(1, 0)
    ICorner.Parent = Icon

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -70, 0, 20)
    TitleLabel.Position = UDim2.new(0, 65, 0, 15)
    TitleLabel.Text = Title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = NotifyFrame

    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Size = UDim2.new(1, -70, 0, 30)
    ContentLabel.Position = UDim2.new(0, 65, 0, 35)
    ContentLabel.Text = Content
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextSize = 14
    ContentLabel.TextColor3 = self.Theme.SecondaryText
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextWrapped = true
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Parent = NotifyFrame

    if Sound then
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. tostring(Sound):gsub("rbxassetid://", "")
        s.Volume = 1
        s.Parent = CoreGui
        s:Play()
        s.Ended:Connect(function() s:Destroy() end)
    end

    -- Animation
    NotifyFrame.Position = UDim2.new(1, 10, 0, 0)
    TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    task.delay(Duration, function()
        local t = TweenService:Create(NotifyFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 10, 0, 0)})
        t:Play()
        t.Completed:Wait()
        NotifyFrame:Destroy()
    end)
end

return Usagi
