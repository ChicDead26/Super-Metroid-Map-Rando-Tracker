WalljumpBoots = CustomItem:extend()

function WalljumpBoots:init(name, code, imagePath)
    self:createItem(name)
    self.code = code
    self:setProperty("active", false)
    self.activeImage = ImageReference:FromPackRelativePath(imagePath)
    self.disabledImage = ImageReference:FromImageReference(self.activeImage, "@disabled")
    self.ItemInstance.PotentialIcon = self.activeImage

    self:updateIcon()    
end

function WalljumpBoots:setActive(active)
    self:setProperty("active", active)
end

function WalljumpBoots:getActive()
    return self:getProperty("active")
end

function WalljumpBoots:updateIcon()
    if self:getActive() then
        self.ItemInstance.Icon = self.activeImage
    else
        self.ItemInstance.Icon = self.disabledImage
    end
end

function WalljumpBoots:onLeftClick()
    self:setActive(not self:getActive())
end

function WalljumpBoots:onRightClick()
    self:setActive(not self:getActive())
end

function WalljumpBoots:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function WalljumpBoots:providesCode(code)
    if code == self.code and self.getActive() then
        return 1
    end
    return 0
end

function WalljumpBoots:advanceToCode(code)
    if code == nil or code == self.code then
        self:setActive(true)
    end
end

function WalljumpBoots:save()
    local saveData = {}
    saveData["active"] = self.getActive()
    return saveData
end

function WalljumpBoots:Load(data)
    if data["active"] ~= nil then
        self:setActive(data["active"])
    end
    return true
end

function WalljumpBoots:propertyChanged(key, value)
    self:updateIcon()
end