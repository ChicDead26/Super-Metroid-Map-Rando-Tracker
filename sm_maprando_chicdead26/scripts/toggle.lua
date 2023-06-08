ToggleItem = CustomItem:extend()

function ToggleItem:init(name, code, imagePath)
    self:createItem(name)
    self.code = code
    self:setProperty("active", false)
    self.activeImage = ImageReference:FromPackRelativePath(imagePath)
    self.disabledImage = ImageReference:FromImageReference(self.activeImage, "@disabled")
    self.ItemInstance.PotentialIcon = self.activeImage

    self:updateIcon()    
end

function ToggleItem:setActive(active)
    self:setProperty("active", active)
end

function ToggleItem:getActive()
    return self:getProperty("active")
end

function ToggleItem:updateIcon()
    if self:getActive() then
        self.ItemInstance.Icon = self.activeImage
    else
        self.ItemInstance.Icon = self.disabledImage
    end
end

function ToggleItem:onLeftClick()
    self:setActive(true)
end

function ToggleItem:onRightClick()
    self:setActive(false)
end

function ToggleItem:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function ToggleItem:providesCode(code)
    if code == self.code and self.getActive() then
        return 1
    end
    return 0
end

function ToggleItem:advanceToCode(code)
    if code == nil or code == self.code then
        self:setActive(true)
    end
end

function ToggleItem:save()
    local saveData = {}
    saveData["active"] = self.getActive()
    return saveData
end

function ToggleItem:Load(data)
    if data["active"] ~= nil then
        self:setActive(data["active"])
    end
    return true
end

function ToggleItem:propertyChanged(key, value)
    self:updateIcon()
end