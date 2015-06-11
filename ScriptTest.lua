local version = "0.17"
--[[
        This is my frist script 
        But who cares about fucking comments :O
        
  YOLOOOOOOOOOOO

Changelogs:
        0.10 - Added 13 lines of code !!!!!!! FUCK YEAH!
        0.11 - I WANNA LEARN TO SCRIPT FOR BoL 1 & BoL 2 !!!!
        0.12 - Drawings added 
        0.13 - Welcome message
        
 TODO:
        Spell cast
        Menu
        Something more when i learn
]]--

_G.Script_Autoupdate = true

-- / Auto-Update Function / --
local script_downloadName = "ScriptTest"
local script_downloadHost = "raw.github.com"
local script_downloadPath = "/janja96/BoL/master/ScriptTest.lua" .. "?rand=" .. math.random(1, 10000)
local script_downloadUrl = "https://" .. script_downloadHost .. script_downloadPath
local script_filePath = SCRIPT_PATH .. GetCurrentEnv().FILE_NAME

unction script_Messager(msg) print("<font color=\"#FF0000\">" .. script_downloadName .. ":</font> <font color=\"#FFFFFF\">" .. msg .. ".</font>") end

if _G.Script_Autoupdate then
	local script_webResult = GetWebResult(script_downloadHost, script_downloadPath)
	if script_webResult then
		local script_serverVersion = string.match(script_webResult, "local%s+version%s+=%s+\"%d+.%d+\"")
		
		if script_serverVersion then
			script_serverVersion = tonumber(string.match(script_serverVersion or "", "%d+%.?%d*"))

			if not script_serverVersion then
				script_Messager("Please contact the developer of the script \"" .. script_downloadName .. "\", since the auto updater returned an invalid version.")
				return
			end

			if tonumber(version) < script_serverVersion then
				script_Messager("New version available: " .. script_serverVersion)
				script_Messager("Updating, please don't press F9")
				DelayAction(function () DownloadFile(script_downloadUrl, script_filePath, function() script_Messager("Successfully updated the script, please reload!") end) end, 2)
			else
				script_Messager("You've got the latest version: " .. script_serverVersion)
			end
		end
	else
		script_Messager("Error downloading server version!")
	end
end

-- get username
user = GetUser()
-- Get our champion
myHero = GetMyHero()

function OnLoad()
	Variables()
        -- PrintChat("<font color='#0000FF'> >> Kha'zix - The Voidreaver 1.2.3 Loaded!! <<</font>")
        PrintChat("<font color='#FF0033'> Welcome: </font> " .. "<font color='#00CC00'>" .. user .. "</font>")
end

function OnTick()
        if (myHero.health < 200) then
                PrintChat("Warning: LOW HP! Drink a potion!")
        end
end

function OnDraw()
        if (myHero.mana < 150) then
                -- DrawText("XXX", TextSize, X, Y, HexColor)
                DrawText("Warning: LOW MANA! Drink blue potion!", 18, 100, 100, 0x0000FF)
        end
end



