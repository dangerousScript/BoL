--[[
        This is my frist script 
        But who cares about fucking comments :O
        
  YOLOOOOOOOOOOO

Changelogs:
        0.10 - Added 13 lines of code !!!!!!! FUCK YEAH!
        0.11 - I WANNA LEARN TO SCRIPT FOR BoL 1 & BoL 2 !!!!
        0.12 - Drawings added 
        
 TODO:
        Spell cast
        Menu
        Something more when i learn
]]--

local version = 0.12
local AUTOUPDATE = true

-- Get our champion
myHero = GetMyHero()

function OnTick()
        if (myHero.health < 200) then
                PrintChat("Warning: LOW HP! Drink a potion!"
        end
end

function OnDraw()
        if (myHero.mana < 150) then
                -- DrawText("XXX", TextSize, X, Y, HexColor)
                DrawText("Warning: LOW MANA! Drink blue potion!", 18, 100, 100, 0x0000FF)
        end
end



