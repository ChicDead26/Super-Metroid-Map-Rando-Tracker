OptionalWalljumpBoots = CustomItem:extend()
state = true

changePhantoon = { }

function OptionalWalljumpBoots:init(name, code, imagePath)
    self:createItem(name)
    self.code = code
    self:setProperty("active", false)
    self.activeImage = ImageReference:FromPackRelativePath(imagePath)
    self.disabledImage = ImageReference:FromImageReference(self.activeImage, "@disabled")
    self.ItemInstance.PotentialIcon = self.activeImage

    self:updateIcon()    
end

function changePhantoon.ChangeVisiblity(currentState)--man, i shouldve written some comments six months ago. what does this do? nothing? was it just an attempt at whats currently in updateIcon?
    state = currentState
    self:updateIcon()
end

function OptionalWalljumpBoots:setActive(active)
    self:setProperty("active", active)
end

function OptionalWalljumpBoots:getActive()
    return self:getProperty("active")
end

function OptionalWalljumpBoots:updateIcon()
    if state == false then
    self.ItemInstance.Icon = nil
    elseif self:getActive() then
        self.ItemInstance.Icon = self.disabledImage
    else
        self.ItemInstance.Icon = self.activeImage
    end
    --self.ItemInstance.Icon = self.activeImage
end

function OptionalWalljumpBoots:onLeftClick()
    self:setActive(true)
end

function OptionalWalljumpBoots:onRightClick()
    self:setActive(false)
end

function OptionalWalljumpBoots:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function OptionalWalljumpBoots:providesCode(code)
    if code == self.code and self.getActive() then
        return 1
    end
    return 0
end

function OptionalWalljumpBoots:advanceToCode(code)
    if code == nil or code == self.code then
        self:setActive(true)
    end
end

function OptionalWalljumpBoots:save()
    local saveData = {}
    saveData["active"] = self.getActive()
    return saveData
end

function OptionalWalljumpBoots:Load(data)
    if data["active"] ~= nil then
        self:setActive(data["active"])
    end
    return true
end

function OptionalWalljumpBoots:propertyChanged(key, value)
    self:updateIcon()
end