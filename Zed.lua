--========================--
-- Zed : Master of Shadow --
--========================--
if myHero.charName ~= "Brand" then return end  -- promeni u Zed

local sVersion = '0.021'
local rVersion = GetWebResult('raw.githubusercontent.com', '/janja96/BoL/master/Versions/Zed.version?no-cache=' .. math.random(1, 25000))


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
  Update()
end


function Update()
  -- / Auto Update Function / --
  if ((rVersion) and (tonumber(rVersion) ~= nil)) then
  	if (tonumber(sVersion) < tonumber(rVersion)) then
  		print('<font color="#FF1493"><b>[Zed]:</b> </font><font color="#FFFF00">An update has been found and it is now downloading!</font>')
  		DownloadFile('https://raw.githubusercontent.com/janja96/BoL/master/Zed.lua?no-cache=' .. math.random(1, 25000), (SCRIPT_PATH.. GetCurrentEnv().FILE_NAME), function()
  			print('<font color="#FF1493"><b>[Zed]:</b> </font><font color="#00FF00">Script has been updated, please reload! 2x F9</font>') 
  		end)
  		return
  	end
  	if (tonumber(sVersion) == tonumber(rVersion)) then
  		print('<font color="#FF1493"><b>[Zed]:</b> </font><font color="#FF0000">You are using the latest version!</font>')
  	end
  	else
  		print('<font color="#FF1493"><b>[Zed]:</b> </font><font color="#FF0000">Update Error</font>')
  	end
  -- / Auto Update Function / --
end

--[[
  Changelog:
   0.021: AutoUpdater added

]]
