local UserInput = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local Text = game:GetService("TextService")
local Players = game:GetService("Players")
local Gui = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer

local Tools = {
	Mouse = LocalPlayer:GetMouse(),
	Screen = workspace.CurrentCamera,
	TweenInfo = TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	Connections = { }
}

Tools.ReplaceTable = function(target, tbl)
	if not tbl then 
		tbl = {}
	end
	
	for index, value in target do
		tbl[index] = value
	end
	target = nil

	return tbl
end

Tools.ColorSequence = function( tbl )
	local Keypoints = {}
	
	for _, keypoint in tbl do
		table.insert(Keypoints, ColorSequenceKeypoint.new(keypoint[1], keypoint[2]))
	end

	return ColorSequence.new(Keypoints)
end

Tools.FormatNumber = function( num )
	if type(tonumber(num)) ~= "number" then return num end
	num = tostring(num):reverse()
	return num:gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

Tools.FindCenterUDim2 = function( size )
	size = {X = size.X.Offset, Y = size.Y.Offset}

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
	
	if not logs.Parent then return warn("notification: Missing Arguments") end
	
	local obj = {
		Logs = Instance.new("Frame"),
		UIListLayout = Instance.new("UIListLayout"),
	}
	
	--[[ Instances ]] do
		obj.Logs.Name = "Logs"
		obj.Logs.AnchorPoint = Vector2.new(0.5, 1)
		obj.Logs.Size = UDim2.new(0, 494, 0, 500)
		obj.Logs.BorderColor3 = Color3.fromRGB(0, 0, 0)
		obj.Logs.BackgroundTransparency = 1
		obj.Logs.Position = UDim2.new(0.5, 0, 1, -100)
		obj.Logs.BorderSizePixel = 0
		obj.Logs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		obj.Logs.Parent = logs.Parent

		obj.UIListLayout.Name = "UIListLayout"
		obj.UIListLayout.Padding = UDim.new(0, 5)
		obj.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		obj.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		obj.UIListLayout.Parent = obj.Logs
	end
	
	--[[ Functions ]] do
		Tools.ReplaceTable(obj, logs.obj)
		
		logs.Message = function( ... )
			local tbl = ...
			
			local noti = {
				Active = false,
				LastDuration = tbl.LastDuration and true or false,
				Duration = tbl.Duration or 2,
				Message = tbl.Message,
				Type = tbl.Type or "Normal"
			}
			
			if not noti.Message then return warn("message: Missing Arguments") end
			
			if logs[noti.Message] then
				logs[noti.Message].Remove()
			end
			
			logs[noti.Message] = {}
			
			local objMsg = {
				Border = Instance.new("Frame"),
				UICorner = Instance.new("UICorner"),
				Background = Instance.new("Frame"),
				UICorner_2 = Instance.new("UICorner"),
				UIStroke = Instance.new("UIStroke"),
				Text = Instance.new("TextLabel"),
				UIPadding = Instance.new("UIPadding"),
			}
			
			--[[ Instances ]] do 
				objMsg.Border.Name = "Border"
				objMsg.Border.Size = UDim2.new(0, 0, 0, 25)
				objMsg.Border.BorderColor3 = Color3.fromRGB(0, 0, 0)
				objMsg.Border.BackgroundTransparency = 1
				objMsg.Border.BorderSizePixel = 0
				objMsg.Border.BackgroundColor3 = Color3.fromRGB(25, 30, 30)
				objMsg.Border.Parent = obj.Logs

				objMsg.UICorner.Name = "UICorner"
				objMsg.UICorner.Parent = objMsg.Border

				objMsg.Background.Name = "Background"
				objMsg.Background.Size = UDim2.new(1, -4, 1, -4)
				objMsg.Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
				objMsg.Background.BackgroundTransparency = 1
				objMsg.Background.Position = UDim2.new(0, 2, 0, 2)
				objMsg.Background.BorderSizePixel = 0
				objMsg.Background.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
				objMsg.Background.Parent = objMsg.Border

				objMsg.UICorner_2.Name = "UICorner"
				objMsg.UICorner_2.CornerRadius = UDim.new(0, 6)
				objMsg.UICorner_2.Parent = objMsg.Background

				objMsg.UIStroke.Name = "UIStroke"
				objMsg.UIStroke.Color = Color3.fromRGB(80, 90, 100)
				objMsg.UIStroke.Transparency = 1
				objMsg.UIStroke.Parent = objMsg.Background

				objMsg.Text.Name = "Text"
				objMsg.Text.AnchorPoint = Vector2.new(0.5, 0)
				objMsg.Text.Size = UDim2.new(1, 0, 1, 0)
				objMsg.Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
				objMsg.Text.BackgroundTransparency = 1
				objMsg.Text.Position = UDim2.new(0.5, 0, 0, 0)
				objMsg.Text.BorderSizePixel = 0
				objMsg.Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				objMsg.Text.TextColor3 = Color3.fromRGB(175, 185, 185)
				objMsg.Text.RichText = true
				objMsg.Text.Text = noti.Message
				objMsg.Text.TextTransparency = 1
				objMsg.Text.TextSize = 14
				objMsg.Text.FontFace = Font.new("rbxasset://fonts/families/Ubuntu.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
				objMsg.Text.MaxVisibleGraphemes = 0
				objMsg.Text.Parent = objMsg.Background
				
				objMsg.UIPadding.Name = "UIPadding"
				objMsg.UIPadding.PaddingTop = UDim.new(0, 10)
				objMsg.UIPadding.PaddingBottom = UDim.new(0, 10)
				objMsg.UIPadding.PaddingLeft = UDim.new(0, 10)
				objMsg.UIPadding.PaddingRight = UDim.new(0, 10)
				objMsg.UIPadding.Parent = objMsg.Text
			end
		
			--[[ Functions ]] do
				Tools.ReplaceTable(objMsg, logs[noti.Message])
				
				local bounds = objMsg.Text.TextBounds
				local Tweens = {
					Start = {
						Tween:Create(objMsg.Text, Tools.TweenInfo, {TextTransparency = 0, MaxVisibleGraphemes = #noti.Message}),
						Tween:Create(objMsg.Background, Tools.TweenInfo, {BackgroundTransparency = .3}),
						Tween:Create(objMsg.UIStroke, Tools.TweenInfo, {Transparency = .3}),
						Tween:Create(objMsg.Border, Tools.TweenInfo, {
							Size = UDim2.new(0, bounds.X + 20, 0, bounds.Y + 11), 
							BackgroundTransparency = .3
						})
					},
					End = {
						Tween:Create(objMsg.Text, Tools.TweenInfo, {TextTransparency = 1, MaxVisibleGraphemes = 0}),
						Tween:Create(objMsg.Background, Tools.TweenInfo, {BackgroundTransparency = 1}),
						Tween:Create(objMsg.UIStroke, Tools.TweenInfo, {Transparency = 1}),
						Tween:Create(objMsg.Border, Tools.TweenInfo, {
							Size = UDim2.new(0, 0, 0, bounds.Y + 11), 
							BackgroundTransparency = 1
						})
					}
				}
				
				logs[noti.Message].BoundChanged = function(property)
					if property ~= "TextBounds" or objMsg.Text.TextBounds.X < bounds.X then return end
					
					bounds = objMsg.Text.TextBounds
					objMsg.Border.Size = UDim2.new(0, bounds.X + 20, 0, bounds.Y + 11)
				end
				
				logs[noti.Message].AnimStart = function()
					for _, tween in Tweens.Start do
						tween:Play()
					end
				end
				
				logs[noti.Message].AnimEnd = function()
					for _, tween in Tweens.End do
						tween:Play()
					end
				end
				
				logs[noti.Message].remove = function()	
					if not logs[noti.Message] then return end
					
					logs[noti.Message].AnimEnd()

					task.wait(.2)

					if not logs[noti.Message] then return end
					objMsg.Border:Destroy()
					logs[noti.Message] = nil 
				end
				
				logs[noti.Message].start = function()		
					if noti.LastDuration then
						noti.Duration = logs.LastDuration and logs.LastDuration or noti.Duration
					end
					
					logs.LastDuration = noti.Duration
					logs[noti.Message].AnimStart()
					
					task.wait(noti.Duration)
					
					if not logs[noti.Message] then return end
					logs[noti.Message].remove()
				end
				
				coroutine.wrap(logs[noti.Message].start)()
				objMsg.Text.Changed:Connect(logs[noti.Message].BoundChanged)
			end
			
			return logs[noti.Message]
		end

		logs.remove = function( msg )
			if not logs[msg] then return end
			
			logs[msg].remove()
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
		Color = tbl.Color or Color3.fromRGB(255, 255, 255),
		Table = tbl.Table,
		Object = tbl.Object,
		Parent = tbl.Parent
	}

	if not cursor.Parent or not cursor.Table.minimize then 
		return warn("cursor: Missing Arguments") 
	end

	--[[ Functions ]] do
		
		cursor.spawn = function()
			local Cursor = Instance.new("ImageLabel")

			Cursor.Name = "Cursor"
			Cursor.AnchorPoint = cursor.Assets["Static"][2]
			Cursor.Size = UDim2.new(0, 32, 0, 32)
			Cursor.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Cursor.BackgroundTransparency = 1
			Cursor.Position = UDim2.new(0, 0, 0, 0)
			Cursor.BorderSizePixel = 0
			Cursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Cursor.Image = cursor.Assets["Static"][1]
			Cursor.ZIndex = 9999
			Cursor.Parent = cursor.Parent

			cursor.pointer = Cursor
		end

		cursor.switch = function(style)
			cursor.pointer.AnchorPoint = cursor.Assets[style][2]
			cursor.pointer.Image = cursor.Assets[style][1]
		end

		cursor.moved = function()
			local mouselocation = UserInput:GetMouseLocation()

			UserInput.MouseIconEnabled = not cursor.Table.minimize.Enabled
			cursor.pointer.Visible = cursor.Table.minimize.Enabled
			cursor.pointer.Position = UDim2.fromOffset(mouselocation.X, mouselocation.Y)

			local hoveredMouse = Vector2.new(mouselocation.X, mouselocation.Y - Gui:GetGuiInset().Y)

			local hoveredElements = {
				Tools.GuiObjByPosition({"GuiButton"}, hoveredMouse),
				Tools.GuiObjByPosition({"Name", "Resize"}, hoveredMouse)
			}

			if #hoveredElements[1] > 0 then
				cursor.switch("Button")
				return
			end
			
			if cursor.Table.resize then
				if #hoveredElements[2] > 0 or cursor.Table.resize.Active then
					cursor.switch("Resize")
					return
				end
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

	if not mini.Object or not mini.Object[1] or not mini.Object[1]:IsA("CanvasGroup") then return warn("minimize: Missing Arguments") end

	--[[ Functions ]] do
		if mini.Object[2] then
			mini.MouseEnter = function()
				if mini.Active then return end
				mini.Object[2].Text = "○"
			end

			mini.MouseLeave = function()
				mini.Object[2].Text = "●"
			end
		end
		
		mini.Anim = function(bool)
			mini.Active = true
			Tween:Create(mini.Object[1], Tools.TweenInfo, {GroupTransparency = bool and 0 or 1}):Play()

			if bool then
				mini.Object[1].Visible = true
			end

			task.wait(.2)

			mini.Object[1].Visible = bool
			if mini.Object[2] then
				mini.MouseLeave()
			end
				
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
		if mini.Object[2] then
			table.insert(mini.Connections, mini.Object[2].MouseButton1Click:Connect(mini.Open))
			table.insert(mini.Connections, mini.Object[2].MouseEnter:Connect(mini.MouseEnter))
			table.insert(mini.Connections, mini.Object[2].MouseLeave:Connect(mini.MouseLeave))
		end
		
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
	
	if not drag.Object or not drag.Object[1] or not drag.Object[2] then return warn("drag: Missing Arguments") end

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

	if not resize.Object or not resize.Object[1] or not resize.Object[2] then return warn("resize: Missing Arguments") end

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
