ToggleProgressive2 = CustomItem:extend()

--local myImagePathObjectToDisable = ""
--local myCodeObjectToDisable = ""
thingsToHide = {"eye", "phantoon", "walljumpBoots"}
--testImage = "images/walljumpboots.png"
--function ToggleProgressive2:init(name, code, imagePath)

function ToggleProgressive2:init(name, code, imagePath, imagePathDisabled, codeObjectToDisable2, imagePathObjectToDisable)
    self:createItem(name)
    self.code = code
    self:setProperty("active", true)
    self.activeImage = ImageReference:FromPackRelativePath(imagePath)
    self.disabledImage = ImageReference:FromPackRelativePath(imagePathDisabled)
    self.ItemInstance.PotentialIcon = self.activeImage

    --myCodeObjectToDisable = codeObjectToDisable
    --myImagePathObjectToDisable = imagePathObjectToDisable

    self.codeObjectToDisable = codeObjectToDisable2
    self.otherDisabledImage = ImageReference:FromPackRelativePath(imagePathObjectToDisable)

    print(self.codeObjectToDisable)
    --self.ItemInstance.Icon = self.disabledImage
    self.ItemInstance.Icon = self.activeImage

    self:updateIcon()    
end

function ToggleProgressive2:setActive(active)
    self:setProperty("active", active)
end

function ToggleProgressive2:getActive()
    return self:getProperty("active")
end

function ToggleProgressive2:updateIcon()
    print(self.codeObjectToDisable)
    print(type(self.codeObjectToDisable))

    local item = Tracker:FindObjectForCode(thingsToHide[2])

    if self:getActive() then
        self.ItemInstance.Icon = self.activeImage
        item.CurrentStage = 2
        item.Icon = self.otherDisabledImage
        item.IgnoreUserInput = false
    else
        self.ItemInstance.Icon = self.disabledImage
    
        --item.CurrentStage = 1--Dont bring this one back
        item.Icon = nil
        item.IgnoreUserInput = true
    end
end

function ToggleProgressive2:onLeftClick()
    self:setActive(not self:getActive())
end

function ToggleProgressive2:onRightClick()
    self:setActive(not self:getActive())
end

function ToggleProgressive2:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function ToggleProgressive2:providesCode(code)
    if code == self.code and self.getActive() then
        return 1
    end
    return 0
end

function ToggleProgressive2:advanceToCode(code)
    if code == nil or code == self.code then
        self:setActive(true)
    end
end

function ToggleProgressive2:save()
    local saveData = {}
    saveData["active"] = self.getActive()
    return saveData
end

function ToggleProgressive2:Load(data)
    if data["active"] ~= nil then
        self:setActive(data["active"])
    end
    return true
end

function ToggleProgressive2:propertyChanged(key, value)
    self:updateIcon()
end