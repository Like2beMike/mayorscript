script_name('Mayor')
script_version('15.04.2020')
script_author('Àâòîð: Vladik Kustov. Äîðàáîòêà: Egor Vozhakovich')
local key = require 'vkeys'
local imgui = require 'imgui'
local encoding = require 'encoding'
local inicfg = require 'inicfg'
require 'lib.moonloader'
require 'lib.sampfuncs'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local config = {
	main = {
		zaderjka = 6000
	}
}
show_main_window = imgui.ImBool(false)

function apply_custom_style()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4

    style.WindowRounding = 2.0
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
    style.ChildWindowRounding = 2.0
    style.FrameRounding = 2.0
    style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
    style.ScrollbarSize = 13.0
    style.ScrollbarRounding = 0
    style.GrabMinSize = 8.0
    style.GrabRounding = 1.0

    colors[clr.FrameBg]                = ImVec4(0.48, 0.16, 0.16, 0.54)
    colors[clr.FrameBgHovered]         = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.FrameBgActive]          = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
    colors[clr.TitleBgActive]          = ImVec4(0.48, 0.16, 0.16, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
    colors[clr.CheckMark]              = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.88, 0.26, 0.24, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Button]                 = ImVec4(0.98, 0.26, 0.26, 0.40)
    colors[clr.ButtonHovered]          = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.98, 0.06, 0.06, 1.00)
    colors[clr.Header]                 = ImVec4(0.98, 0.26, 0.26, 0.31)
    colors[clr.HeaderHovered]          = ImVec4(0.98, 0.26, 0.26, 0.80)
    colors[clr.HeaderActive]           = ImVec4(0.98, 0.26, 0.26, 1.00)
    colors[clr.Separator]              = colors[clr.Border]
    colors[clr.SeparatorHovered]       = ImVec4(0.75, 0.10, 0.10, 0.78)
    colors[clr.SeparatorActive]        = ImVec4(0.75, 0.10, 0.10, 1.00)
    colors[clr.ResizeGrip]             = ImVec4(0.98, 0.26, 0.26, 0.25)
    colors[clr.ResizeGripHovered]      = ImVec4(0.98, 0.26, 0.26, 0.67)
    colors[clr.ResizeGripActive]       = ImVec4(0.98, 0.26, 0.26, 0.95)
    colors[clr.TextSelectedBg]         = ImVec4(0.98, 0.26, 0.26, 0.35)
    colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
    colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
    colors[clr.ComboBg]                = colors[clr.PopupBg]
    colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
    colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
    colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end
apply_custom_style()
lecture = false
function imgui.OnDrawFrame()
    if show_main_window.v then
		local sw, sh = getScreenResolution()
		imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(350, 375), imgui.Cond.FirstUseEver)
		imgui.Begin('Mayor', show_main_window)
		local btn_size = imgui.ImVec2(-0.1, 0)
		local files = {}
        local handleFile, nameFile = findFirstFile('moonloader/mayor/*.txt')
        while nameFile do
            if handleFile then
                if not nameFile then 
                    findClose(handleFile)
                else
                    files[#files+1] = nameFile
                    nameFile = findNextFile(handleFile)
                end
            end
		end
		if imgui.Button(u8'Ââîäíàÿ äëÿ îõðàíû', btn_size) then
		lecture = lua_thread.create(function()
		sampSendChat("Èòàê. Ïðèâåòñòâóþ åùå ðàç. Ñåé÷àñ ÿ âàì ðàññêàæó î âàøèõ îáÿçàííîñòÿõ")
		wait(cfg.main.zaderjka)
		sampSendChat("Èçíà÷àëüíî âû ïîïàäàåòå â îòäåë Protection Servant è íàõîäèòåñü òóò òðîå ñóòîê")
		wait(cfg.main.zaderjka)
		sampSendChat("Â âàøè îáÿçàííîñòè áóäåò âõîäèòü îõðàíà ìýðèè, ïåøèé ïàòðóëü âîêðóã çäàíè")
		wait(cfg.main.zaderjka)
		sampSendChat("Òàêæå âû äîëæíû îáåñïå÷èâàòü ïîðÿäîê íà ïðèëåãàþùèõ òåððèòîðèÿõ.")
		wait(cfg.main.zaderjka)
		sampSendChat("Íàïðèìåð: ïàðêîâêà, ñòóïåíüêè, âåðòîëåòíàÿ ïëîùàäêà.")
		wait(cfg.main.zaderjka)
		sampSendChat("Î ïîñòàõ è êîíêðåòíûõ îáÿçàííîñòÿõ ïðî÷òèòå íà îô. ïîðòàëå.")
		wait(cfg.main.zaderjka)
		sampSendChat("/b Èðîâîé ñåðâåð I - Ãîñ.Ñëóæáû - Ìýðèÿ - CityHall » Ñëóæáà áåçîïàñíîñòè New")
		wait(cfg.main.zaderjka)
		sampSendChat("Ïî îêîí÷àíèè èñïûòàòåëüíîãî ñðîêà âàñ ïåðåâåäóò â îòäåë State Property Securit.")
		wait(cfg.main.zaderjka)
		sampSendChat("Â äàííîì îòäåëå âàì áóäåò äîñòóïåí ñëóæåáíûé òðàíñïîðò, à òàêæå âûåçä íà ñòðàòåãè÷åñêèå îáúåêòû.")
		wait(cfg.main.zaderjka)
		sampSendChat("Âû áóäåòå îõðàíÿòü ïîðò èëè ôåðìû, ãäå ãðàæäàíå íàèáîëåå ïîäâåðæåíû îïàñíîñòè.")
		wait(cfg.main.zaderjka)
		sampSendChat("Âû ñìîæåòå ïîëüçîâàòüñÿ, êàê ëè÷íûì òðàíñïîðòîì, ÷òîáû äîáðàòüñÿ íà ïîñòû – òàê è ñëóæåáíûì.")
		wait(cfg.main.zaderjka)
		sampSendChat("Ïîâòîðÿþ, îáÿçàííîñòè è ñâîè ïîëíîìî÷èÿ – ÷èòàéòå íà îô. ïîðòàëå øòàòà")
		wait(cfg.main.zaderjka)
		sampSendChat("/b Èðîâîé ñåðâåð I - Ãîñ.Ñëóæáû - Ìýðèÿ - CityHall » Ñëóæáà áåçîïàñíîñòè New.")
		wait(cfg.main.zaderjka)
		sampSendChat("Åñëè çà âåñü ïåðèîä ñëóæáû â ýòèõ îòäåëàõ âû çàðåêîìåíäóåòå ñåáÿ ñ õîðîøåé ñòîðîíû")
		wait(cfg.main.zaderjka)
		sampSendChat("Òî âàñ íàçíà÷àò ñîòðóäíèêîì Bodyguards")
		wait(cfg.main.zaderjka)
		sampSendChat("Âû ñìîæåòå îõðàíÿòü ïåðâûõ ëèö øòàòà, à òàêæå ïîäïèñûâàòü êîíòðàêò íà ëè÷íóþ îõðàíó.")
		wait(cfg.main.zaderjka)
		sampSendChat("Òî åñòü – âû áóäåòå ïîëó÷àòü íå òîëüêî îôèöèàëüíóþ çàðïëàòó, íî è îãîâîðåííóþ ñóììó ñ êëèåíòîì.")
		wait(cfg.main.zaderjka)
		sampSendChat("Âû ñòàíåòå ñîòðóäíèêàìè ñåêðåòíîé ñëóæáû ïðàâèòåëüñòâà è áóäåòå òåëîõðàíèòåëÿìè.")
		wait(cfg.main.zaderjka)
		sampSendChat("Ïîäðîáíåå ÷èòàéòå íà îô. ïîðòàëå")
		wait(cfg.main.zaderjka)
		sampSendChat("/b Èðîâîé ñåðâåð I - Ãîñ.Ñëóæáû - Ìýðèÿ - CityHall » Ñëóæáà áåçîïàñíîñòè New.")
		wait(cfg.main.zaderjka)
		sampSendChat("Òðè ëó÷øèõ ñîòðóäíèêà îõðàíû êàæäûé ÷àñ áóäóò ïîëó÷àòü ïðåìèþ.")
		wait(cfg.main.zaderjka)
		sampSendChat("Äåëàéòå îò÷åòû â ðàöèþ, ïðîãîâàðèâàéòå îòäåë, à òàêæå ïðîÿâëÿéòå àêòèâíîñòü íà ðàáîòå.")
		wait(cfg.main.zaderjka)
		sampSendChat("Íàèáîëåå àêòèâíûå ïîïàäóò â ñïèñîê êàíäèäàòîâ íà äîëæíîñòü íà÷àëüíèêà îõðàíû")
		wait(cfg.main.zaderjka)
		sampSendChat("Òåïåðü ïðîéäåìòå çà ìíîé – ÿ ðàññòàâëþ âàñ ïî ïîñòàì.")
		    end)
		end
		if imgui.Button(u8'Íàáîð â ìýðèþ ¹1.', btn_size) then
			lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: Äîáðûé äåíü, óâàæàåìûå æèòåëè è ãîñòè øòàòà, ìèíóòî÷êó âíèìàíèÿ!")
				wait(cfg.main.zaderjka)
				sampSendChat('/gov [City Hall]: Ñåé÷àñ â ñòåíàõ Ìýðèè ïðîõîäèò ñîáåñåäîâàíèå íà äîëæíîñòü Ñåêðåòàðÿ/Îõðàííèêà.')
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: Êðèòåðèè: Ïðîïèñêà îò 5-òè ëåò â øòàòå, îïðÿòíûé âèä, êîìïëåêò ëèöåíçèé. Æä¸ì âàñ!")
			end)
		end
				if imgui.Button(u8'Íàáîð â ìýðèþ ¹2.', btn_size) then
				lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: Äîáðîãî âðåìåíè ñóòîê, óâàæàåìûå æèòåëè è ãîñòè øòàòà, ìèíóòî÷êó âíèìàíèÿ!")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: Ñåé÷àñ â ñòåíàõ Ìýðèè ïðîõîäèò ñîáåñåäîâàíèå íà äîëæíîñòü Ñåêðåòàðÿ/Îõðàííèêà.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: Êðèòåðèè: Ïðîïèñêà îò 5-òè ëåò â øòàòå, îïðÿòíûé âèä, êîìïëåêò ëèöåíçèé. Æä¸ì âàñ!")
			end)
		end
		        if imgui.Button(u8'Ïðè¸ìíàÿ Ìýðèÿ', btn_size) then
		        lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: Óâàæàåìûå æèòåëè øòàòà, ìèíóòó âíèìàíèÿ! Ïðè¸ìíàÿ ìýðà îòêðûòà äëÿ âàøèõ îáðàùåíèé.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: Âû ìîæåòå îñòàâèòü çàÿâëåíèå íà ôèíàíñîâóþ ïîääåðæêó, ñóáñèäèþ, ïåíñèþ è äðóãóþ ïîìîùü.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [Cty Hall]: Ïîäðîáíûå òðåáîâàíèÿ è êðèòåðèè îïèñàíû íà îôèöèàëüíîì ïîðòàëå ìýðèè. Ñïàñèáî çà âíèìàíèå.")
	
			end)
		end
		        if imgui.Button(u8'Ïîääåðæêà áèçíåñîâ.', btn_size) then
		        lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: Óâàæàåìûå æèòåëè øòàòà, ìèíóòó âíèìàíèÿ! Îáðàùàåìñÿ ê ïðåäñòàâèòåëÿì ìàëîãî áèçíåñà.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: Â äàííûé ìîìåíò äåéñòâóåò ñèñòåìà äîñòàâîê òîâàðîâ íà âàøè ñêëàäû.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [Cty Hall]: Ïðîñüáà îñòàâëÿòü çàÿâëåíèå íà îôèöèàëüíîì ïîðòàëå ìýðèè. Ñïàñèáî çà âíèìàíèå.")
			end)
		end
		        if imgui.Button(u8'Ñóáñèäèÿ.', btn_size) then
		        lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: Óâàæàåìûå ãðàæäàíå, ìèíóòó âíèìàíèÿ! Ââåäåíà ñèñòåìà ñóáñèäèé íà ïðîæèâàíèå â îòåëÿõ.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: Ðàáîòàåò ðåæèì êîìïåíñàöèè àðåíäû ãîñòèíè÷íûõ íîìåðîâ â ðàçìåðå 50 ïðîöåíòîâ.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [Cty Hall]: Äëÿ ïîëó÷åíèÿ äåòàëüíîé èíôîðìàöèè – ïîñåòèòå îôèöèàëüíûé ïîðòàë ìýðèè. Ñïàñèáî çà âíèìàíèå.")
			end)
		end
			    if imgui.Button(u8'Þðèäè÷åñêàÿ ïîìîùü.', btn_size) then
		        lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: Óâàæàåìûå æèòåëè øòàòà, ìèíóòó âíèìàíèÿ! Â øòàòå äåéñòâóåò áåñïëàòíàÿ ïðàâîâàÿ ïîìîùü.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: Þðèñòû îçíàêîìÿòñÿ ñ âàøèìè æàëîáàìè è ïîìîãóò ñîñòàâèòü èñê íà íàðóøèòåëÿ.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [Cty Hall]: Äåòàëüíàÿ èíôîðìàöèÿ îïèñàíà â ïðèåìíîé ìýðà íà îôèöèàëüíîì ïîðòàëå øòàòà. Ñïàñèáî çà âíèìàíèå.")
			end)
		end
				if imgui.Button(u8'Âàêàíñèè íà îõðàííèêà.', btn_size) then
		        lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: Óâàæàåìûå æèòåëè øòàòà, ìèíóòó âíèìàíèÿ! Îòêðûòû âàêàíñèè â ïðàâèòåëüñòâåííûå îòäåëû îõðàíû.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: Èäåò íàáîð â îõðàíó ìýðèè, ñòðàòåãè÷åñêèõ îáúåêòîâ, â îòäåë ëè÷íîé áåçîïàñíîñòè.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [Cty Hall]: Êðèòåðèè è òðåáîâàíèÿ îãëàøåíû íà îôèöèàëüíîì ïîðòàëå ìýðèè. Ñïàñèáî çà âíèìàíèå.")
		    end)
		end
		        if imgui.Button(u8'Îêîí÷àíèå íàáîðà.', btn_size) then
			    lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: Óâàæàåìûå æèòåëè è ãîñòè íàøåãî øòàòà, ìèíóòî÷êó âíèìàíèÿ.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: Ñîáåñåäîâàíèå íà äîëæíîñòü Ñåêðåòàðÿ/Îõðàííèêà ïîäõîäèò ê êîíöó. Íî íå ðàññòðàèâàéòåñü.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: Òàê êàê íà îô. ïîðòàëå 'City Hall' îòêðûòû çàÿâëåíèÿ íà äîëæíîñòü Àäâîêàòà.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: Âûñîêèå çàðïëàòû, ìàòåðèàëüíûå ïîîùðåíèÿ äëÿ ñîòðóäíèêîâ, äðóæíûé êîëëåêòèâ. Ìû æä¸ì òåáÿ!")
			end)
		end	
		if imgui.Button(u8 'Ñîîáùèòü î îøèáêå / áàãå', btn_size) then 
		            showCursor(false)
			sampAddChatMessage(' {DC143C}[Mayor]{ffffff} Íàéäèòå ìåíÿ â èãðå {00F0FD}/id Vladik_Kustov{ffffff} èëè æå íàïèøèòå â ËÑ Âêîíòàêòå {00F0FD}vk.com/rumistik', 0xae433d)
					
		end
		if imgui.Button(u8'Ïåðåçàãðóçèòü ñêðèïò', btn_size) then
			showCursor(false)
			thisScript():reload()
        end
		imgui.Separator()
        if imgui.Button(u8'Îñòàíîâèòü ëåêöèþ', btn_size) then
            sampAddChatMessage(' {DC143C}[Mayor]{ffffff} Ëåêöèÿ îñòàíîâëåíà.', 0xae433d)
            lecture:terminate()
		end
		imgui.Separator()
		local waitint = imgui.ImInt(cfg.main.zaderjka)
		if imgui.SliderInt(u8 'Çàäåðæêà', waitint, 1000, 10000) then
			cfg.main.zaderjka = waitint.v
			inicfg.save(config, 'mayor.ini')
		end
        imgui.End()
    end
end

--UPDATE SCRIPT!!!!!!!!!
-- ÍÅ ÒÐÎÃÀÒÜ!!!!

function autoupdate(json_url, prefix, url)
  local dlstatus = require('moonloader').download_status
  local json = getWorkingDirectory() .. '\\'..thisScript().name..'-version.json'
  if doesFileExist(json) then os.remove(json) end
  downloadUrlToFile(json_url, json,
    function(id, status, p1, p2)
      if status == dlstatus.STATUSEX_ENDDOWNLOAD then
        if doesFileExist(json) then
          local f = io.open(json, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            updateversion = info.latest
            f:close()
            os.remove(json)
            if updateversion ~= thisScript().version then
              lua_thread.create(function(prefix)
                local dlstatus = require('moonloader').download_status
                local color = -1
                sampAddChatMessage((prefix..'Îáíàðóæåíî îáíîâëåíèå. Ïûòàþñü îáíîâèòüñÿ c '..thisScript().version..' íà '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('Çàãðóæåíî %d èç %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('Çàãðóçêà îáíîâëåíèÿ çàâåðøåíà.')
                      sampAddChatMessage((prefix..'Îáíîâëåíèå çàâåðøåíî!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        sampAddChatMessage((prefix..'Îáíîâëåíèå ïðîøëî íåóäà÷íî. Çàïóñêàþ óñòàðåâøóþ âåðñèþ..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': Îáíîâëåíèå íå òðåáóåòñÿ.')
            end
          end
        else
          print('v'..thisScript().version..': Íå ìîãó ïðîâåðèòü îáíîâëåíèå. Ñìèðèòåñü èëè ïðîâåðüòå ñàìîñòîÿòåëüíî íà '..url)
          update = false
        end
      end
    end
  )
  while update ~= false do wait(100) end
end

--main
function main()
	while not isSampAvailable() do wait(0) end
	sampAddChatMessage(' {DC143C}Mayor |{ffffff} Àâòîð ñêðèïòà {DC143C}Vladik Kustov è Egor Vozhakovich.', 0xae433d)
	sampAddChatMessage(' {DC143C}Mayor |{ffffff} Ñêðèïò óñïåøíî çàãðóæåí.', 0xae433d)
	sampAddChatMessage(string.format(" {DC143C}Mayor |{ffffff} Âåðñèÿ ñêðèïòà  %s", thisScript().version), 0xae433d)
	cfg = inicfg.load(config, 'mayor.ini')
    if not doesDirectoryExist('moonloader/mayor') then createDirectory('moonloader/mayor') end
    --comands
    sampRegisterChatCommand('mayor', function() show_main_window.v = not show_main_window.v end)
    sampRegisterChatCommand('uninvite', uninvite)
    sampRegisterChatCommand('invite', invite)
	autoupdate("https://raw.githubusercontent.com/Like2beMike/mayorscript/master/update.json", '['..string.upper(thisScript().name)..']: ', "https://raw.githubusercontent.com/Like2beMike/mayorscript/master/update.json")
    while true do wait(0)
        imgui.Process = show_main_window.v 
    end
end

--functions 
function invite(param)
	local id = tonumber(param)
	if id then
	lecture = lua_thread.create(function()	
		sampSendChat('/me äîñòàë ÷èñòîå óäîñòîâåðåíèå èç íèæíåãî øêàô÷èêà')
		wait(3000)
		sampSendChat('/me îòêðûë óäîñòîâåðåíèå')
		wait(3000)
		sampSendChat('/do Óäîñòîâåðåíèå îòêðûòî.')
		wait(3000)
		sampSendChat('/me îòêðûë ïàñïîðò ãðàæäàíèíà, ïîñëå ÷åãî ïðîáåæàëñÿ ãëàçàìè ïî òåêñòó')
		wait(3000)
		sampSendChat('/do Îçíàêîìëåí.')
		wait(3000)
		sampSendChat('/me âçÿë ïå÷àòü è ïîñòàâèë ïå÷àòü â óäîñòîâåðåíèè')
		wait(3000)
		sampSendChat('/do Â óäîñòîâåðåíèè ñòîèò ïå÷àòü "Mayor".')
		wait(3000)
		sampSendChat('/me ïåðåäàë óäîñòîâåðåíèå è íîâûé êîìïëåêò ôîðìû âïåðåäè ñòîÿùåìó ÷åëîâåêó')
		wait(3000)
		sampSendChat(string.format('/invite %s', id))
	end)
	else
		sampAddChatMessage(' {DC143C}Mayor |{ffffff} /invite [ID]', 0xae433d)
	end
end

function uninvite(param)
	local id, reason = param:match('(%d+) (.+)')
	if id and reason then
		lecture = lua_thread.create(function()
			sampSendChat('/me äîñòàë ÊÏÊ èç ïðàâîãî êàðìàíà áðþê')
			wait(3000)
			sampSendChat('/do ÊÏÊ íàõîäèòñÿ â ïðàâîé ðóêå')
			wait(3000)
			sampSendChat('/me âîøåë â áàçó äàííûõ City Hall')
			wait(3000)
			sampSendChat('/do Íà ýêðàíå îòîáðàçèëñÿ êëþ÷ áåçîïàñíîñòè.')
			wait(3000)
			sampSendChat('/me ââåë ïèí-êîä íà ýêðàí')
			wait(3000)
			sampSendChat('/me ââåë â ïîèñê áàçû äàííûõ ñîòðóäíèêà')
			wait(3000)
			sampSendChat('/do Íà ýêðàíå îòîáðàçèëàñü ïåðñîíàëüíàÿ èíôîðìàöèþ îá ñîòðóäíèêå')
			wait(3000)
			sampSendChat('/me îòðåäàêòèðîâàë èíôîðìàöèþ î ñîòðóäíèêå êàê "óäàëèòü"')
			wait(3000)
			sampSendChat(string.format('/uninvite %s %s', id, reason))
		end)
		else
			sampAddChatMessage(' {DC143C}Mayor |{ffffff} /uninvite [ID] [reason]', 0xae433d)
		end	
	end
