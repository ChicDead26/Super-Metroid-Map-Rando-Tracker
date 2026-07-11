ToggleOneSwitchOther = CustomItem:extend()

function ToggleOneSwitchOther:init(name, code, imagePath, imagePathDisabled, codeObjectToSwitch, codeObjectToDisable, imagePathObjectToSwitch, imagePathObjectToSwitchBack, imagePathObjectToDisable, defaultState, itemType)
    self:createItem(name)
    self.code = code
    self.objectToSwitch = Tracker:FindObjectForCode(codeObjectToSwitch)
    self.objectToDisable = Tracker:FindObjectForCode(codeObjectToDisable)
    self:setProperty("active", defaultState)
    self.activeImage = ImageReference:FromPackRelativePath(imagePath)
    self.disabledImage = ImageReference:FromPackRelativePath(imagePathDisabled)
    self.ItemInstance.PotentialIcon = self.activeImage

    self.otherSwitchedImage = ImageReference:FromPackRelativePath(imagePathObjectToSwitch, "@disabled")
    self.anotherSwitchedImage = ImageReference:FromPackRelativePath(imagePathObjectToSwitchBack, "@disabled")
    self.otherDisabledImage = ImageReference:FromPackRelativePath(imagePathObjectToDisable, "@disabled")

    self.itemType = itemType
    print(self.codeObjectToDisable)
    self.ItemInstance.Icon = self.activeImage
    self:updateIcon()
end

function ToggleOneSwitchOther:setActive(active)
    self:setProperty("active", active)
end

function ToggleOneSwitchOther:getActive()
    return self:getProperty("active")
end

function ToggleOneSwitchOther:updateIcon()
    print(self:getActive(), "is active")
    if self:getActive() then
        self.ItemInstance.Icon = self.activeImage

        switchSpeed:setProperty("defaultIcon", false)

        self.objectToDisable.Active = false
        self.objectToDisable.Icon = self.otherDisabledImage

        self.objectToDisable.IgnoreUserInput = false
    else
        print(switchSpeed ~= nil, "a2 now")
        switchSpeed:setProperty("defaultIcon", true)

        self.ItemInstance.Icon = self.disabledImage
            self.objectToDisable.Icon = nil

        self.objectToDisable.IgnoreUserInput = true
    end
end

function ToggleOneSwitchOther:onLeftClick()
    self:setActive(not self:getActive())
end

function ToggleOneSwitchOther:onRightClick()
    self:setActive(not self:getActive())
end

function ToggleOneSwitchOther:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function ToggleOneSwitchOther:providesCode(code)
    if code == self.code and self.getActive() then
        return 1
    end
    return 0
end

function ToggleOneSwitchOther:advanceToCode(code)
    if code == nil or code == self.code then
        self:setActive(true)
    end
end

function ToggleOneSwitchOther:save()
    print(self:getActive())

    local data = {}
    data["active"] = self:getActive()
    data["defaultIcon"] = switchSpeed.defaultIcon
    data["activeSwitch"] = switchSpeed:getActive()
    data["objectToDisable"] = self.objectToDisable.Active
    return data
end

function ToggleOneSwitchOther:load(data)
    if data["active"] ~= nil then
        self:setActive(data["active"])
        self:updateIcon()
        self.objectToDisable.Active = data["objectToDisable"]
        defaultIcon = data["defaultIcon"]
        switchSpeed:setActive(data["activeSwitch"])
        print(switchSpeed.defaultIcon)
        print("dafa")
        switchSpeed:updateIcon()
    end
    return true
end

function ToggleOneSwitchOther:propertyChanged(key, value)
    self:updateIcon()
end