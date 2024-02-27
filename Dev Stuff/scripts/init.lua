ScriptHost:LoadScript("scripts/settings.lua")
ScriptHost:LoadScript("scripts/class.lua")
ScriptHost:LoadScript("scripts/custom_item.lua")
ScriptHost:LoadScript("scripts/toggle.lua")
ScriptHost:LoadScript("scripts/optionalPhantoon.lua")
--ScriptHost:LoadScript("scripts/objectiveSwitch.lua")
--ScriptHost:LoadScript("scripts/objectiveTest.lua")
--ScriptHost:LoadScript("scripts/optionalWalljumpBoots.lua")
--ScriptHost:LoadScript("scripts/walljumpBoots.lua")
ScriptHost:LoadScript("scripts/toggleToggle.lua")
ScriptHost:LoadScript("scripts/toggleProgressive.lua")
--ScriptHost:LoadScript("scripts/toggleProgressive.lua")
--ScriptHost:LoadScript("scripts/toggleProgressive2.lua")
--ScriptHost:LoadScript("scripts/toggleProgressive3.lua")
--ScriptHost:LoadScript("scripts/toggleProgressive4.lua")



local newItem = ToggleItem("Test", "test", "images/Miniboss3E.png")
local newPhantoon = OptionalPhantoon("OptionalPhantoon", "optionalphantoon", "images/Boss3.png")
--local newObjective = ObjectiveTest("ObjectiveTest", "objectiveSwitch", "images/obj_bosses.png", "images/obj_minibosses.png", "images/obj_metroids.png", newPhantoon)
--local walljumpBoots = OptionalWalljumpBoots("WalljumpBoots", "aa", "images/walljumpboots.png")
--local walljumpBoots = WalljumpBoots("WalljumpBoots", "walljumpBoots", "images/walljumpboots.png")


--local whatever = StupidTest("Test", "test", "images/Miniboss3E.png")
--newObjective:

Tracker:AddItems("items/objectives.json")
Tracker:AddItems("items/difficulty.json")
Tracker:AddItems("items/itemprogression.json")
Tracker:AddItems("items/qualityoflife.json")
Tracker:AddItems("items/maplayout.json")
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/bosses.json")
Tracker:AddItems("items/minibosses.json")
Tracker:AddItems("items/metroids.json")
Tracker:AddItems("items/chozos.json")
Tracker:AddItems("items/pirates.json")
Tracker:AddItems("items/random.json")
Tracker:AddItems("items/larvas.json")
Tracker:AddItems("items/extras.json")

if Tracker.ActiveVariantUID ~= "full" then
    --toggleEye = ToggleProgressive("ToggleEye", "toggleEye", "images/OffTracker/togglePlanetAwakenYes.png", "images/OffTracker/togglePlanetAwakenNo.png", 1, "images/eyeE.png")
    toggleEye = ToggleToggle("ToggleEye", "toggleEye", "images/OffTracker/togglePlanetAwakenYes.png", "images/OffTracker/togglePlanetAwakenNo.png", "eye", "images/eyeE.png", true, 2)

    if Tracker.ActiveVariantUID ~= "boss" then
        --togglePhantoon = ToggleProgressive2("TogglePhantoon", "togglePhantoon", "images/OffTracker/toggleOptionalPhantoonYes.png", "images/OffTracker/toggleOptionalPhantoonNo.png", 2, "images/Boss3.png")
        togglePhantoon = ToggleToggle("TogglePhantoon", "togglePhantoon", "images/OffTracker/toggleOptionalPhantoonYes.png", "images/OffTracker/toggleOptionalPhantoonNo.png", "phantoon", "images/Boss3.png", true, 2)
    end
    --toggleWalljumpBoots = ToggleProgressive3("ToggleWalljumpBoots", "toggleWalljumpBoots", "images/OffTracker/toggleWalljumpBootsYes.png", "images/OffTracker/toggleWalljumpBootsNo.png", 3, "images/walljumpboots.png")
    toggleWalljumpBoots = ToggleProgressive("ToggleWalljumpBoots", "toggleWalljumpBoots", "images/OffTracker/toggleWalljumpBootsYes.png", "images/OffTracker/toggleWalljumpBootsNo.png", "walljumpBoots", "images/walljumpboots.png", false, 1)
    --toggleCanWalljump = ToggleProgressive4("ToggleCanWalljump", "toggleCanWalljump", "images/OffTracker/toggleCanWalljumpYes.png", "images/OffTracker/toggleCanWalljumpNo.png", 4, "images/canWalljumpE.png")
    toggleCanWalljump = ToggleToggle("ToggleCanWalljump", "toggleCanWalljump", "images/OffTracker/toggleCanWalljumpYes.png", "images/OffTracker/toggleCanWalljumpNo.png", "canWalljump", "images/canWalljumpE.png", false, 2)
end

--print(toggleWalljumpBoots == nil)
--print("making sure")

--togglePhantoon:updateIcon()
--ToggleProgressive.updateIcon()
--Tracker:AddMaps("maps/maps.json")
--
--Tracker:AddLocations("locations/logic.json")
--Tracker:AddLocations("locations/locations.json")

Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")
--toggleWalljumpBoots:updateIcon()

--Tracker:FindObjectForCode("ridley").Stage = 0
--Tracker:FindObjectForCode("draygon").Active = true
--Tracker:FindObjectForCode("kraid").Active = true
--Tracker:FindObjectForCode("phantoon").Active = true

--Tracker:FindObjectForCode("bombtorizo").Active = true
--Tracker:FindObjectForCode("sporespawn").Active = true
--Tracker:FindObjectForCode("crocomire").Active = true
--Tracker:FindObjectForCode("botwoon").Active = true
--Tracker:FindObjectForCode("goldentorizo").Active = true

--Tracker:FindObjectForCode("bowlingchozo").Active = true
--Tracker:FindObjectForCode("acidchozo").Active = true

--Tracker:FindObjectForCode("metroids1").Active = true
--Tracker:FindObjectForCode("metroids2").Active = true
--Tracker:FindObjectForCode("metroids3").Active = true
--Tracker:FindObjectForCode("metroids4").Active = true

--Tracker:FindObjectForCode("pitpirates").Active = true
--Tracker:FindObjectForCode("babykraidpirates").Active = true
--Tracker:FindObjectForCode("plasmapirates").Active = true
--Tracker:FindObjectForCode("metalpirates").Active = true

--Tracker:FindObjectForCode("eye").Active = true

if _VERSION == "Lua 5.3" then
    ScriptHost:LoadScript("scripts/autotracking.lua")
else
    print("Auto-tracker is unsupported by your tracker version")
end


