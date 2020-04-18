script_name('Mayor')
script_version('18.04.2020')
script_author('�����: Vladik Kustov. ���������: Egor Vozhakovich')
local lkey, key = pcall(require, 'vkeys')
local rkeys = require 'rkeys'
local imadd = require 'imgui_addons'
local imgui = require 'imgui'
local encoding = require 'encoding'
local inicfg = require 'inicfg'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local config = {
	main = {
		zaderjka = 6000
	}
}
show_main_window = imgui.ImBool(false)

--������� � ������� ������
local config_keys = {
    members = { v = {key.VK_M}}
}

function rkeys.onHotKey(id, keys)
	if sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive() then
	return false
	end
end

function mtext(text)
	sampAddChatMessage((' {DC143C}%s | {ffffff}%s'):format(script.this.name, text), 0xdc143c)
end

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
		if imgui.Button(u8'������� ��� ������', btn_size) then
		lecture = lua_thread.create(function()
		sampSendChat("����. ����������� ��� ���. ������ � ��� �������� � ����� ������������")
		wait(cfg.main.zaderjka)
		sampSendChat("���������� �� ��������� � ����� Protection Servant � ���������� ��� ���� �����")
		wait(cfg.main.zaderjka)
		sampSendChat("� ���� ����������� ����� ������� ������ �����, ����� ������� ������ �����")
		wait(cfg.main.zaderjka)
		sampSendChat("����� �� ������ ������������ ������� �� ����������� �����������.")
		wait(cfg.main.zaderjka)
		sampSendChat("��������: ��������, ���������, ����������� ��������.")
		wait(cfg.main.zaderjka)
		sampSendChat("� ������ � ���������� ������������ �������� �� ��. �������.")
		wait(cfg.main.zaderjka)
		sampSendChat("/b ������ ������ I - ���.������ - ����� - CityHall � ������ ������������ New")
		wait(cfg.main.zaderjka)
		sampSendChat("�� ��������� �������������� ����� ��� ��������� � ����� State Property Securit.")
		wait(cfg.main.zaderjka)
		sampSendChat("� ������ ������ ��� ����� �������� ��������� ���������, � ����� ����� �� �������������� �������.")
		wait(cfg.main.zaderjka)
		sampSendChat("�� ������ �������� ���� ��� �����, ��� �������� �������� ���������� ���������.")
		wait(cfg.main.zaderjka)
		sampSendChat("�� ������� ������������, ��� ������ �����������, ����� ��������� �� ����� � ��� � ���������.")
		wait(cfg.main.zaderjka)
		sampSendChat("��������, ����������� � ���� ���������� � ������� �� ��. ������� �����")
		wait(cfg.main.zaderjka)
		sampSendChat("/b ������ ������ I - ���.������ - ����� - CityHall � ������ ������������ New.")
		wait(cfg.main.zaderjka)
		sampSendChat("���� �� ���� ������ ������ � ���� ������� �� �������������� ���� � ������� �������")
		wait(cfg.main.zaderjka)
		sampSendChat("�� ��� �������� ����������� Bodyguards")
		wait(cfg.main.zaderjka)
		sampSendChat("�� ������� �������� ������ ��� �����, � ����� ����������� �������� �� ������ ������.")
		wait(cfg.main.zaderjka)
		sampSendChat("�� ���� � �� ������ �������� �� ������ ����������� ��������, �� � ����������� ����� � ��������.")
		wait(cfg.main.zaderjka)
		sampSendChat("�� ������� ������������ ��������� ������ ������������� � ������ ���������������.")
		wait(cfg.main.zaderjka)
		sampSendChat("��������� ������� �� ��. �������")
		wait(cfg.main.zaderjka)
		sampSendChat("/b ������ ������ I - ���.������ - ����� - CityHall � ������ ������������ New.")
		wait(cfg.main.zaderjka)
		sampSendChat("��� ������ ���������� ������ ������ ��� ����� �������� ������.")
		wait(cfg.main.zaderjka)
		sampSendChat("������� ������ � �����, �������������� �����, � ����� ���������� ���������� �� ������.")
		wait(cfg.main.zaderjka)
		sampSendChat("�������� �������� ������� � ������ ���������� �� ��������� ���������� ������")
		wait(cfg.main.zaderjka)
		sampSendChat("������ ��������� �� ���� � � ��������� ��� �� ������.")
		    end)
		end
		if imgui.Button(u8'����� � ����� �1.', btn_size) then
			lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: ������ ����, ��������� ������ � ����� �����, ��������� ��������!")
				wait(cfg.main.zaderjka)
				sampSendChat('/gov [City Hall]: ������ � ������ ����� �������� ������������� �� ��������� ���������/���������.')
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: ��������: �������� �� 5-�� ��� � �����, �������� ���, �������� ��������. ��� ���!")
			end)
		end
				if imgui.Button(u8'����� � ����� �2.', btn_size) then
				lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: ������� ������� �����, ��������� ������ � ����� �����, ��������� ��������!")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: ������ � ������ ����� �������� ������������� �� ��������� ���������/���������.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: ��������: �������� �� 5-�� ��� � �����, �������� ���, �������� ��������. ��� ���!")
			end)
		end
		        if imgui.Button(u8'������� �����', btn_size) then
		        lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: ��������� ������ �����, ������ ��������! ������� ���� ������� ��� ����� ���������.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: �� ������ �������� ��������� �� ���������� ���������, ��������, ������ � ������ ������.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [Cty Hall]: ��������� ���������� � �������� ������� �� ����������� ������� �����. ������� �� ��������.")
	
			end)
		end
		        if imgui.Button(u8'��������� ��������.', btn_size) then
		        lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: ��������� ������ �����, ������ ��������! ���������� � �������������� ������ �������.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: � ������ ������ ��������� ������� �������� ������� �� ���� ������.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [Cty Hall]: ������� ��������� ��������� �� ����������� ������� �����. ������� �� ��������.")
			end)
		end
		        if imgui.Button(u8'��������.', btn_size) then
		        lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: ��������� ��������, ������ ��������! ������� ������� �������� �� ���������� � ������.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: �������� ����� ����������� ������ ����������� ������� � ������� 50 ���������.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [Cty Hall]: ��� ��������� ��������� ���������� � �������� ����������� ������ �����. ������� �� ��������.")
			end)
		end
			    if imgui.Button(u8'����������� ������.', btn_size) then
		        lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: ��������� ������ �����, ������ ��������! � ����� ��������� ���������� �������� ������.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: ������ ����������� � ������ �������� � ������� ��������� ��� �� ����������.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [Cty Hall]: ��������� ���������� ������� � �������� ���� �� ����������� ������� �����. ������� �� ��������.")
			end)
		end
				if imgui.Button(u8'�������� �� ���������.', btn_size) then
		        lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: ��������� ������ �����, ������ ��������! ������� �������� � ����������������� ������ ������.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: ���� ����� � ������ �����, �������������� ��������, � ����� ������ ������������.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [Cty Hall]: �������� � ���������� �������� �� ����������� ������� �����. ������� �� ��������.")
		    end)
		end
		        if imgui.Button(u8'��������� ������.', btn_size) then
			    lecture = lua_thread.create(function()
				sampSendChat("/gov [City Hall]: ��������� ������ � ����� ������ �����, ��������� ��������.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: ������������� �� ��������� ���������/��������� �������� � �����. �� �� ���������������.")
				wait(cfg.main.zaderjka)
				sampSendChat("/gov [City Hall]: ��� ��� ���� ������������� �������� ����� �����. ���� ���!")
			end)
		end	
		if imgui.Button(u8 '�������� � ������ / ����', btn_size) then 
		            showCursor(false)
			mtext('������� ���� � ���� {00F0FD}/id Vladik_Kustov{ffffff} ��� �� �������� � �� ��������� {00F0FD}vk.com/rumistik', 0xae433d)
					
		end
		if imgui.Button(u8'������������� ������', btn_size) then
			showCursor(false)
			thisScript():reload()
        end
		imgui.Separator()
        if imgui.Button(u8'���������� ������', btn_size) then
            mtext('������ �����������.', 0xae433d)
            lecture:terminate()
		end
		imgui.Separator()
		local waitint = imgui.ImInt(cfg.main.zaderjka)
		if imgui.SliderInt(u8 '��������', waitint, 1000, 10000) then
			cfg.main.zaderjka = waitint.v
			inicfg.save(config, 'mayor.ini')
		end
        imgui.End()
    end
end

--UPDATE SCRIPT!!!!!!!!!
-- �� �������!!!!

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
                mtext(('���������� ����������. ������� ���������� c '..thisScript().version..' �� '..updateversion), color)
                wait(250)
                downloadUrlToFile(updatelink, thisScript().path,
                  function(id3, status1, p13, p23)
                    if status1 == dlstatus.STATUS_DOWNLOADINGDATA then
                      print(string.format('��������� %d �� %d.', p13, p23))
                    elseif status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
                      print('�������� ���������� ���������.')
                      mtext(('���������� ���������!'), color)
                      goupdatestatus = true
                      lua_thread.create(function() wait(500) thisScript():reload() end)
                    end
                    if status1 == dlstatus.STATUSEX_ENDDOWNLOAD then
                      if goupdatestatus == nil then
                        mtext(('���������� ������ ��������. �������� ���������� ������..'), color)
                        update = false
                      end
                    end
                  end
                )
                end, prefix
              )
            else
              update = false
              print('v'..thisScript().version..': ���������� �� ���������.')
            end
          end
        else
          print('v'..thisScript().version..': �� ���� ��������� ����������. ��������� ��� ��������� �������������� �� '..url)
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
	mtext('����� ������� {DC143C}Vladik Kustov � Egor Vozhakovich.', 0xae433d)
	mtext('������ ������� ��������.', 0xae433d)
	mtext(string.format("������ �������  %s", thisScript().version), 0xae433d)
	cfg = inicfg.load(config, 'mayor.ini')
    if not doesDirectoryExist('moonloader/mayor') then createDirectory('moonloader/mayor') end
    --comands
    sampRegisterChatCommand('mayor', function() show_main_window.v = not show_main_window.v end)
    sampRegisterChatCommand('uninvite', uninvite)
    sampRegisterChatCommand('uninvitei', uninvitei)    
    sampRegisterChatCommand('invite', invite)
    sampRegisterChatCommand('invitei', invitei)
	members = rkeys.registerHotKey(config_keys.members.v, true, members)
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
		sampSendChat('/me ������ ������ ������������� �� ������� ��������')
		wait(3000)
		sampSendChat('/me ������ �������������')
		wait(3000)
		sampSendChat('/do ������������� �������.')
		wait(3000)
		sampSendChat('/me ���� ������ � �������� ������ � �������������')
		wait(3000)
		sampSendChat('/do � ������������� ����� ������ "Mayor".')
		wait(3000)
		sampSendChat('/me ������� ������������� � ����� �������� ����� ������� �������� ��������')
		wait(3000)
		sampSendChat(string.format('/invite %s', id))
	end)
	else
		mtext('/invite [ID]', 0xae433d)
	end
end

function uninvite(param)
	local id, reason = param:match('(%d+) (.+)')
	if id and reason then
		lecture = lua_thread.create(function()
			sampSendChat('/me ������ ��� �� ������� ������� ����')
			wait(3000)
			sampSendChat('/do ��� ��������� � ������ ����')
			wait(3000)
			sampSendChat('/me ����� � ���� ������ City Hall')
			wait(3000)
			sampSendChat('/do �� ������ ����������� ���� ������������.')
			wait(3000)
			sampSendChat('/me ���� ���-��� �� �����')
			wait(3000)
			sampSendChat('/me ���� � ����� ���� ������ ����������')
			wait(3000)
			sampSendChat('/do �� ������ ������������ ������������ ���������� �� ����������')
			wait(3000)
			sampSendChat('/me �������������� ���������� � ���������� ��� "�������"')
			wait(3000)
			sampSendChat(string.format('/uninvite %s %s', id, reason))
		end)
		else
			mtext('/uninvite [ID] [reason]', 0xae433d)
		end	
	end

function invitei(id)
	local id = tonumber(id)
	if id then
	sampSendChat(string.format('/invite %s', id))
	else 
		mtext('/invitei [ID]', 0xae433d)
	end
end

function uninvite(param)
	local id, reason = param:match('(%d+) (.+)')
	if id and reason then
		sampSendChat(string.format('/uninvite %s %s', id, reason))
	else
		mtext('/uninvite [ID] [reason]', 0xae433d)
	end	
end		

function members()
	sampSendChat('/members')
end
