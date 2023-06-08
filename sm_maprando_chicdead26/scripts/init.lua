ScriptHost:LoadScript("scripts/class.lua")
ScriptHost:LoadScript("scripts/custom_item.lua")
ScriptHost:LoadScript("scripts/toggle.lua")
ScriptHost:LoadScript("scripts/optionalPhantoon.lua")
ScriptHost:LoadScript("scripts/objectiveSwitch.lua")
ScriptHost:LoadScript("scripts/objectiveTest.lua")

local newItem = ToggleItem("Test", "test", "images/Miniboss3E.png")
local newPhantoon = OptionalPhantoon("OptionalPhantoon", "optionalphantoon", "images/Boss3.png")
local newObjective = ObjectiveTest("ObjectiveTest", "objectiveSwitch", "images/obj_bosses.png", "images/obj_minibosses.png", "images/obj_metroids.png", newPhantoon)
--local whatever = StupidTest("Test", "test", "images/Miniboss3E.png")
--newObjective:

Tracker:AddItems("items/objectives.json")
Tracker:AddItems("items/objBosses.json")
Tracker:AddItems("items/objMinibosses.json")
Tracker:AddItems("items/objMetroids.json")
Tracker:AddItems("items/difficulty.json")
Tracker:AddItems("items/itemprogression.json")
Tracker:AddItems("items/qualityoflife.json")
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/bosses.json")
Tracker:AddItems("items/minibosses.json")
Tracker:AddItems("items/metroids.json")

--Tracker:AddMaps("maps/maps.json")
--
--Tracker:AddLocations("locations/logic.json")
--Tracker:AddLocations("locations/locations.json")

Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")

