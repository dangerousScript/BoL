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

--[[  AUTOUPDATE 
	
local autoupdate = true
function Update(arg)
	if arg ~= "force" then
		if not autoupdate then
			p("Autoupdate's disabled")
		return
		end
	end
		p("Updating S1mple_Ziggs")
		local ServerData = GetWebResult(Update_HOST, "/Scarjit/Scripts/master/S1mple_Ziggs.version")
		if ServerData then
			ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
			if ServerVersion then
				if tonumber(version) < ServerVersion then
					p("Update found")
					p("Local Version: "..version" <==> ServerVersion: "..ServerVersion)
					p("Updating, don't press F9")
					DelayAction(function() DownloadFile(Update_URL, Update_FILE_PATH, function () p("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
				elseif  tonumber(version) == ServerVersion then
					p("No Update found")
				elseif tonumber(version) > ServerVersion then
					p("WARNING: There is something wrong, with the Updater")
					p("or you have manually changed your Version Number")
				end
			end
		else
			p("Autoupdate failed")
		end
end

]]





-- We will store the target selector on this variable
local ts
local Version = 0.10
 
-- Execute only at start of the game
function OnLoad()
	-- Menu
	Config = scriptConfig("Annie - TheDaddy", "AnnieSave")
	Config:addParam("drawCircle", "Draw Circle", SCRIPT_PARAM_ONOFF, true)
	Config:addParam("printHp", "Print Health warning", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("A"))
	Config:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
 
 
	-- We create a target selector
	ts = TargetSelector(TARGET_LOW_HP_PRIORITY,650)

	-- Welcome message
	PrintChat("<font color=\"#FF0000\">[Annie]:</font> <font color=\"#FFFFFF\">Loaded Version: </font>" ..Version.. "<font color=\"#FFFFFF\"> by stefisa</font>")
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
		DrawCircle(myHero.x, myHero.y, myHero.z, 650, 0x111111)
	end
	
	-- Show HP warning
	if (Config.printHp) then
		if (myHero.health < 200) then
			DrawText("Warning: LOW HP! Drink a potion!", 18, 100, 100, 0xFFFFFF00)
		end
	end
end
