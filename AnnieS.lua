local Version = "0.27"
--[[
	Changelogs: [BETA]
		-0.10:
			Menu added
			Cast Q,W,E,R as combo
			Draw range for Q
			Print Low Health
		-0.26:
			Added champion name check
			Improved W - smanjiti range 630
			Add Autoupdate function
			Menu updated

		-0.27:
			New menu options
			Harass
			Draw W,R,Q
			permaShow added
		-0.28:	
			Auto R for X enemy
			last hit Q
			Move to mouse / orbwalk
]]	

-- Hero name check
if myHero.charName ~= "Annie" then return end

-- / Auto Update Function / --
local sVersion = '0.27';
local rVersion = GetWebResult('raw.githubusercontent.com', '/janja96/BoL/master/Versions/AnnieS.version?no-cache=' .. math.random(1, 25000));

if ((rVersion) and (tonumber(rVersion) ~= nil)) then
	if (tonumber(sVersion) < tonumber(rVersion)) then
		print('<font color="#FF1493"><b>[AnnieS]:</b> </font><font color="#FFFF00">An update has been found and it is now downloading!</font>');
		DownloadFile('https://raw.githubusercontent.com/janja96/BoL/master/AnnieS.lua?no-cache=' .. math.random(1, 25000), (SCRIPT_PATH.. GetCurrentEnv().FILE_NAME), function()
			print('<font color="#FF1493"><b>[AnnieS]:</b> </font><font color="#00FF00">Script has been updated, please reload! 2x F9</font>');
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
	AnnieS = scriptConfig("AnnieS", "AnnieSave")
	-- draw menu
	AnnieS:addSubMenu("["..myHero.charName.."] - Draw", "draw")
		AnnieS.draw:addParam("drawQ", "Draw Q range: ", SCRIPT_PARAM_ONOFF, true)
		AnnieS.draw:addParam("drawW", "Draw W range: ", SCRIPT_PARAM_ONOFF, true)
		AnnieS.draw:addParam("drawR", "Draw R range: ", SCRIPT_PARAM_ONOFF, true)
		AnnieS.draw:addParam("printHp", "Print Health warning", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("A"))
	-- combo menu
	AnnieS:addSubMenu("["..myHero.charName.."] - Combo", "comboR")
		AnnieS.comboR:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		AnnieS.comboR:permaShow("combo")
	-- harass
	AnnieS:addSubMenu("["..myHero.charName.."] - Harass", "harass")
		AnnieS.harass:addParam("harassT", "Harass:", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
		AnnieS.harass:permaShow("harassT")
	-- last hit Q
	AnnieS:addSubMenu("["..myHero.charName.."] - Last hit", "lasthit")
		AnnieS.lasthit:addParam("lasthitQ", "Last hit Q:", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("K"))
	
	-- auto R for x enemys
	AnnieS:addSubMenu("["..myHero.charName.."] - Auto Ult", "auto")
		AnnieS.auto:addParam("autoR", "Auto R on X enemys:", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("M"))

	-- menu version
	AnnieS:addParam("version", "Version: " .. Version, SCRIPT_PARAM_ONOFF, true)
 
 
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
		if (AnnieS.comboR.combo) then
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
		
		-- Harass mode
		if (AnnieS.harass.harassT) then
			if (myHero:CanUseSpell(_Q) == READY) then
				CastSpell(_Q, ts.target)
			end
			if (myHero:CanUseSpell(_W) == READY) then
				CastSpell(_W, ts.target.x, ts.target.z)
			end
		end

	end
end
 
-- Drawing graphics
function OnDraw()
	--Draw circles only if activated on menu
	if (AnnieS.draw.drawQ) then
		DrawCircle(myHero.x, myHero.y, myHero.z, 630, 0x111111)
	end
	if (AnnieS.draw.drawW) then
		DrawCircle(myHero.x, myHero.y, myHero.z, 650, 0xFFFF00)
	end
	if (AnnieS.draw.drawR) then
		DrawCircle(myHero.x, myHero.y, myHero.z, 600, 0xFF6600)
	end
	
	-- Show HP warning
	if (AnnieS.draw.printHp) then
		if (myHero.health < 200) then
			DrawText("Warning: LOW HP! Drink a potion!", 18, 100, 100, 0xFFFFFF00)
		end
	end
end
