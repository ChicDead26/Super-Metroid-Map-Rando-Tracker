-- Configuration --------------------------------------
AUTOTRACKER_ENABLE_DEBUG_LOGGING = false
-------------------------------------------------------

print("")
print("Active Auto-Tracker Configuration")
print("---------------------------------------------------------------------")
print("Enable Item Tracking:        ", AUTOTRACKER_ENABLE_ITEM_TRACKING)
print("Enable Location Tracking:    ", AUTOTRACKER_ENABLE_LOCATION_TRACKING)
if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
    print("Enable Debug Logging:        ", "true")
end
print("---------------------------------------------------------------------")
print("")

--Variable used for communicating between the charge beam item and the charge upgrade count.
hasChargeBeam = false

U8_READ_CACHE = 0
U8_READ_CACHE_ADDRESS = 0

U16_READ_CACHE = 0
U16_READ_CACHE_ADDRESS = 0

-- ************************** Memory reading helper functions

function InvalidateReadCaches()
    U8_READ_CACHE_ADDRESS = 0
    U16_READ_CACHE_ADDRESS = 0
end

function ReadU8(segment, address)
    if U8_READ_CACHE_ADDRESS ~= address then
        U8_READ_CACHE = segment:ReadUInt8(address)
        U8_READ_CACHE_ADDRESS = address
    end

    return U8_READ_CACHE
end

function ReadU16(segment, address)
    if U16_READ_CACHE_ADDRESS ~= address then
        U16_READ_CACHE = segment:ReadUInt16(address)
        U16_READ_CACHE_ADDRESS = address
    end

    return U16_READ_CACHE
end

-- *************************** Game status

function isInGame()
    local mainModuleIdx = AutoTracker:ReadU8(0x7e0998, 0)

    local inGame = (mainModuleIdx >= 0x06 and mainModuleIdx <= 0x12)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print("*** In-game Status: ", '0x7e0998', string.format('0x%x', mainModuleIdx), inGame)
    end
    return inGame
end

-- ******************** Helper functions for updating items and locations

function updateSectionChestCountFromByteAndFlag(segment, locationRef, address, flag, callback)
    local location = Tracker:FindObjectForCode(locationRef)
    if location then
        -- Do not auto-track this if the user has manually modified it
        if location.Owner.ModifiedByUser then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
                print("* Skipping user modified location: ", locationRef)
            end
            return
        end

        local value = ReadU8(segment, address)
        local check = value & flag

        if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
            print("Updating chest count:", locationRef, string.format('0x%x', address),
                    string.format('0x%x', value), string.format('0x%x', flag), check ~= 0)
        end

        if check ~= 0 then
            location.AvailableChestCount = 0
            if callback then
                callback(true)
            end
        else
            location.AvailableChestCount = location.ChestCount
            if callback then
                callback(false)
            end
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print("***ERROR*** Couldn't find location:", locationRef)
    end
end

function updateAmmoFrom2Bytes(segment, code, address)
	print("starting ammo function")
    local item = Tracker:FindObjectForCode(code)
    local value = ReadU16(segment, address)

    if item then
        if code == "etank" then
            if value > 1499 then
                item.AcquiredCount = 14
            else
                item.AcquiredCount = value/100
            end
        elseif code == "reservetank" then
            if value > 400 then
                item.AcquiredCount = 4
            else
                item.AcquiredCount = value/100
            end
        else
            item.AcquiredCount = value
        end
		
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
            print("Ammo:", item.Name, string.format("0x%x", address), value, item.AcquiredCount)
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print("***ERROR*** Couldn't find item: ", code)
    end
end

function updateToggleItemFromByteAndFlag(segment, code, address, flag)
	print("starting item function")
    local item = Tracker:FindObjectForCode(code)

    if item then
        local value = ReadU8(segment, address)

        local flagTest = value & flag

        if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
            print("Item:", item.Name, string.format("0x%x", address), string.format("0x%x", value),
                    string.format("0x%x", flag), flagTest ~= 0)
        end
			if flagTest ~= 0 then
			    hasChargeBeam = true
			end
		        if code == "chargebeam" then
      --Reset the variable so we can have the correct status upon a death.
      hasChargeBeam = false
      if flagTest ~= 0 then
          hasChargeBeam = true
      end
        elseif flagTest ~= 0 then
            print(item.Name)

            if item.Name == "ToggleWalljumpBoots" then

                toggleWalljumpBoots:setActive(true)
                return
            end

            if item.Name == "CanWalljump" then
                toggleCanWalljump:setActive(true)
                item.CurrentStage = 1
                local canWalljumpItem = Tracker:FindObjectForCode(code)
                canWalljumpItem.Active = true

                return
            end

            if code == "ridley" or code == "draygon" or code == "phantoon" or code == "kraid" or code == "bombtorizo" or code == "sporespawn" or code == "crocomire" or code == "botwoon" or code == "goldentorizo" or code == "metroids1" or code == "metroids2" or code == "metroids3" or code == "metroids4" or code == "bowlingchozo" or code == "acidchozo" or code == "pitpirates" or code == "babykraidpirates" or code == "plasmapirates" or code == "metalpirates" or code == "eye" then
                item.CurrentStage = 1
            elseif code ~= "etank" or code ~= "missile" or code ~= "super" or code ~= "pb" or code ~= "reservetank" then
                item.Active = true
            else
                --item.Active = false
            end
        else
            if item.Name == "ToggleWalljumpBoots" then
                toggleWalljumpBoots:setActive(false)
                return 
            end

            if item.Name == "CanWalljump" then
                toggleCanWalljump:setActive(false)
                item.Active = 2
                local canWalljumpItem = Tracker:FindObjectForCode(code)
                canWalljumpItem.Active = false

                return
            end

            if code == "ridley" or code == "draygon" or code == "phantoon" or code == "kraid" or code == "bombtorizo" or code == "sporespawn" or code == "crocomire" or code == "botwoon" or code == "goldentorizo" or code == "metroids1" or code == "metroids2" or code == "metroids3" or code == "metroids4" or code == "bowlingchozo" or code == "acidchozo" or code == "pitpirates" or code == "babykraidpirates" or code == "plasmapirates" or code == "metalpirates" or code == "eye" then
                item.CurrentStage = 0
            elseif code ~= "etank" or code ~= "missile" or code ~= "super" or code ~= "pb" or code ~= "reservetank" then
                item.Active = false
            else
                --item.Active = true
            end
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print("***ERROR*** Couldn't find item: ", code)
    end
end


-- ************************* Main functions

function updateItems(segment)
    if not isInGame() then
        return false
    end
    if AUTOTRACKER_ENABLE_ITEM_TRACKING then
        InvalidateReadCaches()
        local address = 0x7e09a2

        updateToggleItemFromByteAndFlag(segment, "charge", address + 0x07, 0x10)

        updateToggleItemFromByteAndFlag(segment, "varia", address + 0x02, 0x01)
        updateToggleItemFromByteAndFlag(segment, "spring", address + 0x02, 0x02)
        updateToggleItemFromByteAndFlag(segment, "morph", address + 0x02, 0x04)
        updateToggleItemFromByteAndFlag(segment, "screw", address + 0x02, 0x08)
        updateToggleItemFromByteAndFlag(segment, "gravity", address + 0x02, 0x20)

        updateToggleItemFromByteAndFlag(segment, "hijump", address + 0x03, 0x01)
        updateToggleItemFromByteAndFlag(segment, "space", address + 0x03, 0x02)
        updateToggleItemFromByteAndFlag(segment, "walljumpBoots", address + 0x03, 0x04)
        updateToggleItemFromByteAndFlag(segment, "bomb", address + 0x03, 0x10)
        updateToggleItemFromByteAndFlag(segment, "speed", address + 0x03, 0x20)
        updateToggleItemFromByteAndFlag(segment, "grapple", address + 0x03, 0x40)
        updateToggleItemFromByteAndFlag(segment, "xray", address + 0x03, 0x80)

        updateToggleItemFromByteAndFlag(segment, "wave", address + 0x06, 0x01)
        updateToggleItemFromByteAndFlag(segment, "ice", address + 0x06, 0x02)
        updateToggleItemFromByteAndFlag(segment, "spazer", address + 0x06, 0x04)
        updateToggleItemFromByteAndFlag(segment, "plasma", address + 0x06, 0x08)
        --updateToggleItemFromByteAndFlag(segment, "charge", 0x7e09a2 + 0x07, 0x10)
        updateToggleItemFromByteAndFlag(segment, "charge", address + 0x07, 0x10)
        
    end
    return true
end

function updateToggles(segment)
    if not isInGame() then
        return false
    end
    if AUTOTRACKER_ENABLE_ITEM_TRACKING then
        InvalidateReadCaches()
        local address = 0xDFFF05

        updateToggleItemFromByteAndFlag(segment, "toggleWalljumpBoots", address, 0x01)
        updateToggleItemFromByteAndFlag(segment, "canWalljump", address, 0x02)

    end
    return true
end


function updateAmmo(segment)
    if not isInGame() then
        return false
    end
    if AUTOTRACKER_ENABLE_ITEM_TRACKING then
        InvalidateReadCaches()
        local address = 0x7e09c2

        updateAmmoFrom2Bytes(segment, "etank", address + 0x02)
        updateAmmoFrom2Bytes(segment, "missile", address + 0x06)
        updateAmmoFrom2Bytes(segment, "super", address + 0x0a)
        updateAmmoFrom2Bytes(segment, "pb", address + 0x0e)
        updateAmmoFrom2Bytes(segment, "reservetank", address + 0x12)
        
    end
    return true
end

function updateBosses(segment)
    if not isInGame() then
        return false
    end
    if AUTOTRACKER_ENABLE_ITEM_TRACKING then
        InvalidateReadCaches()

        -- Bosses
        updateToggleItemFromByteAndFlag(segment, "kraid", 0x7ed829, 0x01)
        updateToggleItemFromByteAndFlag(segment, "phantoon", 0x7ed82b, 0x01)
        updateToggleItemFromByteAndFlag(segment, "draygon", 0x7ed82c, 0x01)
        updateToggleItemFromByteAndFlag(segment, "ridley", 0x7ed82a, 0x01)

        -- Minibosses
        updateToggleItemFromByteAndFlag(segment, "sporespawn", 0x7ed829, 0x02)
        updateToggleItemFromByteAndFlag(segment, "crocomire", 0x7ed82a, 0x02)
        updateToggleItemFromByteAndFlag(segment, "botwoon", 0x7ed82c, 0x02)
        updateToggleItemFromByteAndFlag(segment, "goldentorizo", 0x7ed82a, 0x04)

        -- Metroids
        updateToggleItemFromByteAndFlag(segment, "metroids1", 0x7ed822, 0x01)
        updateToggleItemFromByteAndFlag(segment, "metroids2", 0x7ed822, 0x02)
        updateToggleItemFromByteAndFlag(segment, "metroids3", 0x7ed822, 0x04)
        updateToggleItemFromByteAndFlag(segment, "metroids4", 0x7ed822, 0x08)

        -- Chozos
        updateToggleItemFromByteAndFlag(segment, "bombtorizo", 0x7ed828, 0x04)
        updateToggleItemFromByteAndFlag(segment, "bowlingchozo", 0x7ed823, 0x01)
        updateToggleItemFromByteAndFlag(segment, "acidchozo", 0x7ed821, 0x10)
        updateToggleItemFromByteAndFlag(segment, "goldentorizo", 0x7ed82a, 0x04)

        -- Pirates
        updateToggleItemFromByteAndFlag(segment, "pitpirates", 0x7ed823, 0x02)
        updateToggleItemFromByteAndFlag(segment, "babykraidpirates", 0x7ed823, 0x04)
        updateToggleItemFromByteAndFlag(segment, "plasmapirates", 0x7ed823, 0x08)
        updateToggleItemFromByteAndFlag(segment, "metalpirates", 0x7ed823, 0x10)

        -- Zebes awake
        updateToggleItemFromByteAndFlag(segment, "eye", 0x7ed820, 0x01)
    end
    return true
end

function updateRooms(segment)
    if not isInGame() then
        return false
    end
    if AUTOTRACKER_ENABLE_LOCATION_TRACKING then
        InvalidateReadCaches()
        local address = 0x7ed870

        updateSectionChestCountFromByteAndFlag(segment, "@Power Bomb (Crateria surface)/Minor Item", address + 0x0, 0x01)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (outside Wrecked Ship bottom)/Minor Item", address + 0x0, 0x02)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (outside Wrecked Ship top)/Minor Item", address + 0x0, 0x04)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (outside Wrecked Ship middle)/Minor Item", address + 0x0, 0x08)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (Crateria moat)/Minor Item", address + 0x0, 0x10)
        updateSectionChestCountFromByteAndFlag(segment, "@Energy Tank, Gauntlet/Major Item", address + 0x0, 0x20)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (Crateria bottom)/Minor Item", address + 0x0, 0x40)
        updateSectionChestCountFromByteAndFlag(segment, "@Bomb Torizo/Major Item", address + 0x0, 0x80)

        updateSectionChestCountFromByteAndFlag(segment, "@Energy Tank, Terminator/Major Item", address + 0x1, 0x01)
        updateSectionChestCountFromByteAndFlag(segment, "@After Gauntlet/Minor Item (right)", address + 0x1, 0x02)
        updateSectionChestCountFromByteAndFlag(segment, "@After Gauntlet/Minor Item (left)", address + 0x1, 0x04)
        updateSectionChestCountFromByteAndFlag(segment, "@Super Missile (Crateria)/Minor Item", address + 0x1, 0x08)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (Crateria middle)/Minor Item", address + 0x1, 0x10)
        updateSectionChestCountFromByteAndFlag(segment, "@Power Bomb (green Brinstar bottom)/Minor Item", address + 0x1, 0x20)
        updateSectionChestCountFromByteAndFlag(segment, "@Super Missile (pink Brinstar)/Minor Item", address + 0x1, 0x40)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (green Brinstar below super missile)/Minor Item", address + 0x1, 0x80)

        updateSectionChestCountFromByteAndFlag(segment, "@Super Missile (green Brinstar top)/Minor Item", address + 0x2, 0x01)
        updateSectionChestCountFromByteAndFlag(segment, "@Reserve Tank, Brinstar/Major Item", address + 0x2, 0x02)
        updateSectionChestCountFromByteAndFlag(segment, "@Behind Brinstar Reserve/Minor Item (back)", address + 0x2, 0x04)
        updateSectionChestCountFromByteAndFlag(segment, "@Behind Brinstar Reserve/Minor Item (front)", address + 0x2, 0x08)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (pink Brinstar top)/Minor Item", address + 0x2, 0x20)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (pink Brinstar bottom)/Minor Item", address + 0x2, 0x40)
        updateSectionChestCountFromByteAndFlag(segment, "@Charge Beam/Major Item", address + 0x2, 0x80)

        updateSectionChestCountFromByteAndFlag(segment, "@Power Bomb (pink Brinstar)/Minor Item", address + 0x3, 0x01)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (green Brinstar pipe)/Minor Item", address + 0x3, 0x02)
        updateSectionChestCountFromByteAndFlag(segment, "@Morphing Ball/Major Item", address + 0x3, 0x04)
        updateSectionChestCountFromByteAndFlag(segment, "@Power Bomb (blue Brinstar)/Minor Item", address + 0x3, 0x08)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (blue Brinstar middle)/Minor Item", address + 0x3, 0x10)
        updateSectionChestCountFromByteAndFlag(segment, "@Energy Tank, Brinstar Ceiling/Major Item", address + 0x3, 0x20)
        updateSectionChestCountFromByteAndFlag(segment, "@Energy Tank, Etecoons/Major Item", address + 0x3, 0x40)
        updateSectionChestCountFromByteAndFlag(segment, "@Super Missile (green Brinstar bottom)/Minor Item", address + 0x3, 0x80)

        updateSectionChestCountFromByteAndFlag(segment, "@Energy Tank, Waterway/Major Item", address + 0x4, 0x02)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (blue Brinstar bottom)/Minor Item", address + 0x4, 0x04)
        updateSectionChestCountFromByteAndFlag(segment, "@Energy Tank, Brinstar Gate/Major Item", address + 0x4, 0x08)
        updateSectionChestCountFromByteAndFlag(segment, "@Missiles (blue Brinstar top)/Minor Item (front)", address + 0x4, 0x10)
        updateSectionChestCountFromByteAndFlag(segment, "@Missiles (blue Brinstar top)/Minor Item (back)", address + 0x4, 0x20)
        updateSectionChestCountFromByteAndFlag(segment, "@X-Ray Scope/Major Item", address + 0x4, 0x40)
        updateSectionChestCountFromByteAndFlag(segment, "@Power Bomb (red Brinstar sidehopper room)/Minor Item", address + 0x4, 0x80)

        updateSectionChestCountFromByteAndFlag(segment, "@Power Bomb (red Brinstar spike room)/Minor Item", address + 0x5, 0x01)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (red Brinstar spike room)/Minor Item", address + 0x5, 0x02)
        updateSectionChestCountFromByteAndFlag(segment, "@Spazer/Major Item", address + 0x5, 0x04)
        updateSectionChestCountFromByteAndFlag(segment, "@Energy Tank, Kraid/Major Item", address + 0x5, 0x08)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (Kraid)/Minor Item", address + 0x5, 0x10)

        updateSectionChestCountFromByteAndFlag(segment, "@Varia Suit/Major Item", address + 0x6, 0x01)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (lava room)/Minor Item", address + 0x6, 0x02)
        updateSectionChestCountFromByteAndFlag(segment, "@Ice Beam/Major Item", address + 0x6, 0x04)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (below Ice Beam)/Minor Item", address + 0x6, 0x08)
        updateSectionChestCountFromByteAndFlag(segment, "@Energy Tank, Crocomire/Major Item", address + 0x6, 0x10)
        updateSectionChestCountFromByteAndFlag(segment, "@Hi-Jump Boots/Major Item", address + 0x6, 0x20)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (above Crocomire)/Minor Item", address + 0x6, 0x40)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (Hi-Jump Boots)/Minor Item", address + 0x6, 0x80)

        updateSectionChestCountFromByteAndFlag(segment, "@Energy Tank (Hi-Jump Boots)/Minor Item", address + 0x7, 0x01)
        updateSectionChestCountFromByteAndFlag(segment, "@Power Bomb (Crocomire)/Minor Item", address + 0x7, 0x02)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (below Crocomire)/Minor Item", address + 0x7, 0x04)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (Grapple Beam)/Minor Item", address + 0x7, 0x08)
        updateSectionChestCountFromByteAndFlag(segment, "@Grapple Beam/Major Item", address + 0x7, 0x10)
        updateSectionChestCountFromByteAndFlag(segment, "@Reserve Tank, Norfair/Major Item", address + 0x7, 0x20)
        updateSectionChestCountFromByteAndFlag(segment, "@Reserve Tank, Norfair/Minor Item", address + 0x7, 0x40)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (bubble Norfair green door)/Minor Item", address + 0x7, 0x80)

        updateSectionChestCountFromByteAndFlag(segment, "@Missile (bubble Norfair)/Minor Item", address + 0x8, 0x01)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (Speed Booster)/Minor Item", address + 0x8, 0x02)
        updateSectionChestCountFromByteAndFlag(segment, "@Speed Booster/Major Item", address + 0x8, 0x04)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (Wave Beam)/Minor Item", address + 0x8, 0x08)
        updateSectionChestCountFromByteAndFlag(segment, "@Wave Beam/Major Item", address + 0x8, 0x10)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (Gold Torizo)/Minor Item", address + 0x8, 0x40)
        updateSectionChestCountFromByteAndFlag(segment, "@Super Missile (Gold Torizo)/Minor Item", address + 0x8, 0x80)

        updateSectionChestCountFromByteAndFlag(segment, "@Missile (Mickey Mouse room)/Minor Item", address + 0x9, 0x02)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (lower Norfair above fire flea room)/Minor Item", address + 0x9, 0x04)
        updateSectionChestCountFromByteAndFlag(segment, "@Power Bomb (lower Norfair above fire flea room)/Minor Item", address + 0x9, 0x08)
        updateSectionChestCountFromByteAndFlag(segment, "@Power Bomb (Power Bombs of shame)/Minor Item", address + 0x9, 0x10)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (lower Norfair near Wave Beam)/Minor Item", address + 0x9, 0x20)
        updateSectionChestCountFromByteAndFlag(segment, "@Energy Tank, Ridley/Major Item", address + 0x9, 0x40)
        updateSectionChestCountFromByteAndFlag(segment, "@Screw Attack/Major Item", address + 0x9, 0x80)

        updateSectionChestCountFromByteAndFlag(segment, "@Energy Tank, Firefleas/Major Item", address + 0xa, 0x01)

        updateSectionChestCountFromByteAndFlag(segment, "@Missile (Wrecked Ship middle)/Minor Item", address + 0x10, 0x01)
        updateSectionChestCountFromByteAndFlag(segment, "@Reserve Tank, Wrecked Ship/Major Item", address + 0x10, 0x02)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (Gravity Suit)/Minor Item", address + 0x10, 0x04)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (Wrecked Ship top)/Minor Item", address + 0x10, 0x08)
        updateSectionChestCountFromByteAndFlag(segment, "@Energy Tank, Wrecked Ship/Major Item", address + 0x10, 0x10)
        updateSectionChestCountFromByteAndFlag(segment, "@Super Missile (Wrecked Ship left)/Minor Item", address + 0x10, 0x20)
        updateSectionChestCountFromByteAndFlag(segment, "@Right Super, Wrecked Ship/Major Item", address + 0x10, 0x40)
        updateSectionChestCountFromByteAndFlag(segment, "@Gravity Suit/Major Item", address + 0x10, 0x80)

        updateSectionChestCountFromByteAndFlag(segment, "@Missile (green Maridia shinespark)/Minor Item", address + 0x11, 0x01)
        updateSectionChestCountFromByteAndFlag(segment, "@Super Missile (green Maridia)/Minor Item", address + 0x11, 0x02)
        updateSectionChestCountFromByteAndFlag(segment, "@Energy Tank, Mama turtle/Major Item", address + 0x11, 0x04)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (green Maridia tatori)/Minor Item", address + 0x11, 0x08)
        updateSectionChestCountFromByteAndFlag(segment, "@Watering Hole/Minor Item (left)", address + 0x11, 0x10)
        updateSectionChestCountFromByteAndFlag(segment, "@Watering Hole/Minor Item (right)", address + 0x11, 0x20)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (yellow Maridia false wall)/Minor Item", address + 0x11, 0x40)
        updateSectionChestCountFromByteAndFlag(segment, "@Plasma Beam/Major Item", address + 0x11, 0x80)

        updateSectionChestCountFromByteAndFlag(segment, "@West Sand Hole/Minor Item", address + 0x12, 0x01)
        updateSectionChestCountFromByteAndFlag(segment, "@West Sand Hole/Major Item", address + 0x12, 0x02)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (right Maridia sand pit room)/Minor Item", address + 0x12, 0x04)
        updateSectionChestCountFromByteAndFlag(segment, "@Power Bomb (right Maridia sand pit room)/Minor Item", address + 0x12, 0x08)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (pink Maridia)/Minor Item", address + 0x12, 0x10)
        updateSectionChestCountFromByteAndFlag(segment, "@Super Missile (pink Maridia)/Minor Item", address + 0x12, 0x20)
        updateSectionChestCountFromByteAndFlag(segment, "@Spring Ball/Major Item", address + 0x12, 0x40)
        updateSectionChestCountFromByteAndFlag(segment, "@Missile (Draygon)/Minor Item", address + 0x12, 0x80)

        updateSectionChestCountFromByteAndFlag(segment, "@Energy Tank, Botwoon/Major Item", address + 0x13, 0x01)
        updateSectionChestCountFromByteAndFlag(segment, "@Space Jump/Major Item", address + 0x13, 0x04)
    end
    return true
end


-- *************************** Setup memory watches
ScriptHost:AddMemoryWatch("SM ROM Data", 0xDFFF05, 0x01, updateToggles)
ScriptHost:AddMemoryWatch("SM Item Data", 0x7e09a0, 0x70, updateItems)
ScriptHost:AddMemoryWatch("SM Ammo Data", 0x7e09c2, 0x16, updateAmmo)
ScriptHost:AddMemoryWatch("SM Boss Data", 0x7ed820, 0x10, updateBosses)
ScriptHost:AddMemoryWatch("SM Room Data", 0x7ed870, 0x20, updateRooms)
