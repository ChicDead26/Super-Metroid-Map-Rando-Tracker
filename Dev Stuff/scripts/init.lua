ScriptHost:LoadScript("scripts/settings.lua")
ScriptHost:LoadScript("scripts/class.lua")
ScriptHost:LoadScript("scripts/custom_item.lua")
ScriptHost:LoadScript("scripts/toggleToggle.lua")
ScriptHost:LoadScript("scripts/toggleProgressive.lua")

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
    toggleEye = ToggleToggle("ToggleEye", "toggleEye", "images/OffTracker/togglePlanetAwakenYes.png", "images/OffTracker/togglePlanetAwakenNo.png", "eye", "images/EyeE.png", true, 2)
    print("post toggle eye")
    if Tracker.ActiveVariantUID ~= "boss" then
        togglePhantoon = ToggleToggle("TogglePhantoon", "togglePhantoon", "images/OffTracker/toggleOptionalPhantoonYes.png", "images/OffTracker/toggleOptionalPhantoonNo.png", "phantoon", "images/Boss3.png", true, 2)
    end
    print("post toggle phantoon")

    toggleWalljumpBoots = ToggleProgressive("ToggleWalljumpBoots", "toggleWalljumpBoots", "images/OffTracker/toggleWalljumpBootsYes.png", "images/OffTracker/toggleWalljumpBootsNo.png", "walljumpBoots", "images/walljumpboots.png", false, 1)
    print("post toggle boots")
    toggleCanWalljump = ToggleToggle("ToggleCanWalljump", "toggleCanWalljump", "images/OffTracker/toggleCanWalljumpYes.png", "images/OffTracker/toggleCanWalljumpNo.png", "canWalljump", "images/canWalljumpE.png", false, 2)
    print("post toggle walljump")
end

Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")

if _VERSION == "Lua 5.3" then
    ScriptHost:LoadScript("scripts/autotracking.lua")
else
    print("Auto-tracker is unsupported by your tracker version")
end
