--========================--
-- Zed : Master of Shadow --
--========================--
if myHero.charName ~= "Brand" then return end  -- promeni u Zed

local sVersion = '0.01';
local rVersion = GetWebResult('raw.githubusercontent.com', '/janja96/BoL/master/Versions/Zed.version?no-cache=' .. math.random(1, 25000));


-- VPrediction
if FileExist(LIB_PATH .. "/VPrediction.lua") then
  require("VPrediction")
  VPred = VPrediction()
else
  print("Downloading VPrediction, please don't press F9")
  DelayAction(function() DownloadFile("https://raw.githubusercontent.com/SidaBoL/Scripts/master/Common/VPrediction.lua".."?rand="..math.random(1,10000), LIB_PATH.."VPrediction.lua", function () print("Successfully downloaded VPrediction. Press F9 twice.") end) end, 3)
  return
end

-- UPL
if not _G.UPLloaded then
  if FileExist(LIB_PATH .. "/UPL.lua") then
    require("UPL")
    _G.UPL = UPL()
  else
    print("Downloading UPL, please don't press F9")
    DelayAction(function() DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Common/UPL.lua".."?rand="..math.random(1,10000), LIB_PATH.."UPL.lua", function () print("Successfully downloaded UPL. Press F9 twice.") end) end, 3)
    return
  end
end


function OnLoad()
  --AutoUpdater()
  Update()
end


function Update()
  -- / Auto Update Function / --
  if ((rVersion) and (tonumber(rVersion) ~= nil)) then
  	if (tonumber(sVersion) < tonumber(rVersion)) then
  		print('<font color="#FF1493"><b>[Zed]:</b> </font><font color="#FFFF00">An update has been found and it is now downloading!</font>');
  		DownloadFile('https://raw.githubusercontent.com/janja96/BoL/master/Zed.lua?no-cache=' .. math.random(1, 25000), (SCRIPT_PATH.. GetCurrentEnv().FILE_NAME), function()
  			print('<font color="#FF1493"><b>[Zed]:</b> </font><font color="#00FF00">Script has been updated, please reload! 2x F9</font>');
  		end);
  		return;
  	end;
  	if (tonumber(sVersion) == tonumber(rVersion)) then
  		print('<font color="#FF1493"><b>[Zed]:</b> </font><font color="#FF0000">You are using the latest version!</font>');
  	end;
  	else
  		print('<font color="#FF1493"><b>[Zed]:</b> </font><font color="#FF0000">Update Error</font>');
  	end;
  -- / Auto Update Function / --
end

--[[ update
function AutoUpdater()
	local AUTOUPDATE = true
	if(AUTOUPDATE) then
		local UPDATE_HOST = "raw.githubusercontent.com"
		local UPDATE_PATH = "/janja96/BoL/blob/master/Zed.lua".."?rand="..math.random(1,10000)
		local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
		local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
		local ServerData = GetWebResult(UPDATE_HOST, "/janja96/BoL/blob/master/Versions/Zed.version")
		if ServerData then
			ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
			if ServerVersion then
				if tonumber(version) < ServerVersion then
					SendMsg("New version available "..ServerVersion)
					SendMsg(">>Updating, please don't press F9<<")
					DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () SendMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
				else
					DelayAction(function() SendMsg("Hello, "..GetUser()..". You got the latest version! :) ("..ServerVersion..")") end, 3)
				end
			end
			else
				SendMsg("Error downloading version info")
		end
	end
end
]]


--Update--
--[[
function printChat(m)
	print('<font color=\"#52527a\">Zed</font><font color=\"#888888\"> - </font><font color=\"#cccccc\">'..m..'</font>')
end

class 'Update'
function Update:__init()
  if not AutoUpdate then return end
  self.Version = scriptVersion
  self.DownloadPath = 'http://'..StridePage..ScriptLink
  self.SavePath = SCRIPT_PATH .. _ENV.FILE_NAME
  if os.clock() < 180 then
	self:Check()
  else
		DelayAction(function()
			printChat('The game is already in progress. Disabling auto update.')
		end, 2)
  end
end

function Update:RequireUpdate()
  self.NewVersion = GetWebResult(StridePage, VersionLink)
  if self.NewVersion then
	self.NewVersion = string.match(self.NewVersion, '%d.%d%d')
		self.NewVersion = tonumber(self.NewVersion)
	if self.NewVersion and self.NewVersion > scriptVersion then
	  DelayAction(function()
		printChat('New version v'..self.NewVersion..' found! Downloading... Do not press F9!')
	  end, 2)
	  return true
	else
	  DelayAction(function()
		printChat('No new updates found.')
	  end, 2)
	  return false
	end
  end
end

function Update:Check()
  if self:RequireUpdate() then
	DownloadFile(self.DownloadPath, self.SavePath,
	function()
	  if FileExist(self.SavePath) then
		DelayAction(function()
		  printChat('Script updated! Please reload BOL for changes to take effect!')
		end, 3)
	  end
	end)
  else
	end
end
]]

--[[
  Changelog:
   need to fix update finish

]]
