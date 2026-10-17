--==  Delta Dragon UI v7  |  By Diaa  ==--
local Players            = game:GetService("Players")
local UIS                = game:GetService("UserInputService")
local StarterGui         = game:GetService("StarterGui")
local RunService         = game:GetService("RunService")
local HttpService        = game:GetService("HttpService")
local TeleportService    = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local Workspace          = game:GetService("Workspace")
local Lighting           = game:GetService("Lighting")
local player = Players.LocalPlayer
local pg     = player:WaitForChild("PlayerGui")

------------------------------------------------------------
-- 1) ظ‚ط§ط¦ظ…ط© ALL: ط¹ظ†ط¯ظƒ 20 ط²ط± ظپط§ط¶ظٹ. ط¹ط¯ظ‘ظ„ ط§ظ„ط³ط·ط± ط§ظ„ظ„ظٹ طھط¨ظٹظ‡:
--    name = ط§ط³ظ… ط§ظ„ط²ط±
--    url  = ط±ط§ط¨ط· ط§ظ„ط³ظƒط±ط¨طھ  (ظ…ط«ط§ظ„: "https://raw.githubusercontent.com/...")
--    code = [[ ظƒظˆط¯ Lua ظ‚طµظٹط± ]]  (ط§ط®طھظٹط§ط±ظٹطŒ ط¨ط¯ظ„ ط§ظ„ط±ط§ط¨ط·)
--    desc = ظˆطµظپ ظٹط·ظ„ط¹ ظپظٹ ط§ظ„ط¨ط­ط« (ط§ط®طھظٹط§ط±ظٹ)
--    auto = true  (ط§ط®طھظٹط§ط±ظٹ: ظٹط´ط؛ظ„ ط§ظ„ط³ظƒط±ط¨طھ طھظ„ظ‚ط§ط¦ظٹط§ظ‹ ط£ظˆظ„ ظ…ط§ طھظپطھط­ ط§ظ„ظ„ظˆط­ط©)
------------------------------------------------------------
local MY_SLOTS = {
    { name = "Fly", url = "--[[
    ✨ Diaa Fly v28 — Real Stealth Edition ✨
    📱 Delta Executor | By Diaa
    🕵️ Real stealth: jitter + session randomization + timing breaks
    ⚠️  Disclaimer: No Lua script can bypass server-side anti-cheat
]]

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local Tween      = game:GetService("TweenService")
local CoreGui    = game:GetService("CoreGui")

local LP  = Players.LocalPlayer
local Cam = workspace.CurrentCamera

-- ═══════ تنظيف غامض ═══════
local _K = "_" .. tostring(#tostring(math.pi):sub(3, 9)) .. tostring(#tostring(math.huge):sub(1, 1))
local _G_T = (getgenv and getgenv()) or _G
if _G_T[_K] and type(_G_T[_K]) == "table" and _G_T[_K][1] then
    pcall(_G_T[_K][1])
    _G_T[_K] = nil
end

-- ═══════ مولّد أسماء عشوائي متقدم ═══════
local _charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local function _rnd(n)
    local t = {}
    for i = 1, n do
        local k = math.random(1, #_charset)
        t[i] = _charset:sub(k, k)
    end
    return table.concat(t)
end
local _NS = "_" .. _rnd(7) .. "_"

-- ═══════ بذور عشوائية للجلسة (لتخفي) ═══════
math.randomseed(tick() * 1000 + os.clock() * 100)

local _sess = {
    smooth     = 18 + math.random() * 14,       -- 18 - 32
    multVar    = 0.95 + math.random() * 0.10,    -- ±5%
    jitter     = 0.10 + math.random() * 0.15,    -- 0.10 - 0.25 stud/s
    deadzone   = 0.10 + math.random() * 0.04,    -- 0.10 - 0.14
    curve      = 1.3 + math.random() * 0.4,      -- 1.3 - 1.7
    lift       = 0.12 + math.random() * 0.06,    -- 0.12 - 0.18
    initDelay  = 0.05 + math.random() * 0.15,    -- 50-200ms
}

-- ═══════ التنظيف ═══════
local _con, _inst = {}, {}
local function _bind(c) _con[#_con+1] = c; return c end
local function _own(i)  _inst[#_inst+1] = i; return i end
local function _dispose()
    for i = #_con, 1, -1 do pcall(function() _con[i]:Disconnect() end) _con[i] = nil end
    for i = #_inst, 1, -1 do pcall(function() _inst[i]:Destroy() end) _inst[i] = nil end
end

-- ═══════ الإعدادات ═══════
local Speed      = 1.0
local Step       = 0.1
local MinSpeed   = 0.1
local MaxSpeed   = 20.0
local Multiplier = 45 * _sess.multVar

local _active = false
local _velVec = Vector3.zero
local _bg, _bf
local _loopConn
local _jumpQ = 0
local _cachedMass = 10
local _cachedGravity = workspace.Gravity

local _chr, _hum, _hrp, _anim

local function _refresh()
    _chr = LP.Character
    if _chr then
        _hum  = _chr:FindFirstChildOfClass("Humanoid")
        _hrp  = _chr:FindFirstChild("HumanoidRootPart")
        _anim = _hum and _hum:FindFirstChildOfClass("Animator")
    else
        _hum, _hrp, _anim = nil, nil, nil
    end
end
_refresh()

local function _computeMass()
    if not _hrp or not _hrp.Parent then return 10 end
    local ok, m = pcall(function() return _hrp.AssemblyMass end)
    if ok and m and m > 0 then return m end
    return 10
end

-- ═══════ الإدخال ═══════
local _thumb = Vector2.zero
_bind(UIS.InputChanged:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Thumbstick1 then
        _thumb = Vector2.new(input.Position.X, input.Position.Z)
    end
end))

local _touchData = {}
local _uiRect = nil

local function _isOnUI(p)
    if not _uiRect then return false end
    return p.X >= _uiRect[1] and p.X <= _uiRect[3] and p.Y >= _uiRect[2] and p.Y <= _uiRect[4]
end

_bind(UIS.TouchStarted:Connect(function(input)
    local p = input.Position
    if p.X < Cam.ViewportSize.X * 0.5 and not _isOnUI(p) then
        _touchData[input] = { ox = p.X, oy = p.Y, cx = p.X, cy = p.Y, t = tick() }
    end
end))

_bind(UIS.TouchMoved:Connect(function(input)
    local d = _touchData[input]
    if d then
        local p = input.Position
        d.cx, d.cy, d.t = p.X, p.Y, tick()
    end
end))

_bind(UIS.TouchEnded:Connect(function(input)
    _touchData[input] = nil
end))

local _src = "-"

local function _readInput()
    local tx, tz = _thumb.X, _thumb.Y
    if math.sqrt(tx*tx + tz*tz) > 0.01 then
        _src = "TS"; return Vector3.new(tx, 0, tz)
    end

    local vp = Cam.ViewportSize
    local maxDist = math.max(80, math.min(vp.X, vp.Y) * 0.22)
    local bestX, bestZ, bestM = 0, 0, 0
    local now = tick()

    for input, d in pairs(_touchData) do
        if now - d.t > 0.5 and (d.cx == d.ox and d.cy == d.oy) then
            _touchData[input] = nil
        else
            local dx, dy = d.cx - d.ox, d.cy - d.oy
            local m = math.sqrt(dx*dx + dy*dy)
            if m > bestM then bestM = m bestX = dx bestZ = dy end
        end
    end

    if bestM > 4 then
        local norm = math.min(bestM, maxDist) / maxDist
        _src = "T"
        return Vector3.new((bestX/bestM) * norm, 0, (bestZ/bestM) * norm)
    end

    _src = "-"
    return Vector3.zero
end

local function _applyCurve(v)
    local mag = v.Magnitude
    if mag < _sess.deadzone then return Vector3.zero end
    local norm = (mag - _sess.deadzone) / (1 - _sess.deadzone)
    norm = math.clamp(norm, 0, 1)
    local curved = norm ^ _sess.curve
    if mag > 0.001 then v = v.Unit * curved end
    return v
end

local function _toWorld(v)
    local cf = Cam.CFrame
    local dir = cf.RightVector * v.X + cf.LookVector * (-v.Z)
    if dir.Magnitude > 0.001 then
        dir = dir.Unit * v.Magnitude
    end
    return dir
end

-- ═══════ الواجهة ═══════
local _gui = _own(Instance.new("ScreenGui"))
_gui.Name = _NS .. _rnd(8)
_gui.ResetOnSpawn = false
_gui.IgnoreGuiInset = true
_gui.Parent = CoreGui

local _frame = _own(Instance.new("Frame"))
_frame.Name = _rnd(8)
_frame.Size = UDim2.new(0, 190, 0, 118)
_frame.Position = UDim2.new(0, 15, 0.4, 0)
_frame.BackgroundColor3 = Color3.fromRGB(18, 16, 25)
_frame.BorderSizePixel = 0
_frame.Active = true
_frame.Draggable = true
_frame.Parent = _gui
_own(Instance.new("UICorner", _frame)).CornerRadius = UDim.new(0, 14)

local _stroke = _own(Instance.new("UIStroke", _frame))
_stroke.Color = Color3.fromRGB(130, 70, 220)
_stroke.Thickness = 1.5
_stroke.Transparency = 0.2

local _grad = _own(Instance.new("UIGradient", _frame))
_grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 28, 58)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 13, 20))
}
_grad.Rotation = 90

local _title = _own(Instance.new("TextLabel"))
_title.Size = UDim2.new(1, 0, 0, 24)
_title.Position = UDim2.new(0, 0, 0, 6)
_title.BackgroundTransparency = 1
_title.Text = "By Diaa"
_title.Font = Enum.Font.GothamBold
_title.TextSize = 15
_title.TextColor3 = Color3.fromRGB(185, 135, 255)
_title.Parent = _frame

local _line = _own(Instance.new("Frame"))
_line.Size = UDim2.new(0.65, 0, 0, 1)
_line.Position = UDim2.new(0.175, 0, 0, 30)
_line.BackgroundColor3 = Color3.fromRGB(130, 70, 220)
_line.BorderSizePixel = 0
_line.Parent = _frame
_own(Instance.new("UIGradient", _line)).Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1)
}

local _btn = _own(Instance.new("TextButton"))
_btn.Size = UDim2.new(1, -28, 0, 30)
_btn.Position = UDim2.new(0, 14, 0, 38)
_btn.BackgroundColor3 = Color3.fromRGB(60, 40, 100)
_btn.BorderSizePixel = 0
_btn.Text = "✈  Fly : OFF"
_btn.Font = Enum.Font.GothamBold
_btn.TextSize = 13
_btn.TextColor3 = Color3.fromRGB(235, 230, 255)
_btn.AutoButtonColor = false
_btn.Parent = _frame
_own(Instance.new("UICorner", _btn)).CornerRadius = UDim.new(0, 10)

local _btnStroke = _own(Instance.new("UIStroke", _btn))
_btnStroke.Color = Color3.fromRGB(130, 70, 220)
_btnStroke.Thickness = 1

local _row = _own(Instance.new("Frame"))
_row.Size = UDim2.new(1, -28, 0, 32)
_row.Position = UDim2.new(0, 14, 0, 76)
_row.BackgroundColor3 = Color3.fromRGB(28, 23, 42)
_row.BorderSizePixel = 0
_row.Parent = _frame
_own(Instance.new("UICorner", _row)).CornerRadius = UDim.new(0, 10)

local _minus = _own(Instance.new("TextButton"))
_minus.Size = UDim2.new(0, 32, 1, 0)
_minus.BackgroundColor3 = Color3.fromRGB(85, 45, 145)
_minus.BorderSizePixel = 0
_minus.Text = "−"
_minus.Font = Enum.Font.GothamBold
_minus.TextSize = 20
_minus.TextColor3 = Color3.new(1,1,1)
_minus.AutoButtonColor = false
_minus.Parent = _row
_own(Instance.new("UICorner", _minus)).CornerRadius = UDim.new(0, 10)

local _plus = _own(Instance.new("TextButton"))
_plus.Size = UDim2.new(0, 32, 1, 0)
_plus.Position = UDim2.new(1, -32, 0, 0)
_plus.BackgroundColor3 = Color3.fromRGB(85, 45, 145)
_plus.BorderSizePixel = 0
_plus.Text = "+"
_plus.Font = Enum.Font.GothamBold
_plus.TextSize = 20
_plus.TextColor3 = Color3.new(1,1,1)
_plus.AutoButtonColor = false
_plus.Parent = _row
_own(Instance.new("UICorner", _plus)).CornerRadius = UDim.new(0, 10)

local _label = _own(Instance.new("TextLabel"))
_label.Size = UDim2.new(1, -64, 1, 0)
_label.Position = UDim2.new(0, 32, 0, 0)
_label.BackgroundTransparency = 1
_label.Text = "1.0"
_label.Font = Enum.Font.GothamBold
_label.TextSize = 14
_label.TextColor3 = Color3.fromRGB(200, 180, 255)
_label.Parent = _row

local function _updateUIRect()
    local ap, as = _frame.AbsolutePosition, _frame.AbsoluteSize
    _uiRect = { ap.X - 15, ap.Y - 15, ap.X + as.X + 15, ap.Y + as.Y + 15 }
end
_updateUIRect()
_bind(_frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(_updateUIRect))
_bind(_frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(_updateUIRect))

local function _updateLbl() _label.Text = string.format("%.1f", Speed) end

local function _pulse(b)
    Tween:Create(b, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(150,100,230)}):Play()
    task.delay(0.1, function()
        if b.Parent then
            Tween:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(85,45,145)}):Play()
        end
    end)
end

-- ═══════ الحالات ═══════
local _saved = {
    WalkSpeed = 16, JumpPower = 50, AutoRotate = true,
    PlatformStand = false,
    states = {}, animateDisabled = false,
    soundScriptDisabled = nil, mutedSounds = {},
}

local _idleTrack = nil

local function _startIdle()
    if not _chr or not _anim then return end
    local an = _chr:FindFirstChild("Animate")
    if not an then return end
    local idle = an:FindFirstChild("idle")
    if not idle then return end
    local id
    for _, a in ipairs(idle:GetChildren()) do
        if a:IsA("Animation") and a.AnimationId ~= "" then id = a.AnimationId break end
    end
    if not id then return end
    for _, t in ipairs(_anim:GetPlayingAnimationTracks()) do
        pcall(function() t:Stop(0) end)
    end
    local a = Instance.new("Animation")
    a.AnimationId = id
    local ok, tr = pcall(function() return _anim:LoadAnimation(a) end)
    if ok and tr then
        tr.Priority = Enum.AnimationPriority.Action4
        tr.Looped = true
        pcall(function() tr:Play(0) end)
        _idleTrack = tr
    end
end

local function _stopIdle()
    if _idleTrack then
        pcall(function() _idleTrack:Stop(0) end)
        _idleTrack = nil
    end
end

local function _mute()
    _saved.mutedSounds = {}
    if _chr then
        for _, s in ipairs(_chr:GetDescendants()) do
            if s:IsA("Sound") and s.Volume > 0 then
                _saved.mutedSounds[s] = s.Volume
                pcall(function() s.Volume = 0 end)
            end
        end
    end
    local ps = LP:FindFirstChild("PlayerScripts")
    if ps then
        local snd = ps:FindFirstChild("RbxCharacterSounds")
        if snd and not snd.Disabled then
            _saved.soundScriptDisabled = false
            pcall(function() snd.Disabled = true end)
        end
    end
end

local function _unmute()
    for s, v in pairs(_saved.mutedSounds) do
        if s and s.Parent then pcall(function() s.Volume = v end) end
    end
    _saved.mutedSounds = {}
    if _saved.soundScriptDisabled ~= nil then
        local ps = LP:FindFirstChild("PlayerScripts")
        local snd = ps and ps:FindFirstChild("RbxCharacterSounds")
        if snd then pcall(function() snd.Disabled = _saved.soundScriptDisabled end) end
        _saved.soundScriptDisabled = nil
    end
end

-- ═══════ فيزياء بتخفي ═══════
local function _createHelpers()
    _cachedMass = _computeMass()
    _cachedGravity = workspace.Gravity

    -- ترتيب عشوائي لضبط الخصائص (كسر البصمة)
    local order = { "bg", "bf" }
    if math.random() > 0.5 then order = { "bf", "bg" } end

    for _, v in ipairs(order) do
        if v == "bg" then
            _bg = Instance.new("BodyGyro")
            _bg.Name = _rnd(10)
            local torque = _cachedMass * (400000 + math.random() * 200000)
            _bg.MaxTorque = Vector3.new(torque, torque, torque)
            _bg.P = 15000 + math.random(-1000, 1000)
            _bg.D = 700 + math.random(-100, 100)
            _bg.CFrame = Cam.CFrame.Rotation
            _bg.Parent = _hrp
        else
            _bf = Instance.new("BodyForce")
            _bf.Name = _rnd(10)
            -- BodyForce = mass × gravity بالضبط (لكن مع ±1% عشوائية)
            local gvar = 0.99 + math.random() * 0.02
            _bf.Force = Vector3.new(0, _cachedMass * _cachedGravity * gvar, 0)
            pcall(function() _bf.ApplyAtCenterOfMass = true end)
            _bf.Parent = _hrp
        end
    end
end

local function _destroyHelpers()
    if _bg then pcall(function() _bg:Destroy() end) _bg = nil end
    if _bf then pcall(function() _bf:Destroy() end) _bf = nil end
end

local function _rotateSig()
    if _bg and _bg.Parent then
        local t = _cachedMass * (400000 + math.random() * 200000)
        _bg.MaxTorque = Vector3.new(t, t, t)
        _bg.P = 15000 + math.random(-800, 800)
        _bg.D = 700 + math.random(-60, 60)
    end
end

-- ═══════ بدء/إيقاف ═══════
local function _startFly()
    _refresh()
    if not _chr or not _hum or not _hrp then return end

    _saved.WalkSpeed     = _hum.WalkSpeed
    _saved.JumpPower     = _hum.JumpPower
    _saved.AutoRotate    = _hum.AutoRotate
    _saved.PlatformStand = _hum.PlatformStand
    _saved.states        = {}

    _hum.WalkSpeed     = 0
    _hum.JumpPower     = 0
    _hum.AutoRotate    = false
    _hum.PlatformStand = true

    for _, st in ipairs({
        Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Dead,
        Enum.HumanoidStateType.Climbing,
    }) do
        local ok, cur = pcall(function() return _hum:GetStateEnabled(st) end)
        if ok then
            _saved.states[st] = cur
            pcall(function() _hum:SetStateEnabled(st, false) end)
        end
    end

    if not _anim then
        _anim = _hum:FindFirstChildOfClass("Animator")
        if not _anim then
            _anim = Instance.new("Animator")
            _anim.Parent = _hum
        end
    end

    local an = _chr:FindFirstChild("Animate")
    if an then
        _saved.animateDisabled = an.Disabled
        an.Disabled = true
    end

    _startIdle()
    _mute()

    -- ⭐ تأخير عشوائي لتهيئة الفيزياء (كسر بصمة التوقيت)
    task.delay(_sess.initDelay, function()
        if _active then
            pcall(_createHelpers)
        end
    end)

    if _hrp.Anchored then _hrp.Anchored = false end

    _velVec = Vector3.zero
    _jumpQ = 0
end

local function _stopFly()
    if _loopConn then
        pcall(function() _loopConn:Disconnect() end)
        _loopConn = nil
    end
    _destroyHelpers()
    _velVec = Vector3.zero
    _jumpQ = 0
    _touchData = {}

    _stopIdle()
    _unmute()

    _refresh()
    if _chr and _hum then
        _hum.WalkSpeed     = _saved.WalkSpeed
        _hum.JumpPower     = _saved.JumpPower
        _hum.AutoRotate    = _saved.AutoRotate
        _hum.PlatformStand = _saved.PlatformStand
        for st, en in pairs(_saved.states) do
            pcall(function() _hum:SetStateEnabled(st, en) end)
        end
        local an = _chr:FindFirstChild("Animate")
        if an then an.Disabled = _saved.animateDisabled end
    end
end

-- ═══════ الحلقة الرئيسية ═══════
local _sigT, _sigI = 0, 2.0
local _jitterAccum = 0
local _currentJitter = Vector3.zero

local function _startLoop()
    if _loopConn then pcall(function() _loopConn:Disconnect() end) end
    _sigI = 1.5 + math.random() * 2.0

    _loopConn = _bind(RunService.RenderStepped:Connect(function(dt)
        if not _active then return end
        if not _hum or not _hum.Parent then _refresh() if not _hum then return end end
        if not _hrp or not _hrp.Parent then _refresh() if not _hrp then return end end

        local raw = _applyCurve(_readInput())
        local hasInput = raw.Magnitude > 0.01
        local mv = _toWorld(raw)

        if _jumpQ > 0 then
            _jumpQ = math.max(0, _jumpQ - dt)
            mv = mv + Vector3.new(0, _jumpQ / 0.15, 0)
            hasInput = true
        end

        if hasInput then
            mv = Vector3.new(mv.X, mv.Y + _sess.lift, mv.Z)
        end

        local tv = mv * (Speed * Multiplier)

        if hasInput then
            local sm = 1 - math.exp(-dt * _sess.smooth)
            _velVec = _velVec:Lerp(tv, sm)
        else
            local sm = 1 - math.exp(-dt * 20)
            _velVec = _velVec:Lerp(Vector3.zero, sm)
            if _velVec.Magnitude < 0.1 then
                _velVec = Vector3.zero
            end
        end

        -- ⭐ Jitter: كل ~0.12 ثانية نغير الانحراف العشوائي
        _jitterAccum = _jitterAccum + dt
        if _jitterAccum >= 0.12 then
            _jitterAccum = 0
            _currentJitter = Vector3.new(
                (math.random() - 0.5) * _sess.jitter,
                (math.random() - 0.5) * _sess.jitter,
                (math.random() - 0.5) * _sess.jitter
            )
        end

        -- تطبيق السرعة + jitter
        _hrp.AssemblyLinearVelocity = _velVec + _currentJitter

        if _bg and _bg.Parent then
            _bg.CFrame = Cam.CFrame.Rotation
        end

        _sigT = _sigT + dt
        if _sigT >= _sigI then
            _sigT = 0
            _sigI = 1.5 + math.random() * 2.0
            pcall(_rotateSig)
        end
    end))
end

-- ═══════ الأزرار ═══════
_bind(_btn.MouseButton1Click:Connect(function()
    _active = not _active
    if _active then
        _btn.Text = "✈  Fly : ON"
        Tween:Create(_btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45,130,85)}):Play()
        _btnStroke.Color = Color3.fromRGB(80,220,140)
        local ok, err = pcall(_startFly)
        if not ok then
            warn("[D] " .. tostring(err))
            _active = false
            _btn.Text = "✈  Fly : OFF"
            _btn.BackgroundColor3 = Color3.fromRGB(60,40,100)
            _btnStroke.Color = Color3.fromRGB(130,70,220)
            return
        end
        _startLoop()
    else
        _btn.Text = "✈  Fly : OFF"
        Tween:Create(_btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,40,100)}):Play()
        _btnStroke.Color = Color3.fromRGB(130,70,220)
        pcall(_stopFly)
    end
end))

_bind(_plus.MouseButton1Click:Connect(function()
    Speed = math.min(MaxSpeed, math.floor((Speed + Step) * 10 + 0.5) / 10)
    _updateLbl(); _pulse(_plus)
end))

_bind(_minus.MouseButton1Click:Connect(function()
    Speed = math.max(MinSpeed, math.floor((Speed - Step) * 10 + 0.5) / 10)
    _updateLbl(); _pulse(_minus)
end))

_bind(UIS.JumpRequest:Connect(function()
    if _active then _jumpQ = 0.15 end
end))

_bind(LP.CharacterAdded:Connect(function()
    _refresh()
    if _active then
        _active = false
        _btn.Text = "✈  Fly : OFF"
        _btn.BackgroundColor3 = Color3.fromRGB(60,40,100)
        _btnStroke.Color = Color3.fromRGB(130,70,220)
        pcall(_stopFly)
    end
end))

_updateLbl()

_G_T[_K] = { _dispose }

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "By Diaa ✈",
        Text = "v28 — Real Stealth",
        Duration = 2
    })
end)" },
    { name = "Slot 02", url = "" },
    { name = "Slot 03", url = "" },
    { name = "Slot 04", url = "" },
    { name = "Slot 05", url = "" },
    { name = "Slot 06", url = "" },
    { name = "Slot 07", url = "" },
    { name = "Slot 08", url = "" },
    { name = "Slot 09", url = "" },
    { name = "Slot 10", url = "" },
    { name = "Slot 11", url = "" },
    { name = "Slot 12", url = "" },
    { name = "Slot 13", url = "" },
    { name = "Slot 14", url = "" },
    { name = "Slot 15", url = "" },
    { name = "Slot 16", url = "" },
    { name = "Slot 17", url = "" },
    { name = "Slot 18", url = "" },
    { name = "Slot 19", url = "" },
    { name = "Slot 20", url = "" },
}

local START_TAB = "ALL" -- ط§ظ„طھط¨ظˆظٹط¨ ط§ظ„ظ„ظٹ ظٹظپطھط­ ط£ظˆظ„ ط´ظٹ

------------------------------------------------------------
-- 2) ط§ظ„ظƒطھط§ظ„ظˆط¬ ط§ظ„ط¬ط§ظ‡ط²: { ط§ظ„ط§ط³ظ…, ط§ظ„ظˆطµظپ, ط§ظ„ط±ط§ط¨ط· }
------------------------------------------------------------
local CATALOG = {
    { tab = "Admin", items = {
        { "Infinite Yield", "Admin commands (400+ commands)", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source" },
        { "Nameless Admin", "Admin commands, actively maintained", "https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source" },
        { "Nameless Admin (old)", "Original version", "https://raw.githubusercontent.com/FilteringEnabled/NamelessAdmin/main/Source" },
        { "CMD-X", "Simple admin command bar", "https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source" },
    }},
    { tab = "Dev Tools", items = {
        { "Dark Dex", "Explorer: browse game objects", "https://raw.githubusercontent.com/infyiff/backup/main/dex.lua" },
        { "Dex++", "Explorer fork", "https://github.com/AZYsGithub/DexPlusPlus/releases/latest/download/out.lua" },
        { "SimpleSpy", "Remote event spy", "https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua" },
    }},
    { tab = "Extras", items = {
        { "Orca", "Script hub (made for PC, may be awkward on phone)", "https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua" },
        { "Unnamed ESP", "Player ESP (needs Drawing API, may not work on mobile)", "https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua" },
    }},
}
for _, g in ipairs(CATALOG) do
    for i, it in ipairs(g.items) do g.items[i] = { name = it[1], desc = it[2], url = it[3] } end
end

------------------------------------------------------------
-- ط§ظ„ط­ظپط¸ (ط§ظ„ظ…ظپط¶ظ„ط© / ط§ظ„ط±ظˆط§ط¨ط· ط§ظ„ظ…ط­ظپظˆط¸ط© / ط§ظ„ط¥ط¹ط¯ط§ط¯ط§طھ)
------------------------------------------------------------
local FILE = "DeltaDragon_ByDiaa.json"
local data = {
    fav = {}, saved = {}, recent = {}, theme = "Red", autoHide = true, circle = 2,
    notify = true, anim = false, hotkey = true, style = 1,
}
pcall(function()
    if isfile and readfile and isfile(FILE) then
        for k, v in pairs(HttpService:JSONDecode(readfile(FILE))) do data[k] = v end
    end
end)
for _, k in ipairs({ "fav", "saved", "recent" }) do
    if type(data[k]) ~= "table" then data[k] = {} end
end
local function save()
    pcall(function()
        if writefile then writefile(FILE, HttpService:JSONEncode(data)) end
    end)
end

------------------------------------------------------------
-- ط§ظ„ط£ظ„ظˆط§ظ† ظˆط§ظ„ط«ظٹظ…ط§طھ { ط±ط¦ظٹط³ظٹطŒ ظپط§طھط­طŒ ط؛ط§ظ…ظ‚ }
------------------------------------------------------------
local THEMES = {
    Red    = { Color3.fromRGB(200, 35, 35),  Color3.fromRGB(255, 60, 60),   Color3.fromRGB(120, 10, 10) },
    Blue   = { Color3.fromRGB(40, 110, 220), Color3.fromRGB(80, 160, 255),  Color3.fromRGB(15, 50, 120) },
    Purple = { Color3.fromRGB(140, 60, 220), Color3.fromRGB(190, 110, 255), Color3.fromRGB(70, 20, 120) },
    Green  = { Color3.fromRGB(40, 170, 80),  Color3.fromRGB(80, 230, 120),  Color3.fromRGB(15, 90, 40) },
    Orange = { Color3.fromRGB(220, 120, 30), Color3.fromRGB(255, 170, 70),  Color3.fromRGB(130, 60, 10) },
    Pink   = { Color3.fromRGB(220, 50, 150), Color3.fromRGB(255, 110, 200), Color3.fromRGB(120, 20, 80) },
}
local THEME_ORDER = { "Red", "Blue", "Purple", "Green", "Orange", "Pink" }
if not THEMES[data.theme] then data.theme = "Red" end
local function C(i) return THEMES[data.theme][i] end

local WHITE = Color3.new(1, 1, 1)
local GRAY  = Color3.fromRGB(170, 170, 175)
local CARD  = Color3.fromRGB(28, 28, 32)
local BTN   = Color3.fromRGB(45, 45, 52)
local GOLD  = Color3.fromRGB(240, 190, 40)
local GREEN = Color3.fromRGB(60, 200, 90)

------------------------------------------------------------
-- طھظ†ط¸ظٹظپ ط§ظ„ظ†ط³ط®ط© ط§ظ„ظ‚ط¯ظٹظ…ط©
------------------------------------------------------------
local env = (getgenv and getgenv()) or _G
env.__DDRun = (env.__DDRun or 0) + 1
local runId = env.__DDRun
if env.__DDConns then
    for _, c in ipairs(env.__DDConns) do pcall(function() c:Disconnect() end) end
end
local conns = {}
env.__DDConns = conns
local function track(c) conns[#conns + 1] = c return c end
for _, n in ipairs({ "DeltaDragonUI", "DeltaDragonToggle" }) do
    local o = pg:FindFirstChild(n)
    if o then o:Destroy() end
end

------------------------------------------------------------
-- ط£ط¯ظˆط§طھ ظ…ط³ط§ط¹ط¯ط©
------------------------------------------------------------
local function make(class, props)
    local o = Instance.new(class)
    local parent = props.Parent
    props.Parent = nil
    for k, v in pairs(props) do o[k] = v end
    o.Parent = parent
    return o
end
local function round(o, r)
    return make("UICorner", { CornerRadius = UDim.new(0, r), Parent = o })
end
local function outline(o, color, th, tr)
    return make("UIStroke", {
        Color = color, Thickness = th, Transparency = tr or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = o,
    })
end
local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
local function esc(s)
    s = tostring(s)
    s = s:gsub("&", "&amp;")
    s = s:gsub("<", "&lt;")
    s = s:gsub(">", "&gt;")
    return s
end
local function stripe(a, b)
    return ColorSequence.new{
        ColorSequenceKeypoint.new(0, a), ColorSequenceKeypoint.new(0.25, b),
        ColorSequenceKeypoint.new(0.5, a), ColorSequenceKeypoint.new(0.75, b),
        ColorSequenceKeypoint.new(1, a),
    }
end

------------------------------------------------------------
-- ط·ط¨ظ‚ط© ط§ظ„ط¯ط§ط¦ط±ط© + ط§ظ„ط¥ط´ط¹ط§ط±ط§طھ (ط£ط¹ظ„ظ‰ ط·ط¨ظ‚ط©طŒ ظپظˆظ‚ ط§ظ„ظ„ظˆط­ط© ط¯ط§ط¦ظ…ط§ظ‹)
------------------------------------------------------------
local tgui = make("ScreenGui", {
    Name = "DeltaDragonToggle", IgnoreGuiInset = true, ResetOnSpawn = false,
    DisplayOrder = 2147483647, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = pg,
})
local toast = make("TextLabel", {
    AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -24),
    Size = UDim2.fromOffset(320, 40), BackgroundColor3 = Color3.fromRGB(20, 20, 24),
    TextColor3 = WHITE, Font = Enum.Font.GothamBold, TextSize = 14, TextWrapped = true,
    Text = "", Visible = false, ZIndex = 50, Parent = tgui,
})
round(toast, 10)
local toastStroke = outline(toast, GREEN, 2)
local toastId = 0
local function notify(msg, good)
    if good and data.notify == false then return end
    toastId += 1
    local id = toastId
    toast.Text = tostring(msg):sub(1, 90)
    toastStroke.Color = good and GREEN or Color3.fromRGB(255, 70, 70)
    toast.Visible = true
    task.delay(3, function()
        if toastId == id then toast.Visible = false end
    end)
end

------------------------------------------------------------
-- ط§ظ„ظ†ط§ظپط°ط© ط§ظ„ط±ط¦ظٹط³ظٹط©
------------------------------------------------------------
local gui = make("ScreenGui", {
    Name = "DeltaDragonUI", IgnoreGuiInset = true, ResetOnSpawn = false,
    DisplayOrder = 2147483646, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = pg,
})
local win = make("Frame", {
    Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(38, 38, 42),
    BorderSizePixel = 0, Active = true, ClipsDescendants = true, ZIndex = 1, Parent = gui,
})
round(win, 16)
make("UIGradient", {
    Rotation = 135,
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(45, 45, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 30, 34)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(45, 45, 50)),
    },
    Parent = win,
})
local winStroke = make("UIStroke", {
    Thickness = 6, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    LineJoinMode = Enum.LineJoinMode.Round, Parent = win,
})
local winGrad = make("UIGradient", { Rotation = 45, Color = stripe(C(2), C(3)), Parent = winStroke })

-- ط§ظ„ط´ط±ظٹط· ط§ظ„ط¹ظ„ظˆظٹ: ط§ظ„ط¯ط±ط§ظ‚ظˆظ† + By Diaa
local header = make("Frame", {
    Name = "Header", Size = UDim2.new(1, 0, 0, 100), BackgroundTransparency = 1, ZIndex = 3, Parent = win,
})
local dragon = make("ImageLabel", {
    AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 4),
    Size = UDim2.fromOffset(150, 66), BackgroundTransparency = 1,
    Image = "rbxassetid://7945054650", ImageColor3 = C(1),
    ScaleType = Enum.ScaleType.Fit, ZIndex = 4, Parent = header,
})
local credit = make("TextLabel", {
    AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -4),
    Size = UDim2.fromOffset(200, 22), BackgroundTransparency = 1, Text = "By Diaa",
    Font = Enum.Font.GothamBlack, TextSize = 18, TextColor3 = C(2), ZIndex = 4, Parent = header,
})
make("UIStroke", { Color = Color3.new(0, 0, 0), Thickness = 1, Parent = credit })

local divider = make("Frame", {
    Size = UDim2.new(1, 0, 0, 3), Position = UDim2.new(0, 0, 0, 100),
    BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 3, Parent = win,
})
local divGrad = make("UIGradient", { Parent = divider })

-- ط§ظ„ظ‚ط§ط¦ظ…ط© ط§ظ„ظٹط³ط±ظ‰ (19%) = ط§ظ„طھط¨ظˆظٹط¨ط§طھ
local leftPanel = make("ScrollingFrame", {
    Name = "LeftPanel", Position = UDim2.new(0, 0, 0, 103), Size = UDim2.new(0.19, 0, 1, -103),
    BackgroundColor3 = Color3.fromRGB(25, 25, 28), BackgroundTransparency = 0.05,
    BorderSizePixel = 0, ScrollBarThickness = 3, CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
    ZIndex = 2, Parent = win,
})
make("UIGradient", {
    Rotation = 90,
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 23)),
    },
    Parent = leftPanel,
})
local leftStroke = outline(leftPanel, C(1), 2, 0.2)
make("UIListLayout", {
    Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder, Parent = leftPanel,
})
make("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), Parent = leftPanel })

-- ط´ط±ظٹط· ط§ظ„ط¨ط­ط«
local searchBox = make("TextBox", {
    Name = "Search", Position = UDim2.new(0.19, 10, 0, 112), Size = UDim2.new(0.81, -20, 0, 38),
    BackgroundColor3 = CARD, Text = "", PlaceholderText = "Search scripts...", PlaceholderColor3 = GRAY,
    TextColor3 = WHITE, ClearTextOnFocus = false, ClipsDescendants = true,
    TextXAlignment = Enum.TextXAlignment.Left, Font = Enum.Font.Gotham, TextSize = 14, ZIndex = 2, Parent = win,
})
round(searchBox, 10)
local searchStroke = outline(searchBox, C(1), 1.5, 0.2)
make("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = searchBox })

-- ظ…ظ†ط·ظ‚ط© ط§ظ„ظ…ط­طھظˆظ‰
local content = make("ScrollingFrame", {
    Name = "Content", Position = UDim2.new(0.19, 10, 0, 158), Size = UDim2.new(0.81, -20, 1, -168),
    BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 6,
    ScrollBarImageColor3 = C(2), CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollingDirection = Enum.ScrollingDirection.Y,
    ZIndex = 2, Parent = win,
})
make("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = content })
make("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 12), Parent = content })

------------------------------------------------------------
-- ظ…طھط؛ظٹط±ط§طھ ظ…ط´طھط±ظƒط©
------------------------------------------------------------
local render, applyTheme, applyCircle, applyStyle, colorTabs
local pages, current, query = {}, 1, ""
local tabButtons = {}
local ord = 0
local function nxt() ord += 1 return ord end
local R = 28
local SIZES = { 22, 28, 36 }
local homeInfo, homeStats
local gameName = "..."
local afkConn
local logs = {}
local t0 = os.clock()
local savedName, savedCode = "", ""

------------------------------------------------------------
-- ظپطھط­ / ظ‚ظپظ„
------------------------------------------------------------
local function setOpen(v)
    if v then win.Position = UDim2.fromScale(0.5, 0.5) end
    gui.Enabled = v
    pcall(function() StarterGui:SetCore("TopbarEnabled", not v) end)
end

------------------------------------------------------------
-- ط£ط¯ظˆط§طھ ط³ط±ظٹط¹ط©
------------------------------------------------------------
local function clip(t)
    local f = setclipboard or toclipboard
    if f then
        pcall(f, t)
        notify("Copied", true)
    else
        notify("Clipboard not supported on this executor", false)
    end
end

local function doRejoin()
    notify("Rejoining...", true)
    if #Players:GetPlayers() <= 1 then
        TeleportService:Teleport(game.PlaceId, player)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
end

local function doHop()
    notify("Searching for a server...", true)
    task.spawn(function()
        local ok, err = pcall(function()
            local url = ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)
            local list = HttpService:JSONDecode(game:HttpGet(url)).data
            for _, s in ipairs(list) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, player)
                    return
                end
            end
            error("no free server found")
        end)
        if not ok then notify("Hop failed: " .. tostring(err), false) end
    end)
end

local function setAfk(on)
    if on and not afkConn then
        local vu = game:GetService("VirtualUser")
        afkConn = player.Idled:Connect(function()
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
    elseif not on and afkConn then
        afkConn:Disconnect()
        afkConn = nil
    end
end

local function hum()
    local c = player.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end
local function hrp()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function doRespawn()
    local h = hum()
    if h then h.Health = 0 end
end

------------------------------------------------------------
-- طھط£ط«ظٹط±ط§طھ ط§ظ„ظ„ط§ط¹ط¨ (Player tab)
------------------------------------------------------------
local pv = {}
local fx = { infjump = false, noclip = false, fullbright = false }
local STAT_DEFAULTS = { speed = 16, jump = 50, fov = 70, grav = 196.2 }
local lightBackup

local function applyValues()
    local h = hum()
    if h then
        if pv.speed then h.WalkSpeed = pv.speed end
        if pv.jump then
            h.UseJumpPower = true
            h.JumpPower = pv.jump
        end
    end
    local cam = Workspace.CurrentCamera
    if pv.fov and cam then cam.FieldOfView = pv.fov end
    if pv.grav then Workspace.Gravity = pv.grav end
end

local function setFullbright(on)
    fx.fullbright = on
    if on then
        if not lightBackup then
            lightBackup = {
                Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd,
                GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient,
            }
        end
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1000000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(178, 178, 178)
        Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
    elseif lightBackup then
        for k, v in pairs(lightBackup) do Lighting[k] = v end
    end
end

track(UIS.JumpRequest:Connect(function()
    if fx.infjump then
        local h = hum()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end))
track(RunService.Stepped:Connect(function()
    if fx.noclip and player.Character then
        for _, p in ipairs(player.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end))
track(player.CharacterAdded:Connect(function()
    task.wait(1)
    applyValues()
end))

------------------------------------------------------------
-- طھط´ط؛ظٹظ„ ط³ظƒط±ط¨طھ (ط±ط§ط¨ط· ط£ظˆ ظƒظˆط¯) + ط§ظ„ط³ط¬ظ„
------------------------------------------------------------
local function pushRecent(name, url)
    for i = #data.recent, 1, -1 do
        if data.recent[i].url == url then table.remove(data.recent, i) end
    end
    table.insert(data.recent, 1, { name = name, url = url })
    while #data.recent > 6 do table.remove(data.recent) end
    save()
end

local function logEvent(ok, label, msg)
    table.insert(logs, 1, { t = os.date("%H:%M:%S"), ok = ok, label = tostring(label), msg = tostring(msg):sub(1, 120) })
    while #logs > 40 do table.remove(logs) end
end

local busy = {}
local function execute(src, btn, label, idle, silent)
    if btn and busy[btn] then return end
    if btn then
        busy[btn] = true
        btn.Text = "..."
    end
    task.spawn(function()
        local ok, fn = pcall(function()
            local code = src.code or game:HttpGet(src.url)
            return assert(loadstring(code))
        end)
        if not ok then
            if btn then btn.Text = "FAIL" end
            logEvent(false, label, fn)
            notify("Failed: " .. tostring(fn), false)
        else
            if btn then btn.Text = "DONE" end
            logEvent(true, label, "loaded")
            notify(label .. " loaded", true)
            if src.url then pushRecent(label, src.url) end
            task.spawn(function()
                local ok2, err2 = pcall(fn)
                if not ok2 then
                    logEvent(false, label, err2)
                    notify(label .. " error: " .. tostring(err2), false)
                end
            end)
            if data.autoHide and not silent then task.delay(0.6, function() setOpen(false) end) end
        end
        task.wait(1.5)
        if btn then
            busy[btn] = nil
            if btn.Parent then btn.Text = idle or "RUN" end
        end
    end)
end

local function runAll(list)
    if #list == 0 then notify("Nothing to run", false) return end
    notify("Running " .. #list .. " scripts...", true)
    task.spawn(function()
        for _, it in ipairs(list) do
            execute({ url = it.url, code = it.code }, nil, it.name, nil, true)
            task.wait(0.8)
        end
        if data.autoHide then setOpen(false) end
    end)
end

------------------------------------------------------------
-- ط¨ظٹط§ظ†ط§طھ ط§ظ„ط£ط²ط±ط§ط± (ALL + ط§ظ„ظƒطھط§ظ„ظˆط¬ + ط§ظ„ظ…ط­ظپظˆط¸ + ط§ظ„ظ…ظپط¶ظ„ط©)
------------------------------------------------------------
local function slotSrc(s)
    local src = {}
    if type(s.code) == "string" and s.code ~= "" then src.code = s.code end
    if type(s.url) == "string" and s.url ~= "" then src.url = s.url end
    return src
end
local function slotFilled(s)
    local src = slotSrc(s)
    return src.url ~= nil or src.code ~= nil
end
local function slotItems()
    local list = {}
    for i, s in ipairs(MY_SLOTS) do
        if slotFilled(s) then
            local src = slotSrc(s)
            list[#list + 1] = {
                name = s.name or ("Slot " .. i), desc = s.desc or ("ALL slot " .. i),
                url = src.url, code = src.code, key = src.url or ("slot" .. i),
            }
        end
    end
    return list
end
local function baseItems()
    local list = {}
    for _, g in ipairs(CATALOG) do
        for _, it in ipairs(g.items) do list[#list + 1] = it end
    end
    for _, it in ipairs(slotItems()) do list[#list + 1] = it end
    for _, it in ipairs(data.saved) do list[#list + 1] = { name = it.name, desc = "Saved link", url = it.url } end
    return list
end
local function allItems()
    local list, have = baseItems(), {}
    for _, it in ipairs(list) do have[it.key or it.url] = true end
    for key, name in pairs(data.fav) do
        if not have[key] and tostring(key):match("^https?://") then
            list[#list + 1] = { name = tostring(name), desc = "Favorite", url = key }
        end
    end
    return list
end
local function favItems()
    local base, list = {}, {}
    for _, it in ipairs(baseItems()) do base[it.key or it.url] = it end
    for key, name in pairs(data.fav) do
        if base[key] then
            list[#list + 1] = base[key]
        elseif tostring(key):match("^https?://") then
            list[#list + 1] = { name = tostring(name), desc = "Favorite", url = key }
        end
    end
    table.sort(list, function(a, b) return a.name:lower() < b.name:lower() end)
    return list
end

------------------------------------------------------------
-- ط¹ظ†ط§طµط± ظˆط§ط¬ظ‡ط© ظ‚ط§ط¨ظ„ط© ظ„ط¥ط¹ط§ط¯ط© ط§ظ„ط§ط³طھط®ط¯ط§ظ…
------------------------------------------------------------
local function section(text)
    return make("TextLabel", {
        LayoutOrder = nxt(), Size = UDim2.new(1, -8, 0, 22), BackgroundTransparency = 1, Text = text,
        Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C(2),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = content,
    })
end

local function card(text)
    local l = make("TextLabel", {
        LayoutOrder = nxt(), Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = CARD, TextColor3 = WHITE, TextWrapped = true, RichText = true,
        Font = Enum.Font.Gotham, TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top, Text = text, Parent = content,
    })
    round(l, 10)
    outline(l, C(1), 1.5, 0.5)
    make("UIPadding", {
        PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14),
        PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), Parent = l,
    })
    return l
end

local function grid(cols, h)
    local g = make("Frame", {
        LayoutOrder = nxt(), Size = UDim2.new(1, -8, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Parent = content,
    })
    make("UIGridLayout", {
        CellSize = UDim2.new(1 / cols, -math.ceil(10 * (cols - 1) / cols), 0, h or 42),
        CellPadding = UDim2.fromOffset(10, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = g,
    })
    return g
end

local function gbtn(parent, text, color, cb)
    local b = make("TextButton", {
        LayoutOrder = #parent:GetChildren(), Text = text, Font = Enum.Font.GothamBold, TextSize = 14,
        TextColor3 = WHITE, BackgroundColor3 = color or C(1), Parent = parent,
    })
    round(b, 8)
    b.Activated:Connect(function() cb(b) end)
    return b
end

local function confirmBtn(parent, label, color, action)
    local armed = false
    local b
    b = gbtn(parent, label, color, function()
        if not armed then
            armed = true
            b.Text = "Tap again to confirm"
            task.delay(3, function()
                armed = false
                if b.Parent then b.Text = label end
            end)
        else
            armed = false
            action()
        end
    end)
    return b
end

local function styleBox(b)
    round(b, 10)
    outline(b, C(1), 1.5, 0.3)
    make("UIPadding", {
        PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), Parent = b,
    })
end

local function makeRow(it, delIndex)
    local key = it.key or it.url
    local row = make("Frame", {
        LayoutOrder = nxt(), Size = UDim2.new(1, -8, 0, 66),
        BackgroundColor3 = CARD, BorderSizePixel = 0, Parent = content,
    })
    round(row, 10)
    outline(row, C(1), 1.5, 0.5)
    make("TextLabel", {
        Position = UDim2.fromOffset(14, 9), Size = UDim2.new(1, -212, 0, 22), BackgroundTransparency = 1,
        Text = it.name, Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = WHITE,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
    })
    make("TextLabel", {
        Position = UDim2.fromOffset(14, 33), Size = UDim2.new(1, -212, 0, 22), BackgroundTransparency = 1,
        Text = it.desc or "", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = GRAY,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
    })
    local runBtn = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.fromOffset(84, 40), BackgroundColor3 = C(1), Text = "RUN",
        Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = WHITE, Parent = row,
    })
    round(runBtn, 8)
    local fav = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -102, 0.5, 0),
        Size = UDim2.fromOffset(44, 40), Text = "FAV", Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = WHITE, BackgroundColor3 = BTN, Parent = row,
    })
    round(fav, 8)
    local third = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -154, 0.5, 0),
        Size = UDim2.fromOffset(44, 40), Text = delIndex and "DEL" or "COPY", Font = Enum.Font.GothamBold,
        TextSize = 12, TextColor3 = WHITE, BackgroundColor3 = BTN, Parent = row,
    })
    round(third, 8)

    local function paintFav()
        local on = data.fav[key] ~= nil
        fav.BackgroundColor3 = on and GOLD or BTN
        fav.TextColor3 = on and Color3.new(0, 0, 0) or WHITE
    end
    paintFav()

    runBtn.Activated:Connect(function()
        execute({ url = it.url, code = it.code }, runBtn, it.name, "RUN")
    end)
    fav.Activated:Connect(function()
        if data.fav[key] then data.fav[key] = nil else data.fav[key] = it.name end
        save()
        paintFav()
        if query == "" and pages[current].name == "Favorites" then render() end
    end)
    third.Activated:Connect(function()
        if delIndex then
            table.remove(data.saved, delIndex)
            save()
            render()
        else
            clip(it.url or it.code or "")
        end
    end)
end

local function toggleRow(label, get, set)
    local row = make("Frame", {
        LayoutOrder = nxt(), Size = UDim2.new(1, -8, 0, 52), BackgroundColor3 = CARD,
        BorderSizePixel = 0, Parent = content,
    })
    round(row, 10)
    outline(row, C(1), 1.5, 0.5)
    make("TextLabel", {
        Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -110, 1, 0), BackgroundTransparency = 1,
        Text = label, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = WHITE, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
    })
    local b = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(80, 36),
        Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = WHITE, Parent = row,
    })
    round(b, 8)
    local function paint()
        local on = get()
        b.Text = on and "ON" or "OFF"
        b.BackgroundColor3 = on and Color3.fromRGB(40, 160, 70) or Color3.fromRGB(70, 70, 78)
    end
    paint()
    b.Activated:Connect(function()
        set(not get())
        save()
        paint()
    end)
end

local function statRow(label, key)
    local row = make("Frame", {
        LayoutOrder = nxt(), Size = UDim2.new(1, -8, 0, 56), BackgroundColor3 = CARD,
        BorderSizePixel = 0, Parent = content,
    })
    round(row, 10)
    outline(row, C(1), 1.5, 0.5)
    make("TextLabel", {
        Position = UDim2.fromOffset(14, 0), Size = UDim2.new(0.3, 0, 1, 0), BackgroundTransparency = 1,
        Text = label, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = WHITE,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = row,
    })
    local box = make("TextBox", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -156, 0.5, 0), Size = UDim2.fromOffset(86, 36),
        BackgroundColor3 = BTN, Text = tostring(pv[key] or STAT_DEFAULTS[key]), PlaceholderText = "value",
        TextColor3 = WHITE, ClearTextOnFocus = false, Font = Enum.Font.Gotham, TextSize = 14, Parent = row,
    })
    round(box, 8)
    local setB = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -84, 0.5, 0), Size = UDim2.fromOffset(66, 36),
        BackgroundColor3 = C(1), Text = "SET", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = WHITE, Parent = row,
    })
    round(setB, 8)
    local resB = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(66, 36),
        BackgroundColor3 = BTN, Text = "RESET", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = WHITE, Parent = row,
    })
    round(resB, 8)
    setB.Activated:Connect(function()
        local v = tonumber(box.Text)
        if not v then notify("Enter a number", false) return end
        pv[key] = v
        applyValues()
        notify(label .. " = " .. tostring(v), true)
    end)
    resB.Activated:Connect(function()
        pv[key] = STAT_DEFAULTS[key]
        applyValues()
        pv[key] = nil
        box.Text = tostring(STAT_DEFAULTS[key])
        notify(label .. " reset", true)
    end)
end

local function playerRow(p)
    local row = make("Frame", {
        LayoutOrder = nxt(), Size = UDim2.new(1, -8, 0, 60), BackgroundColor3 = CARD,
        BorderSizePixel = 0, Parent = content,
    })
    round(row, 10)
    outline(row, C(1), 1.5, 0.5)
    make("TextLabel", {
        Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -230, 0, 22), BackgroundTransparency = 1,
        Text = tostring(p.DisplayName), Font = Enum.Font.GothamBold, TextSize = 15, TextColor3 = WHITE,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
    })
    make("TextLabel", {
        Position = UDim2.fromOffset(14, 31), Size = UDim2.new(1, -230, 0, 20), BackgroundTransparency = 1,
        Text = "@" .. tostring(p.Name), Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = GRAY,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = row,
    })
    local function small(txt, x, color, cb)
        local b = make("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, x, 0.5, 0), Size = UDim2.fromOffset(60, 38),
            BackgroundColor3 = color, Text = txt, Font = Enum.Font.GothamBold, TextSize = 13,
            TextColor3 = WHITE, Parent = row,
        })
        round(b, 8)
        b.Activated:Connect(cb)
    end
    small("COPY", -10, BTN, function() clip(p.Name) end)
    small("VIEW", -76, BTN, function()
        local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
        local cam = Workspace.CurrentCamera
        if h and cam then
            cam.CameraSubject = h
            notify("Viewing " .. p.Name, true)
        else
            notify("Player has no character yet", false)
        end
    end)
    small("TP", -142, C(1), function()
        local mine = hrp()
        local theirs = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if mine and theirs then
            mine.CFrame = theirs.CFrame * CFrame.new(0, 0, 3)
            notify("Teleported to " .. p.Name, true)
        else
            notify("Player has no character yet", false)
        end
    end)
end

------------------------------------------------------------
-- ط¨ظ†ط§ط، ط§ظ„طµظپط­ط§طھ
------------------------------------------------------------
local function infoText()
    return ("Welcome, <b>%s</b>  (@%s)\nGame: <b>%s</b>\nPlace ID: %s     Players: %d / %d"):format(
        esc(player.DisplayName), esc(player.Name), esc(gameName),
        tostring(game.PlaceId), #Players:GetPlayers(), Players.MaxPlayers)
end

local function buildHome()
    homeInfo = card(infoText())
    homeStats = card("FPS: ...     Ping: ... ms")
    section("Quick actions")
    local g = grid(2)
    gbtn(g, "Rejoin", nil, doRejoin)
    gbtn(g, "Server Hop", nil, doHop)
    local afk = gbtn(g, "", nil, function(b)
        setAfk(not afkConn)
        b.Text = afkConn and "Anti-AFK: ON" or "Anti-AFK: OFF"
    end)
    afk.Text = afkConn and "Anti-AFK: ON" or "Anti-AFK: OFF"
    gbtn(g, "Respawn", nil, doRespawn)
    gbtn(g, "Copy Place ID", nil, function() clip(tostring(game.PlaceId)) end)
    gbtn(g, "Copy Job ID", nil, function() clip(game.JobId) end)
    if #data.recent > 0 then
        section("Recent")
        for _, it in ipairs(data.recent) do makeRow({ name = it.name, desc = "Recently run", url = it.url }) end
    end
end

local function buildAll()
    local filled = 0
    for _, s in ipairs(MY_SLOTS) do
        if slotFilled(s) then filled += 1 end
    end
    card(("<b>ALL</b>  -  %d / %d slots filled.\nTo name a button and add your script, edit <b>MY_SLOTS</b> at the top of the code."):format(
        filled, #MY_SLOTS))
    local top = grid(2)
    gbtn(top, "RUN ALL FILLED", nil, function() runAll(slotItems()) end)
    gbtn(top, "REFRESH", BTN, function() render() end)
    local g = grid(3, 48)
    for i, s in ipairs(MY_SLOTS) do
        local name = s.name or ("Slot " .. i)
        if slotFilled(s) then
            local src = slotSrc(s)
            local b = gbtn(g, name, nil, function(btn)
                execute(src, btn, name, name)
            end)
            b.TextSize = 13
            b.TextWrapped = true
        else
            local label = ("Empty %02d"):format(i)
            local b = gbtn(g, label, BTN, function()
                notify("Slot " .. i .. " is empty. Add your script in MY_SLOTS (top of the code).", false)
            end)
            b.TextSize = 13
            b.TextColor3 = GRAY
        end
    end
end

local function buildFav()
    local list = favItems()
    if #list == 0 then
        card("No favorites yet. Tap FAV on any script to pin it here.")
        return
    end
    local g = grid(1)
    gbtn(g, "RUN ALL FAVORITES", nil, function() runAll(favItems()) end)
    for _, it in ipairs(list) do makeRow(it) end
end

local function buildPlayer()
    card("These changes affect <b>your</b> character only. Values are re-applied after you respawn.")
    section("Values")
    statRow("WalkSpeed", "speed")
    statRow("JumpPower", "jump")
    statRow("FOV", "fov")
    statRow("Gravity", "grav")
    section("Toggles")
    toggleRow("Infinite Jump", function() return fx.infjump end, function(v) fx.infjump = v end)
    toggleRow("Noclip", function() return fx.noclip end, function(v) fx.noclip = v end)
    toggleRow("Fullbright", function() return fx.fullbright end, setFullbright)
end

local function buildPlayers()
    local list = Players:GetPlayers()
    table.sort(list, function(a, b) return a.Name:lower() < b.Name:lower() end)
    card(("Players in server: <b>%d</b>"):format(#list))
    local g = grid(2)
    gbtn(g, "REFRESH", nil, function() render() end)
    gbtn(g, "STOP VIEWING", BTN, function()
        local cam, h = Workspace.CurrentCamera, hum()
        if cam and h then cam.CameraSubject = h end
    end)
    for _, p in ipairs(list) do
        if p ~= player then playerRow(p) end
    end
end

local function buildMine()
    section("Run a link or Lua code")
    local nameBox = make("TextBox", {
        LayoutOrder = nxt(), Size = UDim2.new(1, -8, 0, 44), BackgroundColor3 = CARD, Text = savedName,
        PlaceholderText = "Name (optional, used when saving)", PlaceholderColor3 = GRAY, TextColor3 = WHITE,
        ClearTextOnFocus = false, ClipsDescendants = true, TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham, TextSize = 14, Parent = content,
    })
    styleBox(nameBox)
    local codeBox = make("TextBox", {
        LayoutOrder = nxt(), Size = UDim2.new(1, -8, 0, 100), BackgroundColor3 = CARD, Text = savedCode,
        PlaceholderText = "Paste a link (https://...) or a loadstring line here", PlaceholderColor3 = GRAY,
        TextColor3 = WHITE, ClearTextOnFocus = false, ClipsDescendants = true, MultiLine = true, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
        Font = Enum.Font.Gotham, TextSize = 14, Parent = content,
    })
    styleBox(codeBox)
    nameBox:GetPropertyChangedSignal("Text"):Connect(function() savedName = nameBox.Text end)
    codeBox:GetPropertyChangedSignal("Text"):Connect(function() savedCode = codeBox.Text end)

    local g = grid(2)
    gbtn(g, "RUN", nil, function(b)
        local t = trim(codeBox.Text)
        if t == "" then notify("Paste a link or code first", false) return end
        if t:match("^https?://") then
            execute({ url = (t:gsub("%s+", "")) }, b, "Link", "RUN")
        else
            execute({ code = t }, b, "Code", "RUN")
        end
    end)
    gbtn(g, "SAVE", BTN, function()
        local t = trim(codeBox.Text)
        local url = t:match("^https?://%S+") or t:match("https?://[^%s\"'%)]+")
        if not url then notify("Paste a link to save it", false) return end
        local nm = trim(nameBox.Text)
        if nm == "" then nm = url:match("([^/]+)/?$") or "Saved script" end
        table.insert(data.saved, { name = nm, url = url })
        save()
        savedName, savedCode = "", ""
        notify("Saved: " .. nm, true)
        render()
    end)

    if #data.saved > 0 then
        section("Saved")
        for i, it in ipairs(data.saved) do makeRow({ name = it.name, desc = "Saved link", url = it.url }, i) end
    end
end

local function buildLog()
    local g = grid(2)
    gbtn(g, "COPY LOG", nil, function()
        local t = {}
        for _, e in ipairs(logs) do
            t[#t + 1] = ("[%s] %s %s %s"):format(e.t, e.ok and "OK" or "FAIL", e.label, e.msg)
        end
        clip(table.concat(t, "\n"))
    end)
    gbtn(g, "CLEAR", BTN, function()
        logs = {}
        render()
    end)
    if #logs == 0 then
        card("No activity yet. Run a script and its result shows up here.")
        return
    end
    local lines = {}
    for _, e in ipairs(logs) do
        lines[#lines + 1] = ('<font color="%s"><b>%s</b></font>  %s  <b>%s</b>  %s'):format(
            e.ok and "rgb(60,200,90)" or "rgb(255,90,90)", e.ok and "OK" or "FAIL", e.t, esc(e.label), esc(e.msg))
    end
    card(table.concat(lines, "\n"))
end

local function buildSettings()
    section("Behavior")
    toggleRow("Auto-hide panel after running a script",
        function() return data.autoHide end, function(v) data.autoHide = v end)
    toggleRow("Success notifications",
        function() return data.notify ~= false end, function(v) data.notify = v end)
    toggleRow("PC hotkey: RightControl opens / closes",
        function() return data.hotkey ~= false end, function(v) data.hotkey = v end)
    toggleRow("Animated border",
        function() return data.anim == true end,
        function(v)
            data.anim = v
            if not v then winGrad.Rotation = 45 end
        end)

    section("Theme color")
    local g = grid(3)
    for _, name in ipairs(THEME_ORDER) do
        local b = gbtn(g, name, THEMES[name][1], function()
            data.theme = name
            save()
            applyTheme()
            render()
        end)
        if data.theme == name then outline(b, WHITE, 2) end
    end

    section("Panel style")
    local gs = grid(3)
    for i, label in ipairs({ "Solid", "Glass", "Clear" }) do
        local b = gbtn(gs, label, BTN, function()
            data.style = i
            save()
            applyStyle()
            render()
        end)
        if data.style == i then outline(b, WHITE, 2) end
    end

    section("Toggle circle size")
    local g2 = grid(3)
    for i, label in ipairs({ "Small", "Medium", "Large" }) do
        local b = gbtn(g2, label, BTN, function()
            data.circle = i
            save()
            applyCircle()
            render()
        end)
        if data.circle == i then outline(b, WHITE, 2) end
    end

    section("Backup")
    local g4 = grid(2)
    gbtn(g4, "Copy backup", nil, function() clip(HttpService:JSONEncode(data)) end)
    gbtn(g4, "Import backup", BTN, function()
        local ok, d = pcall(function() return HttpService:JSONDecode(trim(savedCode)) end)
        if not ok or type(d) ~= "table" then
            notify("Paste the backup text in the My Scripts box first", false)
            return
        end
        for _, k in ipairs({ "fav", "saved", "recent" }) do
            if type(d[k]) == "table" then data[k] = d[k] end
        end
        for _, k in ipairs({ "theme", "autoHide", "circle", "notify", "anim", "hotkey", "style" }) do
            if d[k] ~= nil then data[k] = d[k] end
        end
        if not THEMES[data.theme] then data.theme = "Red" end
        save()
        applyTheme()
        applyStyle()
        applyCircle()
        notify("Backup imported", true)
        render()
    end)

    section("Data")
    local g3 = grid(2)
    confirmBtn(g3, "Reset saved data", Color3.fromRGB(150, 40, 40), function()
        data.fav, data.saved, data.recent = {}, {}, {}
        save()
        notify("Saved data cleared", true)
        render()
    end)
    confirmBtn(g3, "Unload panel", Color3.fromRGB(90, 90, 100), function()
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        setAfk(false)
        env.__DDRun = -1
        pcall(function() StarterGui:SetCore("TopbarEnabled", true) end)
        gui:Destroy()
        tgui:Destroy()
    end)
end

local function buildAbout()
    card('<b><font size="22" color="rgb(255,70,70)">Delta Dragon UI v7</font></b>\n<b>By Diaa</b>\n\n'
        .. "- Tap the white circle to open / close the panel (RightControl on PC).\n"
        .. "- Hold and drag the circle to move it anywhere.\n"
        .. "- ALL tab: 20 buttons for your own scripts. Edit MY_SLOTS at the top of the code.\n"
        .. "- Search bar looks through every script.\n"
        .. "- FAV pins a script to the Favorites tab.\n"
        .. "- My Scripts: run any link or pasted loadstring line, and save links.\n"
        .. "- Log tab shows what loaded and what failed.\n"
        .. "- Only run links you trust: remote scripts run with full access.")
end

local function buildSearch()
    local seen, count = {}, 0
    for _, it in ipairs(allItems()) do
        local key = it.key or it.url
        if not seen[key]
        and (it.name:lower():find(query, 1, true) or (it.desc or ""):lower():find(query, 1, true)) then
            seen[key] = true
            count += 1
            makeRow(it)
        end
    end
    if count == 0 then card("No results for: " .. esc(query)) end
end

------------------------------------------------------------
-- ط§ظ„طµظپط­ط§طھ ظˆط§ظ„طھط¨ظˆظٹط¨ط§طھ
------------------------------------------------------------
pages[#pages + 1] = { name = "Home", build = buildHome }
pages[#pages + 1] = { name = "ALL", build = buildAll }
pages[#pages + 1] = { name = "Favorites", build = buildFav }
for _, g in ipairs(CATALOG) do
    pages[#pages + 1] = { name = g.tab, build = function()
        for _, it in ipairs(g.items) do makeRow(it) end
    end }
end
pages[#pages + 1] = { name = "Player", build = buildPlayer }
pages[#pages + 1] = { name = "Players", build = buildPlayers }
pages[#pages + 1] = { name = "My Scripts", build = buildMine }
pages[#pages + 1] = { name = "Log", build = buildLog }
pages[#pages + 1] = { name = "Settings", build = buildSettings }
pages[#pages + 1] = { name = "About", build = buildAbout }

render = function()
    for _, c in ipairs(content:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
    content.CanvasPosition = Vector2.zero
    ord = 0
    homeInfo, homeStats = nil, nil
    if query ~= "" then buildSearch() else pages[current].build() end
end

colorTabs = function()
    for i, b in ipairs(tabButtons) do
        b.BackgroundColor3 = (i == current) and C(1) or Color3.fromRGB(38, 38, 44)
    end
end

local function showTab(i)
    current = i
    colorTabs()
    if searchBox.Text ~= "" then searchBox.Text = "" else render() end
end

for i, p in ipairs(pages) do
    local b = make("TextButton", {
        LayoutOrder = i, Size = UDim2.new(1, -12, 0, 36), BackgroundColor3 = Color3.fromRGB(38, 38, 44),
        Text = p.name, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = WHITE,
        TextWrapped = true, Parent = leftPanel,
    })
    round(b, 8)
    b.Activated:Connect(function() showTab(i) end)
    tabButtons[i] = b
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = searchBox.Text:lower()
    q = q:gsub("^%s+", "")
    q = q:gsub("%s+$", "")
    query = q
    render()
end)

------------------------------------------------------------
-- ط³ط­ط¨ ط§ظ„ظ†ط§ظپط°ط© ظ…ظ† ط§ظ„ط´ط±ظٹط· ط§ظ„ط¹ظ„ظˆظٹ
------------------------------------------------------------
local wDrag, wStart, wPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        wDrag = true
        wStart = input.Position
        wPos = win.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then wDrag = false end
        end)
    end
end)
track(UIS.InputChanged:Connect(function(input)
    if wDrag and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - wStart
        win.Position = UDim2.new(wPos.X.Scale, wPos.X.Offset + d.X, wPos.Y.Scale, wPos.Y.Offset + d.Y)
    end
end))

-- ط§ط®طھطµط§ط± ط§ظ„ظƒظٹط¨ظˆط±ط¯ ظ„ظ„ظƒظ…ط¨ظٹظˆطھط±
track(UIS.InputBegan:Connect(function(input, gp)
    if gp or data.hotkey == false then return end
    if input.KeyCode == Enum.KeyCode.RightControl then setOpen(not gui.Enabled) end
end))

------------------------------------------------------------
-- ط§ظ„ط¯ط§ط¦ط±ط© ط§ظ„ط¨ظٹط¶ط§ط،: ط¶ط؛ط·ط© = ظپطھط­/ظ‚ظپظ„طŒ ط³ط­ط¨ = طھط­ط±ظٹظƒ
-- (ظپظٹ ScreenGui ظ…ظ†ظپطµظ„ ط¨ط£ط¹ظ„ظ‰ DisplayOrderطŒ ظ…ط§ ظٹط؛ط·ظٹظ‡ط§ ط´ظٹ)
------------------------------------------------------------
R = SIZES[data.circle] or 28
local TOP_MARGIN = 72  -- طھط­طھ ط´ط±ظٹط· ط±ظˆط¨ظ„ظˆظƒط³ ط§ظ„ط¹ظ„ظˆظٹ ط¹ط´ط§ظ† ظ…ط§ ظٹط؛ط·ظٹظ‡ط§

local circle = make("TextButton", {
    Name = "ToggleCircle", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.94, 0.5),
    Size = UDim2.fromOffset(R * 2, R * 2), BackgroundColor3 = WHITE, Text = "",
    AutoButtonColor = false, ZIndex = 100, Parent = tgui,
})
local circleCorner = round(circle, R)
local circleStroke = outline(circle, C(1), 3)

local function setCenter(cx, cy)
    local vp = tgui.AbsoluteSize
    if vp.X <= 0 or vp.Y <= 0 then return end
    cx = math.clamp(cx, R + 6, vp.X - R - 6)
    cy = math.clamp(cy, TOP_MARGIN + R, vp.Y - R - 6)
    circle.Position = UDim2.fromScale(cx / vp.X, cy / vp.Y)
end

applyCircle = function()
    R = SIZES[data.circle] or 28
    circle.Size = UDim2.fromOffset(R * 2, R * 2)
    circleCorner.CornerRadius = UDim.new(0, R)
    local vp = tgui.AbsoluteSize
    setCenter(circle.Position.X.Scale * vp.X, circle.Position.Y.Scale * vp.Y)
end

track(tgui:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    local vp = tgui.AbsoluteSize
    setCenter(circle.Position.X.Scale * vp.X, circle.Position.Y.Scale * vp.Y)
end))

local cDrag, cMoved, cInput, cStart, cCenter = false, false
circle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        cDrag, cMoved = true, false
        cInput = input
        cStart = input.Position
        cCenter = circle.AbsolutePosition + circle.AbsoluteSize / 2
    end
end)
track(UIS.InputChanged:Connect(function(input)
    if not cDrag then return end
    if input == cInput or input.UserInputType == Enum.UserInputType.MouseMovement then
        local d = input.Position - cStart
        if not cMoved and d.Magnitude > 8 then cMoved = true end
        if cMoved then setCenter(cCenter.X + d.X, cCenter.Y + d.Y) end
    end
end))
track(UIS.InputEnded:Connect(function(input)
    if cDrag and (input == cInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
        cDrag = false
        if not cMoved then setOpen(not gui.Enabled) end
    end
end))

------------------------------------------------------------
-- طھط·ط¨ظٹظ‚ ط§ظ„ط«ظٹظ… ظˆط§ظ„ط³طھط§ظٹظ„
------------------------------------------------------------
applyTheme = function()
    winGrad.Color = stripe(C(2), C(3))
    divGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, C(3)), ColorSequenceKeypoint.new(0.5, C(2)), ColorSequenceKeypoint.new(1, C(3)),
    }
    dragon.ImageColor3 = C(1)
    credit.TextColor3 = C(2)
    leftStroke.Color = C(1)
    searchStroke.Color = C(1)
    content.ScrollBarImageColor3 = C(2)
    leftPanel.ScrollBarImageColor3 = C(2)
    circleStroke.Color = C(1)
    colorTabs()
end

applyStyle = function()
    win.BackgroundTransparency = ({ 0, 0.25, 0.5 })[data.style] or 0
end

------------------------------------------------------------
-- FPS / Ping / ط§ظ„ط¬ظ„ط³ط© + ط§ط³ظ… ط§ظ„ظ„ط¹ط¨ط© + ط§ظ„ط­ط¯ظ‘ ط§ظ„ط¯ظˆظ‘ط§ط±
------------------------------------------------------------
local frames = 0
track(RunService.RenderStepped:Connect(function()
    frames += 1
    if data.anim then winGrad.Rotation = (os.clock() * 60) % 360 end
end))

task.spawn(function()
    local ok, info = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId) end)
    if ok and info and info.Name then gameName = info.Name end
    if homeInfo and homeInfo.Parent then homeInfo.Text = infoText() end
end)

task.spawn(function()
    while env.__DDRun == runId do
        task.wait(1)
        local fps = frames
        frames = 0
        local ping = 0
        pcall(function() ping = math.floor(player:GetNetworkPing() * 1000) end)
        local s = math.floor(os.clock() - t0)
        if homeStats and homeStats.Parent then
            homeStats.Text = ("FPS: %d     Ping: %d ms     Session: %02d:%02d:%02d"):format(
                fps, ping, s // 3600, (s // 60) % 60, s % 60)
        end
        if homeInfo and homeInfo.Parent then homeInfo.Text = infoText() end
        applyValues()
    end
end)

------------------------------------------------------------
-- طھط´ط؛ظٹظ„
------------------------------------------------------------
applyTheme()
applyStyle()
local startIdx = 1
for i, p in ipairs(pages) do
    if p.name == START_TAB then startIdx = i end
end
showTab(startIdx)
setOpen(true)
task.delay(0.3, applyCircle)
notify("Delta Dragon UI v7 - By Diaa", true)

-- طھط´ط؛ظٹظ„ طھظ„ظ‚ط§ط¦ظٹ ظ„ظ„ط£ط²ط±ط§ط± ط§ظ„ظ„ظٹ ظپظٹظ‡ط§ auto = true
task.delay(1.5, function()
    for i, s in ipairs(MY_SLOTS) do
        if s.auto and slotFilled(s) then
            execute(slotSrc(s), nil, s.name or ("Slot " .. i), nil, true)
            task.wait(0.8)
        end
    end
end)
