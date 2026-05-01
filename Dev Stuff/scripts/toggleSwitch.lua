ToggleSwitch = CustomItem:extend()

--local myImagePathObjectToDisable = ""
--local myCodeObjectToDisable = ""
--thingsToHide = {"eye", "phantoon", "walljumpBoots", "canWalljump"}
--objectToDisableImage = "images/walljumpboots.png"
--function ToggleProgressive:init(name, code, imagePath)



function ToggleSwitch:init(name, code, imagePathA, imagePathB, defaultState, itemType)
    self:createItem(name)
    self.code = code
    self:setProperty("active", defaultState)
    self.activeImage = ImageReference:FromPackRelativePath(imagePathA)
    --self.disabledImage = ImageReference:FromPackRelativePath(imagePathADisabled)
    self.ItemInstance.PotentialIcon = self.activeImage
    defaultIcon = true
    speedSwitch = self--Don't think about it, don't worry about it
    --myCodeObjectToDisable = codeObjectToDisable
    --myImagePathObjectToDisable = imagePathObjectToDisable
    --print("fuck")
    --self.codeObjectToDisable = codeObjectToDisable
    --self.imageDisabledA = ImageReference:FromPackRelativePath(imagePathDisabledA, "@disabled")

    self.imageA = ImageReference:FromPackRelativePath(imagePathA)
    self.imageADisabled = ImageReference:FromPackRelativePath(imagePathA, "@disabled")
    self.imageB = ImageReference:FromPackRelativePath(imagePathB)
    self.imageBDisabled = ImageReference:FromPackRelativePath(imagePathB, "@disabled")

    self.itemType = itemType
    --self.ItemInstance.Icon = self.disabledImage
    self.ItemInstance.Icon = self.activeImage
    self:updateIcon()    
end

function ToggleSwitch:setActive(active)
    self:setProperty("active", active)
end

function ToggleSwitch:getActive()
    return self:getProperty("active")
end

function ToggleSwitch:updateIcon()
    if self:getActive() then
        if defaultIcon then
            self.ItemInstance.Icon = self.imageA
        else
            self.ItemInstance.Icon = self.imageB
        end
    else
        if defaultIcon then
            self.ItemInstance.Icon = self.imageADisabled
        else
            self.ItemInstance.Icon = self.imageBDisabled
        end
    end
end

function ToggleSwitch:onLeftClick()
    self:setActive(not self:getActive())
end

function ToggleSwitch:onRightClick()
    self:setActive(not self:getActive())
end

function ToggleSwitch:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function ToggleSwitch:providesCode(code)
    if code == self.code and self.getActive() then
        return 1
    end
    return 0
end

function ToggleSwitch:advanceToCode(code)
    if code == nil or code == self.code then
        self:setActive(true)
    end
end

function ToggleSwitch:save()
    print(self:getActive())

    local saveData = {}
    saveData["active"] = self.getActive()
    return saveData
end

function ToggleSwitch:Load(data)
    if data["active"] ~= nil then
        self:setActive(data["active"])
    end
    print(self:getActive())
    self:updateIcon()
    return true
end

function ToggleSwitch:propertyChanged(key, value)
    self:updateIcon()
end