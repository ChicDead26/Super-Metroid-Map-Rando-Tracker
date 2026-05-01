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
Tracker:AddItems("items/fullobjectives.json")
Tracker:AddItems("items/bosses.json")
Tracker:AddItems("items/minibosses.json")
Tracker:AddItems("items/metroids.json")
Tracker:AddItems("items/chozos.json")
Tracker:AddItems("items/pirates.json")
Tracker:AddItems("items/random.json")
Tracker:AddItems("items/larvas.json")
Tracker:AddItems("items/extras.json")

ScriptHost:LoadScript("scripts/toggleProgressiveSwitcheroo.lua")
ScriptHost:LoadScript("scripts/toggleSwitch.lua")

if Tracker.ActiveVariantUID ~= "full" then
    toggleEye = ToggleToggle("ToggleEye", "toggleEye", "images/OffTracker/togglePlanetAwakenYes.png", "images/OffTracker/togglePlanetAwakenNo.png", "eye", "images/EyeE.png", true, 2)
    print("post toggle eye")

    if Tracker.ActiveVariantUID ~= "boss" then
        togglePhantoon = ToggleToggle("TogglePhantoon", "togglePhantoon", "images/OffTracker/toggleOptionalPhantoonYes.png", "images/OffTracker/toggleOptionalPhantoonNo.png", "phantoon", "images/Boss3.png", true, 2)
    end
    print("post toggle phantoon")

    toggleWalljumpBoots = ToggleProgressive("ToggleWalljumpBoots", "toggleWalljumpBoots", "images/OffTracker/toggleWalljumpBootsYes.png", "images/OffTracker/toggleWalljumpBootsNo.png", "walljumpBoots", "images/walljumpboots.png", false, 1)
    print("post toggle boots")

end

switchSpeed = ToggleSwitch("SwitchSpeed", "switchSpeed", "images/speed.png", "images/blue.png", false, 1)
toggleSpeedBoosterSplit = ToggleProgressiveSwitcheroo("ToggleSpeedBoosterSplit", "toggleSpeedBoosterSplit", "images/OffTracker/toggleSpeedBoosterSplitYes.png", "images/OffTracker/toggleSpeedBoosterSplitNo.png", "speed", "spark", "images/blue.png", "images/speed.png", "images/spark.png", false, 1)

Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")

ScriptHost:LoadScript("scripts/autotracking.lua")