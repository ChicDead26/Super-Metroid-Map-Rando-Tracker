ObjectiveSwitch = CustomItem:extend()
--x = 0

function ObjectiveSwitch:init(name, code, imagePath)--0, imagePath1, imagePath2)
    self:createItem(name)
    self.code = code
    self:setProperty("active", false)
    self.images = {imagePath0, imagePath1, imagePath2}
    self.activeImage = ImageReference:FromPackRelativePath(imagePath0)
    --self.activeImage1 = ImageReference:FromPackRelativePath(imagePath1)
    --self.activeImage2 = ImageReference:FromPackRelativePath(imagePath2)
    self.disabledImage = ImageReference:FromImageReference(self.activeImage, "@disabled")
    self.ItemInstance.PotentialIcon = self.activeImage

    self:updateIcon()    
end

function ObjectiveSwitch:setActive(active)
    self:setProperty("active", active)
end

function ObjectiveSwitch:getActive()
    return self:getProperty("active")
end

function ObjectiveSwitch:updateIcon()
    if self:getActive() then
        self.ItemInstance.Icon = self.activeImage
    else
        self.ItemInstance.Icon = self.disabledImage
    --self.ItemInstance.Icon = self.images[x]
    --if x == 0 then
    --  self.ItemInstance.Icon = self.activeImage
    --else if x == 1 then
    --  self.ItemInstance.Icon = self.activeImage1
    --else if x == 2 then
    --  self.ItemInstance.Icon = self.activeImage2
    end
end

function ObjectiveSwitch:onLeftClick()
    --self:setActive(true)
    x = x + 1

    if x == 3 then
        x = 0
end

function ObjectiveSwitch:onRightClick()
    --self:setActive(false)
    x = x - 1

    if x == -1 then
        x = 2
end

function ObjectiveSwitch:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function ObjectiveSwitch:providesCode(code)
    if code == self.code and self.getActive() then
        return 1
    end
    return 0
end

function ObjectiveSwitch:advanceToCode(code)
    if code == nil or code == self.code then
        self:setActive(true)
    end
end

function ObjectiveSwitch:save()
    local saveData = {}
    saveData["active"] = self.getActive()
    return saveData
end

function ObjectiveSwitch:Load(data)
    if data["active"] ~= nil then
        self:setActive(data["active"])
    end
    return true
end

function ObjectiveSwitch:propertyChanged(key, value)
    self:updateIcon()
end