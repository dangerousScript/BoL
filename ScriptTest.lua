--[[
        This is my frist script 
        But who cares about fucking comments :O
        
  YOLOOOOOOOOOOO

Changelogs:
        0.10 - Added 13 lines of code !!!!!!! FUCK YEAH!
        0.11 - I WANNA LEARN TO SCRIPT FOR BoL 1 & BoL 2 !!!!
        
 TODO:
        Add drawings
        Spell cast
        Menu
        Something more when i learn
]]--

local version = 0.10
local AUTOUPDATE = true

-- Get our champion
myHero = GetMyHero()

function OnTick()
        if (myHero.health < 200) then
                PrintChat("Warning: LOW HP! Drink a potion!"
        end
end

function OnDraw()
        if (myHero.mana < 200) then
                DrawText("text", TextSize, X, Y, HexColor)
        end
end



