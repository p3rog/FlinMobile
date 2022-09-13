--==[[  Библиотеки  ]]==--

local dlstatus = require('moonloader').download_status
local encoding = require('encoding')
imgui = require('imgui')
inicfg = require('inicfg')

--======================--



--==[[  Переменные  ]]==--

    -- кодировка
encoding.default = 'CP1251'
u8 = encoding.UTF8

mainMenu = imgui.ImBool(false)

    -- фонтс
font = nil

    -- update
local update_state = false
local script_vers = 1
local update_url = 'https://raw.githubusercontent.com/p3rog/FlinMobile/main/update.ini'
local update_path = getWorkingDirectory()..'/update.ini'
local script_url = 'https://github.com/p3rog/FlinMobile/blob/main/flinLaucher.lua'
local script_path = thisScript().path

--======================--


--==[[  Главная функция  ]]==--

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end

    msg('Лаунчер успешно запущен. Активация: /launcher')
    sampRegisterChatCommand('launcher', function()
        mainMenu.v = not mainMenu.v
    end)

    while true do wait(0)
        imgui.Process = mainMenu.v

        if update_state then
            downloadUrlToFile(script_url, script_path, function(id, status)
                if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                    msg('Успешно обновлено.')
                    thisScript():reload()
                end
            end)
        end
    end
end

--===========================--



--==[[  Imgui меню  ]]==--

function imgui.BeforeDrawFrame()
    if fontServer == nil then
        fontServer = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 27.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
    end
    if fontServera == nil then
        fontServera = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 21.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
    end
    if fontUpdate == nil then
        fontUpdate = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14) .. '\\trebucbd.ttf', 17.0, nil, imgui.GetIO().Fonts:GetGlyphRangesCyrillic())
    end
end

function imgui.OnDrawFrame()
    local sw, sh = getScreenResolution()
    if mainMenu.v then
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(500, 250), imgui.Cond.FirstUseEver)
        imgui.Begin('Flin Launcher', nil, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar)
            
            imgui.SetCursorPos(imgui.ImVec2(15, 35))
            imgui.BeginChild('##1server', imgui.ImVec2(220, 70), false)

                imgui.PushFont(fontServera)
                imgui.CenterText(u8'Сервер 01 v2')
                imgui.SetCursorPos(imgui.ImVec2(5, 30))
                if imgui.Button(u8'Присоединиться', imgui.ImVec2(210, 30)) then sampConnectToServer("193.84.90.17", 7771) end
                imgui.PopFont()

            imgui.EndChild()

            imgui.SameLine()

            imgui.SetCursorPos(imgui.ImVec2(265, 35))
            imgui.BeginChild('##2server', imgui.ImVec2(220, 70), false)

                imgui.PushFont(fontServera)
                imgui.CenterText(u8'Сервер 02')
                imgui.SetCursorPos(imgui.ImVec2(5, 30))
                if imgui.Button(u8'Присоединиться', imgui.ImVec2(210, 30)) then sampConnectToServer("193.84.90.17", 7772) end
                imgui.PopFont()

            imgui.EndChild()

            imgui.SetCursorPos(imgui.ImVec2(15, 105))
            imgui.BeginChild('##update', imgui.ImVec2(470, 140), false)

                imgui.PushFont(fontUpdate)
                imgui.SetCursorPos(imgui.ImVec2(135, 108))
                if imgui.Button(u8'Проверить обновление', imgui.ImVec2(190, 25)) then
                    downloadUrlToFile(update_url, update_path, function(id, status)
                        if status == dlstatus.STATUS_ENDDOWNLOADDATA then
                            updateIni = inicfg.load(nil, update_path)
                            if tonumber(updateIni.info.vers) > script_vers then
                                msg('Есть обновление.')
                                update_state = true
                            end
                            os.remove(update_path)
                        end
                    end)
                end
                imgui.PopFont()

            imgui.EndChild()

        imgui.End()
    end
end

--======================--




--==[[  Разные функции  ]]==--

function msg(text)
    sampAddChatMessage('[Flin Launcher] > {F2F2D4}'..text, 0xFFC433)
end

function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end

--==========================--



--==[[  Стиль imgui  ]]==--

function style()
    imgui.SwitchContext()
      local style  = imgui.GetStyle()
      local colors = style.Colors
      local clr    = imgui.Col
      local ImVec4 = imgui.ImVec4
      local ImVec2 = imgui.ImVec2

      style.WindowPadding       = ImVec2(1, 3)
      style.WindowRounding      = 9
      style.ChildWindowRounding = 14
      style.FramePadding        = ImVec2(5, 3)
      style.FrameRounding       = 11
      style.ItemSpacing         = ImVec2(15, 20)
      style.TouchExtraPadding   = ImVec2(10, 10)
      style.IndentSpacing       = 30
      style.ScrollbarSize       = 11
      style.ScrollbarRounding   = 16
      style.GrabMinSize         = 20
      style.GrabRounding        = 16
      style.WindowTitleAlign    = ImVec2(0.5, 0.5)
      style.ButtonTextAlign     = ImVec2(0.5, 0.5)

      colors[clr.Text]                 = ImVec4(0.00, 0.00, 0.00, 1.00)
      colors[clr.TextDisabled]         = ImVec4(1.00, 0.06, 0.00, 1.00)
      colors[clr.WindowBg]             = ImVec4(1.00, 0.99, 0.97, 0.81)
      colors[clr.ChildWindowBg]        = ImVec4(1.00, 0.03, 0.03, 0.00)
      colors[clr.PopupBg]              = ImVec4(1.00, 1.00, 1.00, 0.71)
      colors[clr.Border]               = ImVec4(0.00, 0.00, 0.00, 1.00)
      colors[clr.BorderShadow]         = ImVec4(0.00, 0.00, 0.00, 0.00)
      colors[clr.FrameBg]              = ImVec4(1.00, 0.76, 0.00, 0.63)
      colors[clr.FrameBgHovered]       = ImVec4(1.00, 0.76, 0.00, 0.63)
      colors[clr.FrameBgActive]        = ImVec4(1.00, 0.00, 0.00, 1.00)
      colors[clr.TitleBg]              = ImVec4(1.00, 0.78, 0.09, 0.63)
      colors[clr.TitleBgActive]        = ImVec4(1.00, 0.76, 0.00, 0.71)
      colors[clr.TitleBgCollapsed]     = ImVec4(1.00, 0.76, 0.00, 0.63)
      colors[clr.MenuBarBg]            = ImVec4(1.00, 0.76, 0.00, 0.63)
      colors[clr.ScrollbarBg]          = ImVec4(1.00, 0.75, 0.00, 0.63)
      colors[clr.ScrollbarGrab]        = ImVec4(0.40, 0.39, 0.34, 1.00)
      colors[clr.ScrollbarGrabHovered] = ImVec4(0.08, 0.08, 0.08, 1.00)
      colors[clr.ScrollbarGrabActive]  = ImVec4(0.02, 0.02, 0.02, 1.00)
      colors[clr.ComboBg]              = ImVec4(1.00, 0.76, 0.00, 0.63)
      colors[clr.CheckMark]            = ImVec4(0.06, 0.06, 0.06, 1.00)
      colors[clr.SliderGrab]           = ImVec4(1.00, 0.75, 0.00, 0.54)
      colors[clr.SliderGrabActive]     = ImVec4(1.00, 0.00, 0.00, 1.00)
    colors[clr.Button]               = ImVec4(1.00, 0.88, 0.00, 1.00)
    colors[clr.ButtonHovered]        = ImVec4(0.32, 1.00, 0.00, 1.00)
    colors[clr.ButtonActive]         = ImVec4(0.00, 1.00, 0.78, 1.00)

      colors[clr.Header]               = ImVec4(1.00, 0.76, 0.00, 1.00)
      colors[clr.HeaderHovered]        = ImVec4(1.00, 0.76, 0.00, 0.63)
      colors[clr.HeaderActive]         = ImVec4(1.00, 0.99, 0.04, 0.00)
      colors[clr.Separator]            = ImVec4(0.00, 0.06, 1.00, 1.00)
      colors[clr.SeparatorHovered]     = ImVec4(0.71, 0.39, 0.39, 0.54)
      colors[clr.SeparatorActive]      = ImVec4(0.71, 0.39, 0.39, 0.54)
      colors[clr.ResizeGrip]           = ImVec4(0.71, 0.39, 0.39, 0.54)
      colors[clr.ResizeGripHovered]    = ImVec4(0.84, 0.66, 0.66, 0.66)
      colors[clr.ResizeGripActive]     = ImVec4(0.84, 0.66, 0.66, 0.66)
      colors[clr.CloseButton]          = ImVec4(0.00, 0.00, 0.00, 1.00)
      colors[clr.CloseButtonHovered]   = ImVec4(0.98, 0.39, 0.36, 1.00)
      colors[clr.CloseButtonActive]    = ImVec4(0.98, 0.39, 0.36, 1.00)
      colors[clr.PlotLines]            = ImVec4(0.00, 0.01, 0.00, 1.00)
      colors[clr.PlotLinesHovered]     = ImVec4(1.00, 0.43, 0.35, 1.00)
      colors[clr.PlotHistogram]        = ImVec4(0.78, 0.61, 0.03, 1.00)
      colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
      colors[clr.TextSelectedBg]       = ImVec4(0.14, 0.14, 0.14, 0.35)
      colors[clr.ModalWindowDarkening] = ImVec4(0.18, 0.18, 0.18, 0.35)
end

style()

function BH_theme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2
 
    style.WindowPadding = ImVec2(6, 4)
    style.WindowRounding = 5.0
    style.ChildWindowRounding = 5.0
    style.FramePadding = ImVec2(5, 2)
    style.FrameRounding = 5.0
    style.ItemSpacing = ImVec2(7, 5)
    style.ItemInnerSpacing = ImVec2(1, 1)
    style.TouchExtraPadding = ImVec2(0, 0)
    style.IndentSpacing = 6.0
    style.ScrollbarSize = 12.0
    style.ScrollbarRounding = 5.0
    style.GrabMinSize = 20.0
    style.GrabRounding = 2.0
    style.WindowTitleAlign = ImVec2(0.5, 0.5)

    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.28, 0.30, 0.35, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.16, 0.18, 0.22, 1.00)
    colors[clr.ChildWindowBg]          = ImVec4(0.19, 0.22, 0.26, 1)
    colors[clr.PopupBg]                = ImVec4(0.05, 0.05, 0.10, 0.90)
    colors[clr.Border]                 = ImVec4(0.19, 0.22, 0.26, 1.00)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.FrameBg]                = ImVec4(0.19, 0.22, 0.26, 1.00)
    colors[clr.FrameBgHovered]         = ImVec4(0.22, 0.25, 0.30, 1.00)
    colors[clr.FrameBgActive]          = ImVec4(0.22, 0.25, 0.29, 1.00)
    colors[clr.TitleBg]                = ImVec4(0.19, 0.22, 0.26, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.19, 0.22, 0.26, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.19, 0.22, 0.26, 0.59)
    colors[clr.MenuBarBg]              = ImVec4(0.19, 0.22, 0.26, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.20, 0.25, 0.30, 0.60)
    colors[clr.ScrollbarGrab]          = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.49, 0.63, 0.86, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.49, 0.63, 0.86, 1.00)
    colors[clr.ComboBg]                = ImVec4(0.20, 0.20, 0.20, 0.99)
    colors[clr.CheckMark]              = ImVec4(0.90, 0.90, 0.90, 0.50)
    colors[clr.SliderGrab]             = ImVec4(1.00, 1.00, 1.00, 0.30)
    colors[clr.SliderGrabActive]       = ImVec4(0.80, 0.50, 0.50, 1.00)
    colors[clr.Button]                 = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.ButtonHovered]          = ImVec4(0.49, 0.62, 0.85, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.49, 0.62, 0.85, 1.00)
    colors[clr.Header]                 = ImVec4(0.19, 0.22, 0.26, 1.00)
    colors[clr.HeaderHovered]          = ImVec4(0.22, 0.24, 0.28, 1.00)
    colors[clr.HeaderActive]           = ImVec4(0.22, 0.24, 0.28, 1.00)
    colors[clr.Separator]              = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.SeparatorHovered]       = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.SeparatorActive]        = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.ResizeGripHovered]      = ImVec4(0.49, 0.61, 0.83, 1.00)
    colors[clr.ResizeGripActive]       = ImVec4(0.49, 0.62, 0.83, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.CloseButtonHovered]     = ImVec4(0.50, 0.63, 0.84, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.PlotLines]              = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(0.41, 0.55, 0.78, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.16, 0.18, 0.22, 0.76)
end
-- BH_theme()

--=======================--