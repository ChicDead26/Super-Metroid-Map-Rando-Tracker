ScriptHost:LoadScript("scripts/settings.lua")

Tracker:AddItems("items/objectives.json")
Tracker:AddItems("items/objBosses.json")
Tracker:AddItems("items/objMinibosses.json")
Tracker:AddItems("items/objMetroids.json")
Tracker:AddItems("items/objChozos.json")
Tracker:AddItems("items/objPirates.json")
Tracker:AddItems("items/difficulty.json")
Tracker:AddItems("items/itemprogression.json")
Tracker:AddItems("items/qualityoflife.json")
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/bosses.json")
Tracker:AddItems("items/minibosses.json")
Tracker:AddItems("items/metroids.json")
Tracker:AddItems("items/chozos.json")
Tracker:AddItems("items/pirates.json")
Tracker:AddItems("items/extras.json")

Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")

if _VERSION == "Lua 5.3" then
    ScriptHost:LoadScript("scripts/autotracking.lua")
else
    print("Auto-tracker is unsupported by your tracker version")
end
