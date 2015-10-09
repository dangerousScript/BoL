local Version = "0.25"
--[[
	Changelogs:
		-0.10:
			Menu added
			Cast Q,W,E,R as combo
			Draw range for Q
			Print Low Health
		-0.25: (NOT YET UPDATED)
			Improve W - smanjiti range 640-600
			Add Autoupdate function
]]

-- Hero name check
if myHero.charName ~= "Annie" then return end

-- / Auto Update Function / --
local sVersion = '0.25';
local rVersion = GetWebResult('raw.githubusercontent.com', '/janja96/BoL/master/Versions/AnnieS.version?no-cache=' .. math.random(1, 25000));

if ((rVersion) and (tonumber(rVersion) ~= nil)) then
	if (tonumber(sVersion) < tonumber(rVersion)) then
		print('<font color="#FF1493"><b>[AnnieS]:</b> </font><font color="#FFFF00">An update has been found and it is now downloading!</font>');
		DownloadFile('https://raw.githubusercontent.com/janja96/BoL/master/AnnieS.lua?no-cache=' .. math.random(1, 25000), (SCRIPT_PATH.. GetCurrentEnv().FILE_NAME), function()
			print('<font color="#FF1493"><b>[AnnieS]:</b> </font><font color="#00FF00">Script has been updated, please reload!</font>');
		end);
		return;
	end;
	if (tonumber(sVersion) == tonumber(rVersion)) then
		print('<font color="#FF1493"><b>[AnnieS]:</b> </font><font color="#FF0000">You are using the latest version!</font>');
	end;
	else
		print('<font color="#FF1493"><b>[AnnieS]:</b> </font><font color="#FF0000">Update Error</font>');
	end;
-- / Auto Update Function / --

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
