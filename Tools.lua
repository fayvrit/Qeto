local Text = game:GetService("TextService")
local UserInput = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local Gui = game:GetService("GuiService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local Tools = {
	Mouse = LocalPlayer:GetMouse(),
	Screen = workspace.CurrentCamera,
	TweenInfo = TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Connections = { }
}

Tools.FindCenterVector2 = function(Size)
	local size = {X = Size.X.Offset, Y = Size.Y.Offset}

	return UDim2.fromOffset((Tools.Screen.ViewportSize.X / 2) - size.X / 2, Tools.Screen.ViewportSize.Y / 2 - size.Y / 2);
end
	
Tools.GuiObjByPosition = function( data, vec2 )
	local elements = LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(vec2.X, vec2.Y)
	local tbl = {}

	if #elements == 0 then return tbl end

	for i, obj in elements do 
		if data[2] and obj[data[1]] == data[2] or obj:IsA(data[1]) then 
			table.insert(tbl, obj)
		end
	end

	return tbl
end

Tools.notification = function( ... )
	local tbl = ...

	local logs = {
		LastDuration = nil,
		Parent = tbl.Parent,
	}

	--[[ Instances ]] do
		logs.obj = {
			Logs = Instance.new("Frame"),
			UIListLayout = Instance.new("UIListLayout"),
		}

		logs.obj.Logs.Name = "Logs"
		logs.obj.Logs.AnchorPoint = Vector2.new(0.5, 1)
		logs.obj.Logs.Size = UDim2.new(0, 494, 0, 500)
		logs.obj.Logs.BorderColor3 = Color3.fromRGB(0, 0, 0)
		logs.obj.Logs.BackgroundTransparency = 1
		logs.obj.Logs.Position = UDim2.new(0.5, 0, 1, -100)
		logs.obj.Logs.BorderSizePixel = 0
		logs.obj.Logs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		logs.obj.Logs.Parent = logs.Parent

		logs.obj.UIListLayout.Name = "UIListLayout"
		logs.obj.UIListLayout.Padding = UDim.new(0, 5)
		logs.obj.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		logs.obj.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		logs.obj.UIListLayout.Parent = logs.obj.Logs
	end
	
	--[[ Functions ]] do
		
		logs.Message = function( ... )
			local tbl = ...
			
			local noti = {
				Active = false,
				LastDuration = tbl.LastDuration and true or false,
				Duration = tbl.Duration or 2,
				Message = tbl.Message,
				Type = tbl.Type
			}
			
			if logs[noti.Message] then
				logs[noti.Message].Remove()
			end
			
			logs[noti.Message] = {}
			
			--[[ Instances ]] do 
				logs[noti.Message].obj = {
					Border = Instance.new("Frame"),
					UICorner = Instance.new("UICorner"),
					Background = Instance.new("Frame"),
					UICorner_2 = Instance.new("UICorner"),
					UIStroke = Instance.new("UIStroke"),
					Text = Instance.new("TextLabel"),
					UIPadding = Instance.new("UIPadding"),
				}
				
				logs[noti.Message].obj.Border.Name = "Border"
				logs[noti.Message].obj.Border.Size = UDim2.new(0, 0, 0, 25)
				logs[noti.Message].obj.Border.BorderColor3 = Color3.fromRGB(0, 0, 0)
				logs[noti.Message].obj.Border.BackgroundTransparency = 1
				logs[noti.Message].obj.Border.BorderSizePixel = 0
				logs[noti.Message].obj.Border.BackgroundColor3 = Color3.fromRGB(25, 30, 30)
				logs[noti.Message].obj.Border.Parent = logs.obj.Logs

				logs[noti.Message].obj.UICorner.Name = "UICorner"
				logs[noti.Message].obj.UICorner.Parent = logs[noti.Message].obj.Border

				logs[noti.Message].obj.Background.Name = "Background"
				logs[noti.Message].obj.Background.Size = UDim2.new(1, -4, 1, -4)
				logs[noti.Message].obj.Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
				logs[noti.Message].obj.Background.BackgroundTransparency = 1
				logs[noti.Message].obj.Background.Position = UDim2.new(0, 2, 0, 2)
				logs[noti.Message].obj.Background.BorderSizePixel = 0
				logs[noti.Message].obj.Background.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
				logs[noti.Message].obj.Background.Parent = logs[noti.Message].obj.Border

				logs[noti.Message].obj.UICorner_2.Name = "UICorner"
				logs[noti.Message].obj.UICorner_2.CornerRadius = UDim.new(0, 6)
				logs[noti.Message].obj.UICorner_2.Parent = logs[noti.Message].obj.Background

				logs[noti.Message].obj.UIStroke.Name = "UIStroke"
				logs[noti.Message].obj.UIStroke.Color = Color3.fromRGB(80, 90, 100)
				logs[noti.Message].obj.UIStroke.Transparency = 1
				logs[noti.Message].obj.UIStroke.Parent = logs[noti.Message].obj.Background

				logs[noti.Message].obj.Text.Name = "Text"
				logs[noti.Message].obj.Text.AnchorPoint = Vector2.new(0.5, 0)
				logs[noti.Message].obj.Text.Size = UDim2.new(1, 0, 1, 0)
				logs[noti.Message].obj.Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
				logs[noti.Message].obj.Text.BackgroundTransparency = 1
				logs[noti.Message].obj.Text.Position = UDim2.new(0.5, 0, 0, 0)
				logs[noti.Message].obj.Text.BorderSizePixel = 0
				logs[noti.Message].obj.Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				logs[noti.Message].obj.Text.TextColor3 = Color3.fromRGB(175, 185, 185)
				logs[noti.Message].obj.Text.RichText = true
				logs[noti.Message].obj.Text.Text = noti.Message
				logs[noti.Message].obj.Text.TextTransparency = 1
				logs[noti.Message].obj.Text.TextSize = 14
				logs[noti.Message].obj.Text.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
				logs[noti.Message].obj.Text.MaxVisibleGraphemes = 0
				logs[noti.Message].obj.Text.Parent = logs[noti.Message].obj.Background
				
				logs[noti.Message].obj.UIPadding.Name = "UIPadding"
				logs[noti.Message].obj.UIPadding.PaddingTop = UDim.new(0, 10)
				logs[noti.Message].obj.UIPadding.PaddingBottom = UDim.new(0, 10)
				logs[noti.Message].obj.UIPadding.PaddingLeft = UDim.new(0, 10)
				logs[noti.Message].obj.UIPadding.PaddingRight = UDim.new(0, 10)
				logs[noti.Message].obj.UIPadding.Parent = logs[noti.Message].obj.Text
			end
		
			--[[ Functions ]] do
				local bounds = logs[noti.Message].obj.Text.TextBounds
				
				logs[noti.Message].AnimStart = function()
					Tween:Create(logs[noti.Message].obj.Text, Tools.TweenInfo, {TextTransparency = 0, MaxVisibleGraphemes = #noti.Message}):Play()
					Tween:Create(logs[noti.Message].obj.Background, Tools.TweenInfo, {BackgroundTransparency = .3}):Play()
					Tween:Create(logs[noti.Message].obj.UIStroke, Tools.TweenInfo, {Transparency = .3}):Play()
					
					Tween:Create(logs[noti.Message].obj.Border, Tools.TweenInfo, {
						Size = UDim2.new(0, bounds.X + 20, 0, bounds.Y + 11), 
						BackgroundTransparency = .3
					}):Play()
				end
				
				logs[noti.Message].AnimEnd = function()
					Tween:Create(logs[noti.Message].obj.Text, Tools.TweenInfo, {TextTransparency = 1, MaxVisibleGraphemes = 0}):Play()
					Tween:Create(logs[noti.Message].obj.Background, Tools.TweenInfo, {BackgroundTransparency = 1}):Play()
					Tween:Create(logs[noti.Message].obj.UIStroke, Tools.TweenInfo, {Transparency = 1}):Play()
					
					Tween:Create(logs[noti.Message].obj.Border, Tools.TweenInfo, {
						Size = UDim2.new(0, 0, 0, bounds.Y + 11), 
						BackgroundTransparency = 1
					}):Play()
				end
				
				logs[noti.Message].Remove = function()	
					if not logs[noti.Message] then return end
					
					logs[noti.Message].AnimEnd()

					task.wait(.2)

					if not logs[noti.Message] then return end
					logs[noti.Message].obj.Border:Destroy()
					logs[noti.Message] = nil 
				end
				
				logs[noti.Message].Start = function()		
					if noti.LastDuration then
						noti.Duration = logs.LastDuration and logs.LastDuration or noti.Duration
					end
					
					logs.LastDuration = noti.Duration
					logs[noti.Message].AnimStart()
					
					task.wait(noti.Duration)
					
					if not logs[noti.Message] then return end
					logs[noti.Message].Remove()
				end
				
				coroutine.wrap(logs[noti.Message].Start)()
				
			end
			
			return logs[noti.Message]
		end

		logs.Remove = function( msg )
			if not logs[msg] then return end
			
			logs[msg].Remove()
		end
	end

	return logs
end

Tools.cursor = function( ... )
	local tbl = ...

	local cursor = {
		Assets = tbl.Assets or {
			["Static"] = {"rbxassetid://17470088869", Vector2.new(0.15, 0.29)},
			["Button"] = {"rbxassetid://17470748351", Vector2.new(0.35, 0.2)},
			["Resize"] = {"rbxassetid://17472518830", Vector2.new(0.5, 0.5)}
		},

		Table = tbl.Table,
		Object = tbl.Object,
		Parent = tbl.Parent
	}

	if not cursor.Parent or not cursor.Table.minimize then return cursor end

	--[[ Functions ]] do
		cursor.spawn = function()
			cursor.obj = {Cursor = Instance.new("ImageLabel")}

			cursor.obj.Cursor.Name = "Cursor"
			cursor.obj.Cursor.AnchorPoint = cursor.Assets["Static"][2]
			cursor.obj.Cursor.Size = UDim2.new(0, 32, 0, 32)
			cursor.obj.Cursor.BorderColor3 = Color3.fromRGB(0, 0, 0)
			cursor.obj.Cursor.BackgroundTransparency = 1
			cursor.obj.Cursor.Position = UDim2.new(0, 0, 0, 0)
			cursor.obj.Cursor.BorderSizePixel = 0
			cursor.obj.Cursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			cursor.obj.Cursor.Image = cursor.Assets["Static"][1]
			cursor.obj.Cursor.ZIndex = 9999
			cursor.obj.Cursor.Parent = cursor.Parent
		end

		cursor.switch = function(style)
			cursor.obj.Cursor.AnchorPoint = cursor.Assets[style][2]
			cursor.obj.Cursor.Image = cursor.Assets[style][1]
		end

		cursor.moved = function()
			local mouselocation = UserInput:GetMouseLocation()

			UserInput.MouseIconEnabled = not cursor.Table.minimize.Enabled
			cursor.obj.Cursor.Visible = cursor.Table.minimize.Enabled
			cursor.obj.Cursor.Position = UDim2.fromOffset(mouselocation.X, mouselocation.Y)

			local hoveredMouse = Vector2.new(mouselocation.X, mouselocation.Y - Gui:GetGuiInset().Y)

			local hoveredElements = {
				Tools.GuiObjByPosition({"GuiButton"}, hoveredMouse),
				Tools.GuiObjByPosition({"Name", "Resize"}, hoveredMouse)
			}

			if #hoveredElements[1] > 0 then
				cursor.switch("Button")
				return
			end

			if #hoveredElements[2] > 0 or cursor.Table.resize.Active then
				cursor.switch("Resize")
				return
			end

			cursor.switch("Static")
		end

		cursor.spawn()

		table.insert(Tools.Connections, Tools.Mouse.Move:Connect(cursor.moved))
	end

	return cursor
end

Tools.minimize = function( ... )
	local tbl = ...

	local mini = {
		Enabled = true,
		Active = false,
		Object = tbl.Object,
		Table = tbl.Table,
		Key = tbl.Key or "RightShift"
	}

	if not mini.Object[1] or not mini.Object[1]:IsA("CanvasGroup") then return mini end

	--[[ Functions ]] do
		mini.MouseEnter = function()
			if mini.Active then return end
			mini.Object[2].Text = "○"
		end

		mini.MouseLeave = function()
			mini.Object[2].Text = "●"
		end

		mini.Anim = function(bool)
			mini.Active = true
			Tween:Create(mini.Object[1], Tools.TweenInfo, {GroupTransparency = bool and 0 or 1}):Play()

			if bool then
				mini.Object[1].Visible = true
			end

			task.wait(.2)

			mini.Object[1].Visible = bool
			mini.MouseLeave()

			mini.Active = false
		end

		mini.Open = function()
			if mini.Table and (mini.Table.drag and mini.Table.drag.Active or mini.Table.resize and mini.Table.resize.Active) then return end
			mini.Enabled = not mini.Enabled
			mini.Anim(mini.Enabled)
		end

		mini.KeyOpen = function(Input)
			if Input.KeyCode == Enum.KeyCode[mini.Key] and not mini.Active then
				mini.Open()
			end
		end
	end

	--[[ Connections ]] do
		mini.Connections = {}

		table.insert(mini.Connections, UserInput.InputBegan:Connect(mini.KeyOpen))
		table.insert(mini.Connections, mini.Object[2].MouseButton1Click:Connect(mini.Open))
		table.insert(mini.Connections, mini.Object[2].MouseEnter:Connect(mini.MouseEnter))
		table.insert(mini.Connections, mini.Object[2].MouseLeave:Connect(mini.MouseLeave))

		table.insert(Tools.Connections, mini.Connections)
	end

	return mini
end

Tools.drag = function( ... )
	local tbl = ...

	local drag = {
		Allowed	= true,
		Active = false,
		Offset = UDim2.fromOffset(),
		Delta = UDim2.fromOffset(),
		Object = tbl.Object,
		BoxMode = tbl.BoxMode or false
	}

	if not drag.Object[1] or not drag.Object[2] then return drag end

	--[[ Functions ]] do
		drag.Clear = function()
			for _, Connection in drag.Connections do
				Connection:Disconnect()
			end
			drag = nil
		end

		drag.InputBegan = function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and drag.Allowed then
				if drag.BoxMode then 
					drag.Object[2].Visible = true
				end

				drag.Active = true
				drag.Offset = drag.Object[2].Position - UDim2.fromOffset(Input.Position.X, Input.Position.Y)
			end 
		end

		drag.InputEnded = function(Input) 
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and drag.Allowed then
				if drag.BoxMode then 
					drag.Object[2].Visible = false 		
					Tween:Create(drag.Object[3], Tools.TweenInfo, {Position = drag.Object[2].Position}):Play()
				end

				drag.Active = false
			end 
		end

		drag.InputChanged = function(Input) 
			if Input.UserInputType == Enum.UserInputType.MouseMovement and drag.Active and drag.Allowed then
				drag.Delta = UDim2.fromOffset(Input.Position.X, Input.Position.Y) + drag.Offset

				drag.Delta = UDim2.fromOffset(
					math.clamp(drag.Delta.X.Offset, 0, Tools.Screen.ViewportSize.X - drag.Object[2].Size.X.Offset),
					math.clamp(drag.Delta.Y.Offset, 0, Tools.Screen.ViewportSize.Y - drag.Object[2].Size.Y.Offset)
				)

				drag.Object[2].Position = drag.Delta
			end
		end
	end

	--[[ Connections ]] do
		drag.Connections = {}

		table.insert(drag.Connections, drag.Object[1].InputBegan:Connect(drag.InputBegan))
		table.insert(drag.Connections, drag.Object[1].InputEnded:Connect(drag.InputEnded))
		table.insert(drag.Connections, UserInput.InputChanged:Connect(drag.InputChanged))

		table.insert(Tools.Connections, drag.Connections)
	end

	return drag
end

Tools.resize = function( ... )
	local tbl = ...

	local resize = {
		Allowed	= true,
		Active = false,
		Offset = UDim2.fromOffset(),
		Delta = UDim2.fromOffset(),
		Object = tbl.Object,
		BoxMode = tbl.BoxMode or false
	}

	if not resize.Object[1] or not resize.Object[2] then return resize end

	--[[ Functions ]] do
		resize.Clear = function()
			for _, Connection in resize.Connections do
				Connection:Disconnect()
			end
			resize = nil
		end

		resize.InputBegan = function(Input)		
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and resize.Allowed then
				if resize.BoxMode then resize.Object[2].Visible = true end
				resize.Active = true
				resize.Offset = resize.Object[2].Size - UDim2.fromOffset(Input.Position.X, Input.Position.Y)
			end 
		end

		resize.InputEnded = function(Input) 
			if Input.UserInputType == Enum.UserInputType.MouseButton1 and resize.Allowed then
				if resize.BoxMode then 
					resize.Object[2].Visible = false 
					Tween:Create(resize.Object[3], Tools.TweenInfo, {Size = resize.Object[2].Size}):Play()
				end
				resize.Active = false
			end 
		end

		resize.InputChanged = function(Input) 
			if Input.UserInputType == Enum.UserInputType.MouseMovement and resize.Active and resize.Allowed then
				resize.Delta = UDim2.fromOffset(Input.Position.X, Input.Position.Y) + resize.Offset

				resize.Delta = UDim2.fromOffset(
					math.clamp(resize.Delta.X.Offset, 350, Tools.Screen.ViewportSize.X),
					math.clamp(resize.Delta.Y.Offset, 250, Tools.Screen.ViewportSize.Y)
				)

				resize.Object[2].Size = resize.Delta

				if resize.Object[2].Position.X.Offset + resize.Delta.X.Offset > Tools.Screen.ViewportSize.X then
					resize.Object[2].Position = UDim2.fromOffset(Tools.Screen.ViewportSize.X - resize.Delta.X.Offset, resize.Object[2].Position.Y.Offset)
				end

				if resize.Object[2].Position.Y.Offset + resize.Delta.Y.Offset > Tools.Screen.ViewportSize.Y then
					resize.Object[2].Position = UDim2.fromOffset(resize.Object[2].Position.X.Offset, Tools.Screen.ViewportSize.Y - resize.Delta.Y.Offset)
				end
			end
		end
	end

	--[[ Connections ]] do
		resize.Connections = {}

		table.insert(resize.Connections, resize.Object[1].InputBegan:Connect(resize.InputBegan))
		table.insert(resize.Connections, resize.Object[1].InputEnded:Connect(resize.InputEnded))
		table.insert(resize.Connections, UserInput.InputChanged:Connect(resize.InputChanged))

		table.insert(Tools.Connections, resize.Connections)
	end

	return resize
end

return Tools
