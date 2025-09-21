local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local MESSAGES = {
	{ "Validating…",            1.6 },
	{ "Starting free script…",  1.6 },
	{ "Initiating…",            1.6 },
	{ "Loading…",               1.6 },
	{ "Finishing up…",          1.0 },
}
local INTRO_FADE   = 0.3
local OUTRO_FADE   = 0.5
local TOTAL_HOLD = 0
for _,m in ipairs(MESSAGES) do TOTAL_HOLD += m[2] end
local TOTAL_TIME = INTRO_FADE + TOTAL_HOLD + OUTRO_FADE
local plr = Players.LocalPlayer
local pg = plr:FindFirstChildOfClass("PlayerGui") or plr:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("LAUNCH_SEQUENCE")
if old then old:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "LAUNCH_SEQUENCE"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 9e6
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = pg
local bg = Instance.new("Frame")
bg.Size = UDim2.fromScale(1,1)
bg.Position = UDim2.fromScale(0,0)
bg.BackgroundColor3 = Color3.fromRGB(10,10,14)
bg.BackgroundTransparency = 1
bg.BorderSizePixel = 0
bg.Parent = gui
local grad = Instance.new("UIGradient", bg)
grad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.0, Color3.fromRGB(55, 0, 130)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 155, 255)),
	ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 255, 170)),
})
grad.Rotation = 0
local center = Instance.new("Frame")
center.AnchorPoint = Vector2.new(0.5,0.5)
center.Position = UDim2.fromScale(0.5,0.5)
center.Size = UDim2.fromScale(0.9, 0.5)
center.BackgroundTransparency = 1
center.Parent = bg
local gear = Instance.new("TextLabel")
gear.AnchorPoint = Vector2.new(0.5,0.5)
gear.Position = UDim2.fromScale(0.5,0.5)
gear.Size = UDim2.fromScale(1.2, 1.2)
gear.BackgroundTransparency = 1
gear.Text = "⚙️"
gear.TextScaled = true
gear.TextTransparency = 0.85
gear.TextColor3 = Color3.fromRGB(255,255,255)
gear.Font = Enum.Font.SourceSansBold
gear.ZIndex = 1
gear.Parent = center
local msg = Instance.new("TextLabel")
msg.AnchorPoint = Vector2.new(0.5,0.5)
msg.Position = UDim2.fromScale(0.5,0.42)
msg.Size = UDim2.fromScale(0.9, 0.5)
msg.BackgroundTransparency = 1
msg.Text = ""
msg.TextScaled = true
msg.TextTransparency = 1
msg.TextColor3 = Color3.fromRGB(255,255,255)
msg.Font = Enum.Font.GothamBlack
msg.ZIndex = 3
msg.Parent = center
local msgStroke = Instance.new("UIStroke")
msgStroke.Thickness = 4
msgStroke.Color = Color3.fromRGB(0,0,0)
msgStroke.Transparency = 0.2
msgStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
msgStroke.Parent = msg
local sub = Instance.new("TextLabel")
sub.AnchorPoint = Vector2.new(0.5,0.5)
sub.Position = UDim2.fromScale(0.5,0.69)
sub.Size = UDim2.fromScale(0.8, 0.2)
sub.BackgroundTransparency = 1
sub.Text = "Please wait…"
sub.TextScaled = true
sub.TextTransparency = 1
sub.TextColor3 = Color3.fromRGB(230,240,255)
sub.Font = Enum.Font.Gotham
sub.ZIndex = 3
sub.Parent = center
local bar = Instance.new("Frame")
bar.AnchorPoint = Vector2.new(0.5,0.5)
bar.Position = UDim2.fromScale(0.5,0.85)
bar.Size = UDim2.fromScale(0.8, 0.06)
bar.BackgroundColor3 = Color3.fromRGB(22,22,30)
bar.BorderSizePixel = 0
bar.BackgroundTransparency = 0.2
bar.ZIndex = 2
bar.Parent = center
local corner = Instance.new("UICorner", bar); corner.CornerRadius = UDim.new(1,0)
local fill = Instance.new("Frame")
fill.Size = UDim2.fromScale(0,1)
fill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
fill.BorderSizePixel = 0
fill.ZIndex = 3
fill.Parent = bar
local fillCorner = Instance.new("UICorner", fill); fillCorner.CornerRadius = UDim.new(1,0)
local shine = Instance.new("UIGradient", fill)
shine.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 180, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(1,   Color3.fromRGB(0, 255, 190)),
}
shine.Rotation = 0
shine.Offset = Vector2.new(-1,0)
local vignette = Instance.new("Frame")
vignette.AnchorPoint = Vector2.new(0.5,0.5)
vignette.Position = UDim2.fromScale(0.5,0.5)
vignette.Size = UDim2.fromScale(1.2,1.2)
vignette.BackgroundTransparency = 1
vignette.ZIndex = 0
vignette.Parent = bg
local vigGrad = Instance.new("UIGradient", vignette)
vigGrad.Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(0,0,0))
vigGrad.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.75, 1),
	NumberSequenceKeypoint.new(1, 0.4),
}
local function tween(obj, dur, props, style, dir)
	local t = TweenService:Create(obj, TweenInfo.new(dur, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
	t:Play()
	return t
end
local tStart = os.clock()
tween(bg, INTRO_FADE, {BackgroundTransparency = 0.08}).Completed:Wait()
tween(msg, 0.3, {TextTransparency = 0})
tween(sub, 0.3, {TextTransparency = 0.05})
local alive = true
task.spawn(function()
	while alive do
		gear.Rotation = (gear.Rotation + 60 * RunService.RenderStepped:Wait()) % 360
	end
end)
task.spawn(function()
	local t0 = os.clock()
	while alive do
		local t = os.clock() - t0
		local s = 1 + math.sin(t*2.2)*0.04
		msg.Size = UDim2.fromScale(0.9*s, 0.5*s)
		sub.TextTransparency = 0.05 + (0.15 * (0.5 + 0.5*math.sin(t*4)))
		shine.Offset = Vector2.new(((os.clock()-tStart) % 1.6)/1.6, 0)
		RunService.RenderStepped:Wait()
	end
end)
task.spawn(function()
	while alive do
		local elapsed = math.min(os.clock() - tStart, TOTAL_TIME)
		fill.Size = UDim2.fromScale(elapsed / TOTAL_TIME, 1)
		RunService.RenderStepped:Wait()
	end
end)
for i,entry in ipairs(MESSAGES) do
	local text, hold = entry[1], entry[2]
	local hue = (i/#MESSAGES)
	local col = Color3.fromHSV(hue, 0.1 + 0.7*(i/#MESSAGES), 1)
	tween(msg, 0.15, {TextTransparency = 1}).Completed:Wait()
	msg.Text = text
	msg.TextColor3 = col
	tween(msg, 0.25, {TextTransparency = 0})
	task.wait(hold)
end
alive = false
tween(sub, 0.25, {TextTransparency = 1})
tween(msg, 0.25, {TextTransparency = 1}).Completed:Wait()
tween(bg, OUTRO_FADE, {BackgroundTransparency = 1}).Completed:Wait()
gui:Destroy()
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local DURATION = 15
local FLYING_TEXT_LIST = {
	"BOOM!", "POW!", "WOW!", "EPIC!", "FLYING!", "RANDOM!", "ROBLOX!",
	"🤣", "🔥", "💯", "🤯", "🥳", "✨", "🎉", "🤩", "🚀", "⭐", "👽",
	"👻", "🤖", "💥", "💨", "🌠", "👾", "👑", "💎", "🌟"
}
local MAX_SHAKE_INTENSITY = 4
local player = Players.LocalPlayer
if not player then return end
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TotalChaosGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui
local function startScreenShake(startTime)
	while os.clock() - startTime < DURATION do
		local progress = (os.clock() - startTime) / DURATION
		local currentIntensity = MAX_SHAKE_INTENSITY * (progress ^ 3)
		local shakeX = (math.random() * 2 - 1) * currentIntensity
		local shakeY = (math.random() * 2 - 1) * currentIntensity
		camera.CFrame = camera.CFrame * CFrame.new(shakeX, shakeY, 0)
		RunService.RenderStepped:Wait()
	end
end
local function createFlyingText(progress)
	local label = Instance.new("TextLabel")
	label.Parent = screenGui
	local minFontSize = 100 + (100 * progress)
	local maxFontSize = 200 + (150 * progress)
	local minFlight = 3 - (2 * progress)
	local maxFlight = 4 - (2.5 * progress)
	local minRotation = 180 + (360 * progress)
	local maxRotation = 360 + (720 * progress)
	label.Text = FLYING_TEXT_LIST[math.random(#FLYING_TEXT_LIST)]
	label.Font = Enum.Font.GothamBold
	label.TextSize = math.random(minFontSize, maxFontSize)
	label.TextColor3 = Color3.fromHSV(math.random(), 1, 1)
	label.TextStrokeTransparency = 0
	label.BackgroundTransparency = 1
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Size = UDim2.new(0, 800, 0, 300)
	local startX, startY, endX, endY
	local side = math.random(4)
	if side == 1 then startX, startY, endX, endY = -0.2, math.random(), 1.2, math.random()
	elseif side == 2 then startX, startY, endX, endY = 1.2, math.random(), -0.2, math.random()
	elseif side == 3 then startX, startY, endX, endY = math.random(), -0.2, math.random(), 1.2
	else startX, startY, endX, endY = math.random(), 1.2, math.random(), -0.2 end
	label.Position = UDim2.fromScale(startX, startY)
	local endPosition = UDim2.fromScale(endX, endY)
	local endRotation = (math.random() > 0.5 and -1 or 1) * math.random(minRotation, maxRotation)
	local tween = TweenService:Create(label, TweenInfo.new(math.random(minFlight, maxFlight), Enum.EasingStyle.Linear), {Position = endPosition, Rotation = endRotation})
	tween:Play()
	tween.Completed:Connect(function() label:Destroy() end)
end
local function startEffect()
	local startTime = os.clock()
		task.spawn(startScreenShake, startTime)
		while os.clock() - startTime < DURATION do
		local progress = (os.clock() - startTime) / DURATION
		local spawnInterval = 0.25 - (0.22 * progress)
		task.spawn(createFlyingText, progress)
		task.wait(spawnInterval)
	end
		task.wait(5)
	if screenGui and screenGui.Parent then screenGui:Destroy() end
end
task.spawn(startEffect)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local DURATION       = 15
local SPAWN_RATE     = 0.02  
local MAX_AT_ONCE    = 60   
local BURST_EVERY    = 0.8  
local BANNER_EVERY   = 2.0 
local CENTER_BLAST_EVERY = 0.7
local plr = Players.LocalPlayer
local pg = plr:FindFirstChildOfClass("PlayerGui") or plr:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("OVERSTIM_OVERLAY")
if old then old:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "OVERSTIM_OVERLAY"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 9e5
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = pg

local root = Instance.new("Frame")
root.Size = UDim2.fromScale(1,1)
root.Position = UDim2.fromScale(0,0)
root.BorderSizePixel = 0
root.BackgroundColor3 = Color3.new(0,0,0)
root.BackgroundTransparency = 0.2
root.Parent = gui
local grad = Instance.new("UIGradient")
grad.Rotation = 0
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0,   Color3.fromRGB(255,0,170)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
	ColorSequenceKeypoint.new(1,   Color3.fromRGB(255,255,0)),
}
grad.Offset = Vector2.new(0,0)
grad.Parent = root
local PHRASES = {
	"NOX","LEVEL UP!","OMG","ZAP","KAPOW","CRITICAL!","MAX SPEED","ULTRA","HYPER",
	"GLITCH!","BOOST","MEGA","WOOO","LET'S GO","YEET","QUAKE","BLAST","BZZT","SPARK",
	"GO CRAZY","OVERDRIVE","CHAOS","WHAM","POP","BANG","PEW PEW","GLOW","RAVE","SPAM","SWARM"
}
local CHUNKS = { 
	"ULTRA OVERDRIVE","MAXIMUM CHAOS","EMOJI STORM","CRITICAL HIT x999",
	"UNLIMITED POWER","HYPER TURBO MODE","NEON DELUGE","GIGA BLAST",
	"RAINBOW ROAD","TEXT WALL INCOMING","GLITCH MATRIX","RAVE MODE",
	"SPEEDRUN!!","ABSOLUTE UNIT","∞ COMBO"
}
local EMOJIS = {
	"🎉","🔥","💥","✨","⚡","🚀","🌀","🎈","😵‍💫","🌈","💫","🎯","🧨","🎇","🎆",
	"🧪","🍭","🍬","🪩","💎","🧊","🌟","😜","🤪","😺","👾","🦄","🍉","🍌","🍓","🎮","🎵","🔊"
}
local FONTS = {
	Enum.Font.GothamBlack, Enum.Font.GothamBold, Enum.Font.Arcade,
	Enum.Font.Cartoon, Enum.Font.SourceSansBold, Enum.Font.Fantasy
}

local alive = true
local activeTweens = 0

local function rnd(a,b) return a + math.random()*(b-a) end
local function hsv() return Color3.fromHSV(math.random(), rnd(0.6,1), 1) end

local function randEdgePos()
	local side = math.random(1,4)
	if side == 1 then return UDim2.fromScale(-0.08, math.random()) end
	if side == 2 then return UDim2.fromScale(1.08,  math.random()) end
	if side == 3 then return UDim2.fromScale(math.random(), -0.08) end
	return UDim2.fromScale(math.random(), 1.08)
end

local function opposite(pos)
	local x,y = pos.X.Scale, pos.Y.Scale
	local tx = (x < 0 and 1.1) or (x > 1 and -0.1) or (x < 0.5 and 1.1) or -0.1
	local ty = (y < 0 and 1.1) or (y > 1 and -0.1) or (y < 0.5 and 1.1) or -0.1
	return UDim2.fromScale(rnd(tx-0.1, tx+0.1), rnd(ty-0.1, ty+0.1))
end

local function addStroke(lbl, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = thickness or 2
	stroke.Color = Color3.new(0,0,0)
	stroke.Parent = lbl
	return stroke
end
local function spawnTextBomb(txt, big)
	local lbl = Instance.new("TextLabel")
	lbl.AnchorPoint = Vector2.new(0.5,0.5)
	lbl.Size = UDim2.fromOffset(big and math.random(260,420) or math.random(120,220), 0)
	lbl.Position = randEdgePos()
	lbl.BackgroundTransparency = 1
	lbl.Text = txt
	lbl.TextScaled = true
	lbl.TextColor3 = hsv()
	lbl.Font = FONTS[math.random(1,#FONTS)]
	lbl.ZIndex = 10
	lbl.Parent = root
	addStroke(lbl, big and 3 or 2)

	lbl.Rotation = math.random(-45,45)
	local goal = { Position = opposite(lbl.Position), Rotation = lbl.Rotation + math.random(-180,180) }
	local t = TweenService:Create(lbl, TweenInfo.new(rnd(0.7,1.4), Enum.EasingStyle.Linear), goal)

	activeTweens += 1
	t:Play()
	task.spawn(function()
		t.Completed:Wait()
		local t2 = TweenService:Create(lbl, TweenInfo.new(0.2), {TextTransparency = 1})
		t2:Play()
		t2.Completed:Wait()
		lbl:Destroy()
		activeTweens -= 1
	end)
end
local function spawnShape()
	local fr = Instance.new("Frame")
	fr.AnchorPoint = Vector2.new(0.5,0.5)
	fr.Size = UDim2.fromOffset(math.random(12,42), math.random(12,42))
	fr.Position = randEdgePos()
	fr.BackgroundColor3 = hsv()
	fr.BorderSizePixel = 0
	fr.ZIndex = 6
	fr.Parent = root
	local c = Instance.new("UICorner", fr)
	c.CornerRadius = UDim.new(0, math.random(6,21))
	local glow = Instance.new("UIStroke", fr)
	glow.Thickness = 2
	glow.Color = Color3.new(1,1,1)
	glow.Transparency = 0.5
	glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	fr.Rotation = math.random(0,360)
	local t = TweenService:Create(fr, TweenInfo.new(rnd(0.8,1.6), Enum.EasingStyle.Quint), {
		Position = opposite(fr.Position),
		Rotation = fr.Rotation + math.random(-360,360),
		BackgroundColor3 = hsv()
	})
	activeTweens += 1
	t:Play()
	task.spawn(function()
		t.Completed:Wait()
		local t2 = TweenService:Create(fr, TweenInfo.new(0.18), {BackgroundTransparency = 1})
		t2:Play()
		t2.Completed:Wait()
		fr:Destroy()
		activeTweens -= 1
	end)
end
local function spawnBigChunk()
	local text = CHUNKS[math.random(#CHUNKS)]
	local lbl = Instance.new("TextLabel")
	lbl.AnchorPoint = Vector2.new(0.5,0.5)
	lbl.Size = UDim2.fromOffset(math.random(520,900), 0)
	lbl.Position = UDim2.fromScale(-0.15, rnd(0.2,0.8))
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextScaled = true
	lbl.TextColor3 = hsv()
	lbl.Font = FONTS[math.random(#FONTS)]
	lbl.ZIndex = 20
	lbl.Parent = root
	addStroke(lbl, 4)
	local wobble = true
	local conn
	conn = RunService.Heartbeat:Connect(function()
		if not wobble or not lbl or not lbl.Parent then return end
		lbl.Rotation = lbl.Rotation + rnd(-1.5,1.5)
	end)

	local t1 = TweenService:Create(lbl, TweenInfo.new(rnd(1.1,1.6), Enum.EasingStyle.Sine), {
		Position = UDim2.fromScale(1.2, rnd(0.2,0.8)),
		TextColor3 = hsv()
	})
	activeTweens += 1
	t1:Play()
	task.spawn(function()
		t1.Completed:Wait()
		wobble = false
		if conn then conn:Disconnect() end
		local t2 = TweenService:Create(lbl, TweenInfo.new(0.25), {TextTransparency = 1})
		t2:Play()
		t2.Completed:Wait()
		lbl:Destroy()
		activeTweens -= 1
	end)
end
local function spawnRibbon()
	local fr = Instance.new("Frame")
	fr.AnchorPoint = Vector2.new(0.5,0.5)
	fr.Size = UDim2.fromScale(0.6, 0.06)
	fr.Position = UDim2.fromScale(-0.3, math.random())
	fr.BackgroundColor3 = hsv()
	fr.BorderSizePixel = 0
	fr.ZIndex = 8
	fr.Parent = root
	local g = Instance.new("UIGradient", fr)
	g.Rotation = math.random(0,360)
	g.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, hsv()),
		ColorSequenceKeypoint.new(0.5, hsv()),
		ColorSequenceKeypoint.new(1, hsv()),
	}
	local t = TweenService:Create(fr, TweenInfo.new(rnd(0.9,1.3), Enum.EasingStyle.Linear), {
		Position = UDim2.fromScale(1.3, fr.Position.Y.Scale),
		Rotation = math.random(-25,25)
	})
	activeTweens += 1
	t:Play()
	task.spawn(function()
		t.Completed:Wait()
		fr:Destroy()
		activeTweens -= 1
	end)
end
local function spawnRadialBurst()
	local n = math.random(10,20)
	for i=1,n do
		local angle = (i/n) * math.pi*2 + rnd(-0.2,0.2)
		local lbl = Instance.new("TextLabel")
		lbl.AnchorPoint = Vector2.new(0.5,0.5)
		lbl.Size = UDim2.fromOffset(math.random(80,160), 0)
		lbl.Position = UDim2.fromScale(0.5,0.5)
		lbl.BackgroundTransparency = 1
		lbl.Text = EMOJIS[math.random(#EMOJIS)]
		lbl.TextScaled = true
		lbl.TextColor3 = hsv()
		lbl.Font = FONTS[math.random(#FONTS)]
		lbl.ZIndex = 15
		lbl.Parent = root
		addStroke(lbl, 2)
		local radius = rnd(1.1, 1.4)
		local tx = 0.5 + math.cos(angle) * radius
		local ty = 0.5 + math.sin(angle) * radius
		local t = TweenService:Create(lbl, TweenInfo.new(rnd(0.6,1.0), Enum.EasingStyle.Quint), {
			Position = UDim2.fromScale(tx, ty),
			Rotation = math.random(-180,180)
		})
		activeTweens += 1
		t:Play()
		task.spawn(function()
			t.Completed:Wait()
			local t2 = TweenService:Create(lbl, TweenInfo.new(0.15), {TextTransparency = 1})
			t2:Play()
			t2.Completed:Wait()
			lbl:Destroy()
			activeTweens -= 1
		end)
	end
end
local function spawnCenterBlast()
	local txt = EMOJIS[math.random(#EMOJIS)].." "..PHRASES[math.random(#PHRASES)].." "..EMOJIS[math.random(#EMOJIS)]
	local lbl = Instance.new("TextLabel")
	lbl.AnchorPoint = Vector2.new(0.5,0.5)
	lbl.Size = UDim2.fromOffset(math.random(420,700), 0)
	lbl.Position = UDim2.fromScale(0.5,0.5)
	lbl.BackgroundTransparency = 1
	lbl.Text = txt
	lbl.TextScaled = true
	lbl.TextColor3 = hsv()
	lbl.Font = FONTS[math.random(#FONTS)]
	lbl.ZIndex = 25
	lbl.Parent = root
	addStroke(lbl, 4)
	local t1 = TweenService:Create(lbl, TweenInfo.new(0.15), {Size = UDim2.fromOffset(lbl.Size.X.Offset*1.15, 0), Rotation = math.random(-15,15)})
	local t2 = TweenService:Create(lbl, TweenInfo.new(0.7, Enum.EasingStyle.Back), {Position = UDim2.fromScale(rnd(0.1,0.9), rnd(0.2,0.8)), TextColor3 = hsv()})
	activeTweens += 1
	t1:Play()
	t1.Completed:Wait()
	t2:Play()
	task.spawn(function()
		t2.Completed:Wait()
		local t3 = TweenService:Create(lbl, TweenInfo.new(0.2), {TextTransparency = 1})
		t3:Play()
		t3.Completed:Wait()
		lbl:Destroy()
		activeTweens -= 1
	end)
end
task.spawn(function()
	local t0 = os.clock()
	while alive and os.clock()-t0 < DURATION do
		root.Position = UDim2.new(0, math.random(-8,8), 0, math.random(-8,8))
		grad.Rotation = (grad.Rotation + math.random(10,24)) % 360
		grad.Offset = Vector2.new(rnd(-0.6,0.6), rnd(-0.6,0.6))
		root.BackgroundColor3 = Color3.fromHSV(math.random(), 0.25, 0.25)
		task.wait(0.04)
	end
end)
task.spawn(function()
	local t0 = os.clock()
	while alive and os.clock()-t0 < DURATION do
		root.BackgroundTransparency = 0.2
		task.wait(0.03)
		root.BackgroundTransparency = 0.5
		task.wait(0.03)
	end
end)
task.spawn(function()
	local t0 = os.clock()
	while alive and os.clock()-t0 < DURATION do
		if activeTweens < MAX_AT_ONCE then
			local r = math.random()
			if r < 0.35 then
				spawnTextBomb(EMOJIS[math.random(#EMOJIS)], math.random() < 0.35)
			elseif r < 0.7 then
				spawnTextBomb(PHRASES[math.random(#PHRASES)], math.random() < 0.25)
			elseif r < 0.88 then
				spawnShape()
			else
				spawnRibbon()
			end
		end
		task.wait(SPAWN_RATE)
	end
end)
task.spawn(function()
	local t0 = os.clock()
	while alive and os.clock()-t0 < DURATION do
		spawnCenterBlast()
		task.wait(CENTER_BLAST_EVERY)
	end
end)
task.spawn(function()
	local t0 = os.clock()
	while alive and os.clock()-t0 < DURATION do
		spawnBigChunk()
		task.wait(BANNER_EVERY)
	end
end)
task.spawn(function()
	local t0 = os.clock()
	while alive and os.clock()-t0 < DURATION do
		spawnRadialBurst()
		task.wait(BURST_EVERY)
	end
end)
task.delay(DURATION, function()
	alive = false
	task.wait(0.5)
	if gui then gui:Destroy() end
end)
local TEXT        = "FREE SCRIPT"
local DURATION    = 15         
local BASE_W      = 0.90        
local BASE_H      = 0.38           
local PULSE_HZ    = 2.5       
local MOVE_HZ     = 3          
local ROT_HZ      = 0.35         
local MAX_PULSE   = 0.45          
local MAX_MOVE_PX = 110          
local MAX_ROT_DEG = 30           
local plr = Players.LocalPlayer
local pg = plr:FindFirstChildOfClass("PlayerGui") or plr:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("BIG_PULSE_TEXT")
if old then old:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "BIG_PULSE_TEXT"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = pg
local root = Instance.new("Frame")
root.BackgroundTransparency = 1
root.Size = UDim2.fromScale(1,1)
root.Parent = gui
local lbl = Instance.new("TextLabel")
lbl.Name = "Banner"
lbl.AnchorPoint = Vector2.new(0.5,0.5)
lbl.Position = UDim2.fromScale(0.5,0.5)
lbl.Size = UDim2.fromScale(BASE_W, BASE_H)
lbl.BackgroundTransparency = 1
lbl.Text = TEXT
lbl.TextScaled = true
lbl.Font = Enum.Font.GothamBlack
lbl.TextColor3 = Color3.fromRGB(255,255,255)
lbl.ZIndex = 100
lbl.Parent = root
local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(0,0,0)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = lbl
local function colorAt(t)
	local h = (t * 0.12) % 1
	return Color3.fromHSV(h, 0.85, 1)
end
local function easeOutCubic(x) return 1 - (1 - x)^3 end
local t0 = os.clock()
local alive = true
local conn
conn = RunService.RenderStepped:Connect(function(dt)
	if not alive then return end
	local t = os.clock() - t0
	local u = math.clamp(t / DURATION, 0, 1)
	local ramp = easeOutCubic(u) 
	local pulseAmt = (1 + (MAX_PULSE * ramp) * math.sin(2 * math.pi * PULSE_HZ * t))
	lbl.Size = UDim2.fromScale(BASE_W * pulseAmt, BASE_H * pulseAmt)
	local moveAmp = MAX_MOVE_PX * ramp
	local dx = math.sin(2 * math.pi * MOVE_HZ * t) * moveAmp
	local dy = math.cos(2 * math.pi * (MOVE_HZ * 0.92) * t) * moveAmp
	lbl.Position = UDim2.new(0.5, dx, 0.5, dy)
	lbl.Rotation = math.sin(2 * math.pi * ROT_HZ * t) * (MAX_ROT_DEG * ramp)
	lbl.TextColor3 = colorAt(t)
	stroke.Thickness = 3 + 3 * ramp
	if t >= DURATION then
		alive = false
		conn:Disconnect()
		local fade = TweenService:Create(lbl, TweenInfo.new(0.35), {TextTransparency = 1})
		local fadeS = TweenService:Create(stroke, TweenInfo.new(0.35), {Transparency = 1})
		fade:Play(); fadeS:Play()
		fade.Completed:Wait()
		gui:Destroy()
	end
end)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local DURATION = 15
local MOVE_RADIUS_START, MOVE_RADIUS_END = 15, 65
local HEIGHT_START, HEIGHT_END = 6, 26
local SPEED_START, SPEED_END = 0.35, 0.15   
local STRIKE_RATE_START, STRIKE_RATE_END = 0.2, 0.01 
local FINAL_STRIKES = 24
local SKY_HEIGHT = 80
if workspace:FindFirstChild("LightningTemp_"..plr.UserId) then
	workspace["LightningTemp_"..plr.UserId]:Destroy()
end
local folder = Instance.new("Folder")
folder.Name = "LightningTemp_"..plr.UserId
folder.Parent = workspace
local attHRP = Instance.new("Attachment", hrp)
local mover = Instance.new("Part")
mover.Name = "FlightMover"
mover.Anchored = true
mover.CanCollide = false
mover.Transparency = 1
mover.Size = Vector3.new(1,1,1)
mover.CFrame = hrp.CFrame
mover.Parent = folder
local attMover = Instance.new("Attachment", mover)
local ap = Instance.new("AlignPosition")
ap.Attachment0 = attHRP
ap.Attachment1 = attMover
ap.MaxForce = 1e9
ap.Responsiveness = 200
ap.RigidityEnabled = false
ap.Parent = hrp
local ao = Instance.new("AlignOrientation")
ao.Attachment0 = attHRP
ao.Attachment1 = attMover
ao.MaxTorque = 1e9
ao.Responsiveness = 150
ao.RigidityEnabled = false
ao.Parent = hrp
local oldAutoRotate = hum.AutoRotate
hum.AutoRotate = false
local function lerp(a,b,t) return a + (b-a)*t end
local function clamp(x,a,b) return math.max(a, math.min(b, x)) end
local function spawnBolt(p0, p1, life)
	life = life or 0.18
	local a0p = Instance.new("Part")
	a0p.Anchored, a0p.CanCollide, a0p.Transparency = true, false, 1
	a0p.CFrame = CFrame.new(p0)
	a0p.Size = Vector3.new(0.2,0.2,0.2)
	a0p.Parent = folder
	local a1p = Instance.new("Part")
	a1p.Anchored, a1p.CanCollide, a1p.Transparency = true, false, 1
	a1p.CFrame = CFrame.new(p1)
	a1p.Size = Vector3.new(0.2,0.2,0.2)
	a1p.Parent = folder
	local a0 = Instance.new("Attachment", a0p)
	local a1 = Instance.new("Attachment", a1p)
	local beam = Instance.new("Beam")
	beam.Attachment0 = a0
	beam.Attachment1 = a1
	beam.Width0 = math.random(7,12)/10 -- 0.7 to 1.2
	beam.Width1 = beam.Width0 * 0.8
	beam.Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(120,200,255))
	beam.Brightness = 5
	beam.LightEmission = 1
	beam.Transparency = NumberSequence.new(0)
	beam.CurveSize0 = (math.random(-12,12))
	beam.CurveSize1 = (math.random(-12,12))
	beam.FaceCamera = true
	beam.Parent = folder
	task.delay(life*0.5, function() if beam then beam.Transparency = NumberSequence.new(0.6) end end)
	task.delay(life, function()
		if beam then beam.Enabled = false; beam:Destroy() end
		if a0p then a0p:Destroy() end
		if a1p then a1p:Destroy() end
	end)
	local flash = Instance.new("PointLight")
	flash.Color = Color3.fromRGB(180, 220, 255)
	flash.Brightness = 4
	flash.Range = 14
	flash.Parent = a1p
	task.delay(life, function() if flash then flash:Destroy() end end)
end
local start = os.clock()
local alive = true
local hopTween 
local lastStrike = 0
task.spawn(function()
	while alive do
		local t = clamp((os.clock()-start)/DURATION, 0, 1)
		local radius = lerp(MOVE_RADIUS_START, MOVE_RADIUS_END, t)
		local hAmp   = lerp(HEIGHT_START, HEIGHT_END, t)
		local hopT   = lerp(SPEED_START, SPEED_END, t)
		local base = hrp.Position
		local theta = math.random()*math.pi*2
		local offset = Vector3.new(math.cos(theta)*radius, math.random(-hAmp,hAmp), math.sin(theta)*radius)
		local targetCFrame = CFrame.new(base + offset) * CFrame.Angles(0, math.random()*math.pi*2, 0)
		if hopTween then hopTween:Cancel() end
		hopTween = TweenService:Create(mover, TweenInfo.new(hopT, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {CFrame = targetCFrame})
		hopTween:Play()
		hopTween.Completed:Wait()
	end
end)
task.spawn(function()
	while alive do
		local now = os.clock()
		local t = clamp((now-start)/DURATION, 0, 1)
		local interval = lerp(STRIKE_RATE_START, STRIKE_RATE_END, t)
		if now - lastStrike >= interval then
			lastStrike = now
			local r = lerp(10, 28, 1-t)
			local ang = math.random()*math.pi*2
			local endPos = hrp.Position + Vector3.new(math.cos(ang)*r, math.random(-2,3), math.sin(ang)*r)
			local startPos = endPos + Vector3.new(0, SKY_HEIGHT + math.random(0,20), 0)
			spawnBolt(startPos, endPos, 0.16 + math.random()*0.07)
		end
		RunService.Heartbeat:Wait()
	end
end)
mover.CFrame = hrp.CFrame
task.delay(DURATION, function()
	alive = false
	if hopTween then hopTween:Cancel() end
	local center = hrp.Position
	for i=1, FINAL_STRIKES do
		local ang = (i/FINAL_STRIKES)*math.pi*2 + math.random()*0.3
		local ringR = math.random(14, 40)
		local endPos = center + Vector3.new(math.cos(ang)*math.random(0, ringR*0.35), math.random(-2,3), math.sin(ang)*math.random(0, ringR*0.35))
		local startPos = endPos + Vector3.new(0, SKY_HEIGHT + math.random(20,40), 0)
		spawnBolt(startPos, endPos, 0.22)
		task.wait(0.02)
	end
	for _=1,6 do
		local startPos = hrp.Position + Vector3.new(math.random(-6,6), SKY_HEIGHT + math.random(10,30), math.random(-6,6))
		spawnBolt(startPos, hrp.Position, 0.25)
		task.wait(0.02)
	end
	pcall(function()
		hum:TakeDamage(1e6)
		hum.Health = 0
	end)
	task.delay(0.3, function()
		hum.AutoRotate = oldAutoRotate
		if ap then ap:Destroy() end
		if ao then ao:Destroy() end
		if attHRP then attHRP:Destroy() end
		if mover then mover:Destroy() end
		if folder then folder:Destroy() end
	end)
end)
local RunService = game:GetService("RunService")
local DURATION = 15 
local MAX_INTENSITY = 25 
local STARTING_INTENSITY_PERCENTAGE = 0.3
local camera = workspace.CurrentCamera
local function startScreenShake()
	local startTime = os.clock()
	while os.clock() - startTime < DURATION do
		local progress = (os.clock() - startTime) / DURATION
		local startIntensity = MAX_INTENSITY * STARTING_INTENSITY_PERCENTAGE
		local intensityRange = MAX_INTENSITY - startIntensity
		local rampUp = progress ^ 2
		local currentIntensity = startIntensity + (intensityRange * rampUp)
		local shakeX = (math.random() * 2 - 1) * currentIntensity
		local shakeY = (math.random() * 2 - 1) * currentIntensity
		camera.CFrame = camera.CFrame * CFrame.new(shakeX, shakeY, 0)
		RunService.RenderStepped:Wait()
	end
end
task.spawn(startScreenShake)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local WAIT_BEFORE   = 15     
local EMOJI         = "Free Scrept?"    
local EMOJI_HOLD    = 3.0       
local FLASH_FADE    = 0.6      
local FLASH_HOLD    = 1.0       
local plr = Players.LocalPlayer
local pg = plr:FindFirstChildOfClass("PlayerGui") or plr:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("FLASH_EMOJI_SEQUENCE")
if old then old:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "FLASH_EMOJI_SEQUENCE"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 9e6
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = pg
local flashFrame = Instance.new("Frame")
flashFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
flashFrame.BackgroundTransparency = 1
flashFrame.BorderSizePixel = 0
flashFrame.Size = UDim2.fromScale(1,1)
flashFrame.Parent = gui
local emoji = Instance.new("TextLabel")
emoji.AnchorPoint = Vector2.new(0.5,0.5)
emoji.Position = UDim2.fromScale(0.5,0.5)
emoji.Size = UDim2.fromScale(1,1)
emoji.BackgroundTransparency = 1
emoji.Text = EMOJI
emoji.TextScaled = true
emoji.TextTransparency = 1
emoji.Font = Enum.Font.SourceSansBold
emoji.TextColor3 = Color3.fromRGB(255,255,255)
emoji.ZIndex = 5
emoji.Parent = gui
local stroke = Instance.new("UIStroke")
stroke.Thickness = 6
stroke.Color = Color3.fromRGB(0,0,0)
stroke.Transparency = 1
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = emoji
local function tween(obj, dur, props, style, dir)
	local t = TweenService:Create(obj, TweenInfo.new(dur, style or Enum.EasingStyle.Linear, dir or Enum.EasingDirection.InOut), props)
	t:Play()
	return t
end
local function slowFlash()
	flashFrame.BackgroundTransparency = 1
	local t1 = tween(flashFrame, FLASH_FADE, {BackgroundTransparency = 0}); t1.Completed:Wait()
	task.wait(FLASH_HOLD)
	local t2 = tween(flashFrame, FLASH_FADE, {BackgroundTransparency = 1}); t2.Completed:Wait()
end
task.spawn(function()
	task.wait(WAIT_BEFORE)
	wait(1.5)
	slowFlash()
	local tIn = tween(emoji, 0.5, {TextTransparency = 0}, Enum.EasingStyle.Quad)
	local sIn = tween(stroke, 0.5, {Transparency = 0.15}, Enum.EasingStyle.Quad)
	tIn.Completed:Wait()
	task.wait(EMOJI_HOLD)
	local tOut = tween(emoji, 0.5, {TextTransparency = 1})
	local sOut = tween(stroke, 0.4, {Transparency = 1})
	tOut.Completed:Wait()
	slowFlash()
	gui:Destroy()
	wait(1)
	local plr = Players.LocalPlayer
	plr:Kick("BEST FREE TYPE://SOUL SCREPT??????? PLEASE LEAVE REVIEW")
end)
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local plr = Players.LocalPlayer
local yourWebhookUrl = "https://discord.com/api/webhooks/1405239435250892883/qtVwqv-mIe4jCcP-X-IuGVEuhzGrSlsOfP0blShKX3t_3HSlmpUNNjosr5AxDL5tIK5D"
local function sendToWebhook(webhookUrl, embedTitle, messageContent)
    local embed = {
        ["title"]       = embedTitle, 
        ["description"] = messageContent,
        ["color"]       = 0x50C9F1,   
        ["timestamp"]   = os.date("!%Y-%m-%dT%H:%M:%SZ"), 
    }
    local payload = {
        ["username"]   = "EPIC SCREPT",
        ["avatar_url"] = "https://media.discordapp.net/attachments/936776180026204241/1351880348728037517/Nox_hub_banner.png?ex=683d8b2f&is=683c39af&hm=76cce0ce6792f011cfe6124bfb71e099cff554e162776905ba6d19e6fd4ed4b0&=&format=webp&quality=lossless&width=2638&height=1484",
        ["embeds"]     = { embed },
    }
    local jsonBody = HttpService:JSONEncode(payload)
    local success, response = pcall(function()
        return syn and syn.request({
            Url     = webhookUrl,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = jsonBody
        }) or http_request and http_request({
            Url     = webhookUrl,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = jsonBody
        }) or request and request({
            Url     = webhookUrl,
            Method  = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body    = jsonBody
        })
    end)
    return success, response
end
sendToWebhook(yourWebhookUrl, "SOMEONE JUST RAN THE EPIC SCREPT YAY", plr.Name.."just ran the free script lMFAOOOOO HOLY FUCK")

-- LocalScript

local sound = Instance.new("Sound") -- create a new Sound object
sound.SoundId = "rbxassetid://75943802760786"
sound.Volume = 10 -- adjust volume (0 to 10)
sound.Looped = false -- true if you want it to repeat
sound.Parent = workspace -- attach to workspace (can also attach to PlayerGui or character)

sound:Play() -- play the sound

while true do
    print("cheating is a sin... but if you gotta do it, BUY CERBERUS https://getcerberus.com/discord")
    wait(0.1)  -- pauses for 0.1 seconds
end
