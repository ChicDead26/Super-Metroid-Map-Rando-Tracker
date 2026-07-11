ToggleToggle = CustomItem:extend()

function ToggleToggle:init(name, code, imagePath, imagePathDisabled, codeObjectToDisable, imagePathObjectToDisable, defaultState, itemType)
    self:createItem(name)
    self.code = code
    self.objectToDisable = Tracker:FindObjectForCode(codeObjectToDisable)
    self:setProperty("active", defaultState)
    self.activeImage = ImageReference:FromPackRelativePath(imagePath)
    self.disabledImage = ImageReference:FromPackRelativePath(imagePathDisabled)
    self.ItemInstance.PotentialIcon = self.activeImage

    self.otherDisabledImage = ImageReference:FromPackRelativePath(imagePathObjectToDisable)

    self.ItemInstance.Icon = self.activeImage
    self:updateIcon()    
end

function ToggleToggle:setActive(active)
    self:setProperty("active", active)
end

function ToggleToggle:getActive()
    return self:getProperty("active")
end

function ToggleToggle:updateIcon()
    if self:getActive() then
        self.ItemInstance.Icon = self.activeImage

        print(self.itemType)

        self.objectToDisable.CurrentStage = 0

        self.objectToDisable.Icon = self.otherDisabledImage
        self.objectToDisable.IgnoreUserInput = false
    else
        self.ItemInstance.Icon = self.disabledImage
    
        self.objectToDisable.Icon = nil
        self.objectToDisable.IgnoreUserInput = true
    end
end

function ToggleToggle:onLeftClick()
    self:setActive(not self:getActive())
end

function ToggleToggle:onRightClick()
    self:setActive(not self:getActive())
end

function ToggleToggle:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function ToggleToggle:providesCode(code)
    if code == self.code and self.getActive() then
        return 1
    end
    return 0
end

function ToggleToggle:advanceToCode(code)
    if code == nil or code == self.code then
        self:setActive(true)
    end
end

function ToggleToggle:save()
    print(self.objectToDisable.CurrentStage)

    local data = {}
    data["active"] = self:getActive()
    data["objectToDisable"] = self.objectToDisable.CurrentStage
    --data["objectToDisableA"]
    return data
end

function ToggleToggle:load(data)
    if data["active"] ~= nil then
        self:setActive(data["active"])
        --self:updateIcon()
        self.objectToDisable.CurrentStage = data["objectToDisable"]
        --objectToDisable:updateIcon()
    end
    return true
end

function ToggleToggle:propertyChanged(key, value)
    self:updateIcon()
end