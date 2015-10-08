local Version = "0.22"
--[[
	Changelogs:
		-0.10:
			Menu added
			Cast Q,W,E,R as combo
			Draw range for Q
			Print Low Health
		-0.11: (NOT YET UPDATED)
			Improve W - smanjiti range 640-600
			Add Autoupdate function
]]

-- Hero name check
if myHero.charName ~= "Annie" then return end


_G.Annie_Autoupdate = true


-- / Auto-Update Function / --
local script_downloadName = "AnnieS"
local script_downloadHost = "raw.github.com"
local script_downloadPath = "/janja96/BoL/master/AnnieS.lua" .. "?rand=" .. math.random(1, 10000)
local script_downloadUrl = "https://" .. script_downloadHost .. script_downloadPath
local script_filePath = SCRIPT_PATH .. GetCurrentEnv().FILE_NAME


function script_Messager(msg) print("<font color=\"#FF0000\">" .. script_downloadName .. ":</font> <font color=\"#FFFFFF\">" .. msg .. ".</font>") end

if _G.Annie_Autoupdate then
	local script_webResult = GetWebResult(script_downloadHost, script_downloadPath)
	if script_webResult then
		local script_serverVersion = string.match(script_webResult, "local%s+version%s+=%s+\"%d+.%d+\"")
		
		if script_serverVersion then
			script_serverVersion = tonumber(string.match(script_serverVersion or "", "%d+%.?%d*"))

			if not script_serverVersion then
				script_Messager("Please contact the developer of the script \"" .. script_downloadName .. "\", since the auto updater returned an invalid version.")
				return
			end

			if tonumber(Version) < script_serverVersion then
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
-- / Auto-Update Function / --


local ts 

-- Execute only at start of the game
function OnLoad()
	-- Menu
	Config = scriptConfig("AnnieS", "AnnieSave")
	-- draw menu
	Config:addSubMenu("["..myHero.charName.."] - Draw", "draw")
		Config.draw:addParam("drawCircle", "Draw Circle", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("printHp", "Print Health warning", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("A"))
	-- combo menu
	Config:addSubMenu("["..myHero.charName.."] - Combo", "combo")
		Config.combo:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)

	-- menu version
	Config:addParam("version", "Version: " .. Version, SCRIPT_PARAM_ONOFF, true)
 
 
	-- We create a target selector
	ts = TargetSelector(TARGET_LOW_HP_PRIORITY,630)
	-- Welcome message
	PrintChat("<font color=\"#FF0000\">[AnnieS]:</font> <font color=\"#FFFFFF\">Loaded Version: </font>" ..Version.. "<font color=\"#FFFFFF\"> by stefisa</font>")
end
 
-- Execute 10 times per second
function OnTick()
	-- Make the target selector look for closer enemys again
	ts:update()
	
	--Enemy near?
	if (ts.target ~= nil) then
 
		-- Spacebar pressed ?
		if (Config.combo) then
			-- Can we cast Q ?
			if (myHero:CanUseSpell(_Q) == READY) then
				-- Cast spell on enemy
				CastSpell(_Q, ts.target)
			end
 
			-- Can we cast W ?
			if (myHero:CanUseSpell(_W) == READY) then
				-- Cast spell on enemy
				CastSpell(_W, ts.target.x,ts.target.z)
			end

			-- Cast E
			if (myHero:CanUseSpell(_E) == READY) then
				CastSpell(_E)
			end

			-- Cast R
			if (myHero:CanUseSpell(_R) == READY) then
				CastSpell(_R, ts.target.x, ts.target.z)
			end
		end
		
	end
end
 
-- Drawing graphics
function OnDraw()
	--Draw circles only if activated on menu
	if (Config.drawCircle) then
		DrawCircle(myHero.x, myHero.y, myHero.z, 630, 0x111111)
	end
	
	-- Show HP warning
	if (Config.printHp) then
		if (myHero.health < 200) then
			DrawText("Warning: LOW HP! Drink a potion!", 18, 100, 100, 0xFFFFFF00)
		end
	end
end
