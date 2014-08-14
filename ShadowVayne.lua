--[[

	Shadow Vayne Script by Superx321

	For Functions & Changelog, check the Thread on the BoL Forums:
	http://botoflegends.com/forum/topic/18939-shadow-vayne-the-mighty-hunter/
	]]
if myHero.charName ~= "Vayne" then return end

_OwnEnv = GetCurrentEnv().FILE_NAME:gsub(".lua", "")
ShadowVersion = 1.4

------------------------
------ MainScript ------
------------------------
function OnLoad()
	TCPU = TCPUpdater()
	TCPU:AddScript("VPrediction","Lib","raw.githubusercontent.com","/Hellsing/BoL/master/common/VPrediction.lua","/Hellsing/BoL/master/version/VPrediction.version","local version", "Free")
	TCPU:AddScript("SOW","Lib","raw.githubusercontent.com","/Hellsing/BoL/master/common/SOW.lua","/Hellsing/BoL/master/version/SOW.version","local version", "Free")
--~ 	TCPU:AddScript("SourceLib","Lib","raw.githubusercontent.com","/TheRealSource/public/master/common/SourceLib.lua","/TheRealSource/public/master/common/SourceLib.version","local version", "Free")
--~ 	TCPU:AddScript("Selector","Lib","raw.githubusercontent.com","/pqmailer/BoL_Scripts/master/Paid/Selector.lua","/pqmailer/BoL_Scripts/master/Paid/Selector.revision","@version", "VIP")
	TCPU:AddScript("CustomPermaShow","Lib","raw.githubusercontent.com","/Superx321/BoL/master/common/CustomPermaShow.lua","/Superx321/BoL/master/common/CustomPermaShow.Version","version =", "Free")
	TCPU:AddScript("ShadowVayneLib","Lib","raw.githubusercontent.com","/Superx321/BoL/master/common/ShadowVayneLib.lua","/Superx321/BoL/master/common/ShadowVayneLib.Version","version =", "Free")
	if VIP_USER then TCPU:AddScript("Prodiction","Lib","bitbucket.org","/Klokje/public-klokjes-bol-scripts/raw/aef4be4e92a5b1ba70154752c49e4978e7178dd4/Test/Prodiction/Prodiction.lua",nil,"--Prodiction", "VIP", 1.2) end
	TCPU:AddScript(_OwnEnv,"Script","raw.githubusercontent.com","/Superx321/BoL/master/ShadowVayne.lua","/Superx321/BoL/master/ShadowVayne.Version","ShadowVersion =")
end

function OnTick()
	if not _G.ShadowVayneLoaded then
		local NeedWait = false
		for i, UpdateStatus in pairs(_G.TCPUpdates) do
			if UpdateStatus == false then
				NeedWait = true
				break
			end
		end
		if NeedWait == false then
			_G.ShadowVayneLoaded = true
			ShadowVayne()
		end
	end
end

------------------------
------ TCPUpdater ------
------------------------
class "TCPUpdater"
function TCPUpdater:__init()
	_G.TCPUpdates = {}
	_G.TCPUpdaterLoaded = true
	self.AutoUpdates = {}
	self.LuaSocket = require("socket")
	AddTickCallback(function() self:TCPUpdate() end)
end

function TCPUpdater:TCPUpdate()
	for i=1,#self.AutoUpdates do
		if not self.AutoUpdates[i]["ScriptPath"] then
			self.AutoUpdates[i]["ScriptPath"] = self:GetScriptPath(self.AutoUpdates[i])
		end

		if self.AutoUpdates[i]["ScriptPath"] and not self.AutoUpdates[i]["LocalVersion"] then
			self.AutoUpdates[i]["LocalVersion"] = self:GetLocalVersion(self.AutoUpdates[i])
		end
		if not self.AutoUpdates[i]["ServerVersion"] and self.AutoUpdates[i]["ScriptPath"] and self.AutoUpdates[i]["LocalVersion"] then
			self.AutoUpdates[i]["ServerVersion"] = self:GetOnlineVersion(self.AutoUpdates[i])
		end

		if self.AutoUpdates[i]["ServerVersion"] and self.AutoUpdates[i]["LocalVersion"] and self.AutoUpdates[i]["ScriptPath"] and not _G.TCPUpdates[self.AutoUpdates[i]["Name"]] then
			if self.AutoUpdates[i]["ServerVersion"] > self.AutoUpdates[i]["LocalVersion"] and self.AutoUpdates[i]["ServerVersion"] < 9999999999 then
				print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">Updating ".. self.AutoUpdates[i]["Name"].." to Version "..self.AutoUpdates[i]["ServerVersion"].."</font>")
				self:DownloadUpdate(self.AutoUpdates[i])
			else
				self:LoadScript(self.AutoUpdates[i])
			end
		end
	end
end

function TCPUpdater:LoadScript(TCPScript)
	if TCPScript["ScriptRequire"] then
		if TCPScript["ScriptRequire"] == "VIP" then
			if VIP_USER then
				loadfile(TCPScript["ScriptPath"])()
			end
		else
			loadfile(TCPScript["ScriptPath"])()
		end
	end
	_G.TCPUpdates[TCPScript["Name"]] = true
end

function TCPUpdater:GetScriptPath(TCPScript)
	if TCPScript["Type"] == "Lib" then
		return LIB_PATH..TCPScript["Name"]..".lua"
	else
		return SCRIPT_PATH..TCPScript["Name"]..".lua"
	end
end

function TCPUpdater:GetOnlineVersion(TCPScript)
	if not TCPScript["VersionSocket"] then
		TCPScript["VersionSocket"] = self.LuaSocket.connect("sx-bol.eu", 80)
		TCPScript["VersionSocket"]:send("GET /BoL/TCPUpdater/GetScript.php?script="..TCPScript["Host"]..TCPScript["VersionLink"].."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
	end

	if TCPScript["VersionSocket"] then
		TCPScript["VersionSocket"]:settimeout(0)
		TCPScript["VersionReceive"], TCPScript["VersionStatus"] = TCPScript["VersionSocket"]:receive('*a')
	end

	if TCPScript["VersionSocket"] and TCPScript["VersionStatus"] ~= 'timeout' then
		if TCPScript["VersionReceive"] == nil then
			return 0
		else
			return tonumber(string.sub(TCPScript["VersionReceive"], string.find(TCPScript["VersionReceive"], "<bols".."cript>")+11, string.find(TCPScript["VersionReceive"], "</bols".."cript>")-1))
		end
	end
end

function TCPUpdater:GetLocalVersion(TCPScript)
	if FileExist(TCPScript["ScriptPath"]) then
		self.FileOpen = io.open(TCPScript["ScriptPath"], "r")
		self.FileString = self.FileOpen:read("*a")
		self.FileOpen:close()
		VersionPos = self.FileString:find(TCPScript["VersionSearchString"])
		if VersionPos ~= nil then
			self.VersionString = string.sub(self.FileString, VersionPos + string.len(TCPScript["VersionSearchString"]) + 1, VersionPos + string.len(TCPScript["VersionSearchString"]) + 11)
			self.VersionSave = tonumber(string.match(self.VersionString, "%d *.*%d"))
		end
		if self.VersionSave == 2.431 then self.VersionSave = math.huge end -- VPred 2.431
		if self.VersionSave == nil then self.VersionSave = 0 end
	else
		self.VersionSave = 0
	end
	return self.VersionSave
end

function TCPUpdater:DownloadUpdate(TCPScript)
	if not TCPScript["ScriptSocket"] then
		TCPScript["ScriptSocket"] = self.LuaSocket.connect("sx-bol.eu", 80)
		TCPScript["ScriptSocket"]:send("GET /BoL/TCPUpdater/GetScript.php?script="..TCPScript["Host"]..TCPScript["ScriptLink"].."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
	end

	if TCPScript["ScriptSocket"] then
		TCPScript["ScriptReceive"], TCPScript["ScriptStatus"] = TCPScript["ScriptSocket"]:receive('*a')
	end

	if TCPScript["ScriptSocket"] and TCPScript["ScriptStatus"] ~= 'timeout' then
		if TCPScript["ScriptReceive"] == nil then
			print("Error in Loading Module: "..TCPScript["Name"])
		else
			self.FileOpen = io.open(TCPScript["ScriptPath"], "w+")
			self.FileOpen:write(string.sub(TCPScript["ScriptReceive"], string.find(TCPScript["ScriptReceive"], "<bols".."cript>")+11, string.find(TCPScript["ScriptReceive"], "</bols".."cript>")-1))
			self.FileOpen:close()
			self:LoadScript(TCPScript)
		end
	end
end

function TCPUpdater:AddScript(Name, Type, Host, ScriptLink, VersionLink, VersionSearchString, ScriptRequire, ServerVersion)
	table.insert(self.AutoUpdates, {["Name"] = Name, ["Type"] = Type, ["Host"] = Host, ["ScriptLink"] = ScriptLink, ["VersionLink"] = VersionLink, ["VersionSearchString"] = VersionSearchString, ["ScriptRequire"] = ScriptRequire, ["ServerVersion"] = ServerVersion})
	_G.TCPUpdates[Name] = false
end

------------------------
---- AddParam Hooks ----
------------------------
_G.scriptConfig.CustomaddParam = _G.scriptConfig.addParam
_G.scriptConfig.addParam = function(self, pVar, pText, pType, defaultValue, a, b, c, d)

 -- MMA Hook
if self.name == "MMA2013" and pText:find("OnHold") then
	pType = 5
end

-- SAC:Reborn r83 Hook
if self.name:find("sidasacsetup_sidasac") and (pText == "Auto Carry" or pText == "Mixed Mode" or pText == "Lane Clear" or pText == "Last Hit") then
	pType=5
end

-- SAC:Reborn r84 Hook
if self.name:find("sidasacsetup_sidasac") and (pText == "Hotkey") then
	pType=5
end

-- SAC:Reborn VayneMenu Hook
if self.name:find("sidasacvayne") then
	pType=5
end

-- SOW Hook
if self.name == "SV_SOW" and pVar:find("Mode") then
	pType=5
end

 _G.scriptConfig.CustomaddParam(self, pVar, pText, pType, defaultValue, a, b, c, d)
end

-------------------------
---- DrawParam Hooks ----
-------------------------
_G.scriptConfig.CustomDrawParam = _G.scriptConfig._DrawParam
_G.scriptConfig._DrawParam = function(self, varIndex)
	local HideParam = false

	if self.name:find("sidasacsetup_sidasac") and (self._param[varIndex].text == "Hotkey") then
		self._param[varIndex].text = "ShadowVayne found. Set the Keysettings there!"
		self._param[varIndex].var = "sep"
	end

	if self.name == "MMA2014" and (self._param[varIndex].text:find("Spells on") or self._param[varIndex].text:find("Version")) then
	HideParam = true
		if not MMAParams then
			MMAParams = true
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
			self:addParam(self._param[varIndex].var, "Use Spells On", SCRIPT_PARAM_LIST,1, {"None","All Units","Heroes Only","Minion Only"})
			self:addParam("mmaVersion","MMA - version:", SCRIPT_PARAM_INFO, "0.1416")
		end
	end

	if self.name:find("sidasacvayne") and not self._param[varIndex].text:find("ShadowVayne") then
		if not SACVayneParam then
			SACVayneParam = true
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
		end
		HideParam = true
	end

	if self.name == "SV_MAIN_keysetting" and self._param[varIndex].text:find("Hidden") then
		HideParam = true
	end

	if self.name == "SV_SOW" and (self._param[varIndex].var == "Hotkeys" or self._param[varIndex].var:find("Mode")) then HideParam = true end

	if (self.name == "MMA2014" and self._param[varIndex].text:find("OnHold")) then HideParam = true end
	if not HideParam then
		_G.scriptConfig.CustomDrawParam(self, varIndex)
	end
end

-------------------------
----- SubMenu Hooks -----
-------------------------
_G.scriptConfig.CustomDrawSubInstance = _G.scriptConfig._DrawSubInstance
_G.scriptConfig._DrawSubInstance = function(self, index)
	if not self.name:find("sidasacvayne") then
		_G.scriptConfig.CustomDrawSubInstance(self, index)
	end
end

-------------------------
---- PermaShow Hooks ----
-------------------------
_G.scriptConfig.CustompermaShow = _G.scriptConfig.permaShow
_G.scriptConfig.permaShow = function(self, pVar)
	if not (self.name:find("sidasacvayne") or self.name == "MMA2014") then
		_G.scriptConfig.CustompermaShow(self, pVar)
	end
end
