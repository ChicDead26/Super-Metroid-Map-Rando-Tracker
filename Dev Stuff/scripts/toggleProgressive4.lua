ToggleProgressive4 = CustomItem:extend()

--local myImagePathObjectToDisable = ""
--local myCodeObjectToDisable = ""
thingsToHide = {"eye", "phantoon", "walljumpBoots", "canWalljump"}
--testImage = "images/walljumpboots.png"
--function ToggleProgressive4:init(name, code, imagePath)

function ToggleProgressive4:init(name, code, imagePath, imagePathDisabled, codeObjectToDisable2, imagePathObjectToDisable)
    self:createItem(name)
    self.code = code
    self:setProperty("active", false)
    self.activeImage = ImageReference:FromPackRelativePath(imagePath)
    self.disabledImage = ImageReference:FromPackRelativePath(imagePathDisabled)
    self.ItemInstance.PotentialIcon = self.activeImage

    --myCodeObjectToDisable = codeObjectToDisable
    --myImagePathObjectToDisable = imagePathObjectToDisable

    self.codeObjectToDisable = codeObjectToDisable2
    self.otherDisabledImage = ImageReference:FromPackRelativePath(imagePathObjectToDisable)

    print(self.codeObjectToDisable)
    self.ItemInstance.Icon = self.disabledImage

    --self:updateIcon()    
end

function ToggleProgressive4:setActive(active)
    self:setProperty("active", active)
end

function ToggleProgressive4:getActive()
    return self:getProperty("active")
end

function ToggleProgressive4:updateIcon()
    print(self.codeObjectToDisable)
    print(type(self.codeObjectToDisable))

    local item = Tracker:FindObjectForCode(thingsToHide[4])

    --print(item.Type)

    if self:getActive() then
        self.ItemInstance.Icon = self.activeImage
        item.CurrentStage = 2
        --item.Active = false
        item.Icon = self.otherDisabledImage
        item.IgnoreUserInput = false
    else
        self.ItemInstance.Icon = self.disabledImage
        
        --item.CurrentStage = 1--Dont bring this one back
        item.Icon = nil
        item.IgnoreUserInput = true
    end
end

function ToggleProgressive4:onLeftClick()
    self:setActive(not self:getActive())
end

function ToggleProgressive4:onRightClick()
    self:setActive(not self:getActive())
end

function ToggleProgressive4:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function ToggleProgressive4:providesCode(code)
    if code == self.code and self.getActive() then
        return 1
    end
    return 0
end

function ToggleProgressive4:advanceToCode(code)
    if code == nil or code == self.code then
        self:setActive(true)
    end
end

function ToggleProgressive4:save()
    local saveData = {}
    saveData["active"] = self.getActive()
    return saveData
end

function ToggleProgressive4:Load(data)
    if data["active"] ~= nil then
        self:setActive(data["active"])
    end
    return true
end

function ToggleProgressive4:propertyChanged(key, value)
    self:updateIcon()
end