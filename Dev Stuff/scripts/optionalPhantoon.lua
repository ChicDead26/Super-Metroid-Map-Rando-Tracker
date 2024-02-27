OptionalPhantoon = CustomItem:extend()
state = true

changePhantoon = { }

function OptionalPhantoon:init(name, code, imagePath)
    self:createItem(name)
    self.code = code
    self:setProperty("active", false)
    self.activeImage = ImageReference:FromPackRelativePath(imagePath)
    self.disabledImage = ImageReference:FromImageReference(self.activeImage, "@disabled")
    self.ItemInstance.PotentialIcon = self.activeImage

    self:updateIcon()    
end

function changePhantoon.ChangeVisiblity(currentState)
    state = currentState
    self:updateIcon()
end

function OptionalPhantoon:setActive(active)
    self:setProperty("active", active)
end

function OptionalPhantoon:getActive()
    return self:getProperty("active")
end

function OptionalPhantoon:updateIcon()
    if state == false then
    self.ItemInstance.Icon = nil
    elseif self:getActive() then
        self.ItemInstance.Icon = self.disabledImage
    else
        self.ItemInstance.Icon = self.activeImage
    end
end

function OptionalPhantoon:onLeftClick()
    self:setActive(true)
end

function OptionalPhantoon:onRightClick()
    self:setActive(false)
end

function OptionalPhantoon:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function OptionalPhantoon:providesCode(code)
    if code == self.code and self.getActive() then
        return 1
    end
    return 0
end

function OptionalPhantoon:advanceToCode(code)
    if code == nil or code == self.code then
        self:setActive(true)
    end
end

function OptionalPhantoon:save()
    local saveData = {}
    saveData["active"] = self.getActive()
    return saveData
end

function OptionalPhantoon:Load(data)
    if data["active"] ~= nil then
        self:setActive(data["active"])
    end
    return true
end

function OptionalPhantoon:propertyChanged(key, value)
    self:updateIcon()
end