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

local checksum=0x0000 -- gamechecksum lives here, we can use it to detect if the game changed.

function checkHeader()
    InvalidateReadCaches()
    local address = 0x80FFCD
    local header = AutoTracker:ReadU8(address, 0)

    if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        -- Print whether MapRando is detected and the header value in hex
        local status = (header == 0x4D) and "Detected Maprando!" or "Not Maprando!"
        print(string.format("*** %s Header: 0x%02X", status, header))
    end

    return header == 0x4D
end

function gamechecksum(segment)
    InvalidateReadCaches()
    local chksum = AutoTracker:ReadU16(0x80FFDE, 0)
    if chksum ~= checksum then
        checksum = chksum
        print "New game detected"
        updateToggles(segment)
    end
    updateSpecialToggles(segment)
end

function updateToggles(segment)
    InvalidateReadCaches() 
    if checkHeader() then
        -- If header is MapRando, run WJB/SplitSpeed
            --updateSpecialToggles(segment)
            updateProgressiveFromByte("difficulty",      0xDFFF09)
            updateProgressiveFromByte("itemprogression", 0xDFFF0A)
            updateProgressiveFromByte("QualityOfLife",   0xDFFF0B)
            updateProgressiveFromByte("objectives",      0xDFFF0C)
            updateProgressiveFromByte("maplayout",       0xDFFF0D)
    else
        -- If header is NOT MapRando turn them off (incase they were on from a previous split speed seed etc)
        if toggleWalljumpBoots then
          toggleWalljumpBoots:setActive(false)
        end
        if toggleSpeedBoosterSplit then
          toggleSpeedBoosterSplit:setActive(false)
        end
    end

    return true
end

function updateSpecialToggles(segment)
    local specialbitflag = AutoTracker:ReadU8(0xDFFF05, 0)
    -- some of these are not toggleable on the full tracker layout for some reason..?
    
    if toggleWalljumpBoots then
      toggleWalljumpBoots:setActive((specialbitflag & 0x01) ~= 0)
    end
    
    if toggleSpeedBoosterSplit then
        toggleSpeedBoosterSplit:setActive((specialbitflag & 0x02) ~= 0)
    end
end

function updateProgressiveFromByte(code, address)
    local obj = Tracker:FindObjectForCode(code)

    if not obj then
        return
    end

    local value = AutoTracker:ReadU8(address, 0)
    if value == 0x00 then --custom
        local lastStageIndex = obj.Stages.Count - 1  
        obj.CurrentStage = lastStageIndex
        return
    end

    if value == 0xFF then --not set
        return
    end

    obj.CurrentStage = value - 1

    if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print(string.format(
            "*** %s value=0x%02X stage=%d",
            code,
            value,
            obj.CurrentStage
        ))
    end
end

function updateAmmoFrom2Bytes(segment, code, address)
	
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
    local item = Tracker:FindObjectForCode(code)
    
    if not item then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
            print("***ERROR*** Couldn't find item:", code)
        end
        return
    end

    local value = ReadU8(segment, address)
    local active = (value & flag) ~= 0

    if AUTOTRACKER_ENABLE_DEBUG_LOGGING then
        print(
            "Item:",
            item.Name,
            string.format("0x%x", address),
            string.format("0x%x", value),
            string.format("0x%x", flag),
            active
        )
    end

    --------------------------------------------------
    -- Split Speed
    --------------------------------------------------

   if code == "switchSpeed" then
        switchSpeed:setActive(active)
        return
   end

    --------------------------------------------------
    -- Boss / objective stage items
    --------------------------------------------------

    local stageItems = {
        ridley = true,
        draygon = true,
        phantoon = true,
        kraid = true,
        bombtorizo = true,
        sporespawn = true,
        crocomire = true,
        botwoon = true,
        goldentorizo = true,
        metroids1 = true,
        metroids2 = true,
        metroids3 = true,
        metroids4 = true,
        bowlingchozo = true,
        acidchozo = true,
        pitpirates = true,
        babykraidpirates = true,
        plasmapirates = true,
        metalpirates = true,
        eye = true
    }

    if stageItems[code] then
        item.CurrentStage = active and 1 or 0
        return
    end

    --------------------------------------------------
    -- Inverse full tracker items
    --------------------------------------------------

    local inverseItems = {
        ridleyfull = true,
        draygonfull = true,
        phantoonfull = true,
        kraidfull = true,
        bombtorizofull = true,
        sporespawnfull = true,
        crocomirefull = true,
        botwoonfull = true,
        goldentorizofull = true,
        metroids1full = true,
        metroids2full = true,
        metroids3full = true,
        metroids4full = true,
        bowlingchozofull = true,
        acidchozofull = true,
        pitpiratesfull = true,
        babykraidpiratesfull = true,
        plasmapiratesfull = true,
        metalpiratesfull = true
    }

    if inverseItems[code] then
        item.Active = not active
        return
    end

    --------------------------------------------------
    -- Ignore ammo items
    --------------------------------------------------

    local ammoItems = {
        etank = true,
        missile = true,
        super = true,
        pb = true,
        reservetank = true
    }

    if ammoItems[code] then
        return
    end

    --------------------------------------------------
    -- Default toggle items
    --------------------------------------------------

    item.Active = active
end


-- ************************* Main functions

function updateItems(segment)
    if not isInGame() then
        return false
    end
    if AUTOTRACKER_ENABLE_ITEM_TRACKING then
        InvalidateReadCaches()
        local address = 0x7e09a2
        
        -- Suits --
        updateToggleItemFromByteAndFlag(segment, "varia", address + 0x02, 0x01)
        updateToggleItemFromByteAndFlag(segment, "gravity", address + 0x02, 0x20)
        
        -- Misc --
        updateToggleItemFromByteAndFlag(segment, "morph", address + 0x02, 0x04)
        updateToggleItemFromByteAndFlag(segment, "bomb", address + 0x03, 0x10)
        updateToggleItemFromByteAndFlag(segment, "spring", address + 0x02, 0x02)
        updateToggleItemFromByteAndFlag(segment, "screw", address + 0x02, 0x08)
        
        -- Boots --
        updateToggleItemFromByteAndFlag(segment, "hijump", address + 0x03, 0x01)
        updateToggleItemFromByteAndFlag(segment, "space", address + 0x03, 0x02)
        if switchSpeed.defaultIcon then
            updateToggleItemFromByteAndFlag(segment, "switchSpeed", address + 0x03, 0x20)
        else
            updateToggleItemFromByteAndFlag(segment, "switchSpeed", address + 0x02, 0x40)
        end
        updateToggleItemFromByteAndFlag(segment, "spark", address + 0x02, 0x80)
        updateToggleItemFromByteAndFlag(segment, "walljumpBoots", address + 0x03, 0x04)
        
        -- Beams --
        updateToggleItemFromByteAndFlag(segment, "charge", address + 0x07, 0x10)
        updateToggleItemFromByteAndFlag(segment, "ice", address + 0x06, 0x02)
        updateToggleItemFromByteAndFlag(segment, "wave", address + 0x06, 0x01)
        updateToggleItemFromByteAndFlag(segment, "spazer", address + 0x06, 0x04)
        updateToggleItemFromByteAndFlag(segment, "plasma", address + 0x06, 0x08)
        
        -- HUD  -- 
        updateToggleItemFromByteAndFlag(segment, "grapple", address + 0x03, 0x40)
        updateToggleItemFromByteAndFlag(segment, "xray", address + 0x03, 0x80)

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

        -- Fulltracker
        updateToggleItemFromByteAndFlag(segment, "kraidfull", 0x7ed829, 0x01)
        updateToggleItemFromByteAndFlag(segment, "phantoonfull", 0x7ed82b, 0x01)
        updateToggleItemFromByteAndFlag(segment, "draygonfull", 0x7ed82c, 0x01)
        updateToggleItemFromByteAndFlag(segment, "ridleyfull", 0x7ed82a, 0x01)
        updateToggleItemFromByteAndFlag(segment, "sporespawnfull", 0x7ed829, 0x02)
        updateToggleItemFromByteAndFlag(segment, "crocomirefull", 0x7ed82a, 0x02)
        updateToggleItemFromByteAndFlag(segment, "botwoonfull", 0x7ed82c, 0x02)
        updateToggleItemFromByteAndFlag(segment, "goldentorizofull", 0x7ed82a, 0x04)
        updateToggleItemFromByteAndFlag(segment, "metroids1full", 0x7ed822, 0x01)
        updateToggleItemFromByteAndFlag(segment, "metroids2full", 0x7ed822, 0x02)
        updateToggleItemFromByteAndFlag(segment, "metroids3full", 0x7ed822, 0x04)
        updateToggleItemFromByteAndFlag(segment, "metroids4full", 0x7ed822, 0x08)
        updateToggleItemFromByteAndFlag(segment, "bombtorizofull", 0x7ed828, 0x04)
        updateToggleItemFromByteAndFlag(segment, "bowlingchozofull", 0x7ed823, 0x01)
        updateToggleItemFromByteAndFlag(segment, "acidchozofull", 0x7ed821, 0x10)
        updateToggleItemFromByteAndFlag(segment, "pitpiratesfull", 0x7ed823, 0x02)
        updateToggleItemFromByteAndFlag(segment, "babykraidpiratesfull", 0x7ed823, 0x04)
        updateToggleItemFromByteAndFlag(segment, "plasmapiratesfull", 0x7ed823, 0x08)
        updateToggleItemFromByteAndFlag(segment, "metalpiratesfull", 0x7ed823, 0x10)

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

-- *************************** Setup memory watches
ScriptHost:AddMemoryWatch("SM ROM Data",  0x80FFDE, 0x02, gamechecksum)
ScriptHost:AddMemoryWatch("SM Item Data", 0x7e09a0, 0x70, updateItems)
ScriptHost:AddMemoryWatch("SM Ammo Data", 0x7e09c2, 0x16, updateAmmo)
ScriptHost:AddMemoryWatch("SM Boss Data", 0x7ed820, 0x10, updateBosses)
