ToggleProgressiveSwitcheroo = CustomItem:extend()

--local myImagePathObjectToDisable = ""
--local myCodeObjectToDisable = ""
--thingsToHide = {"eye", "phantoon", "walljumpBoots", "canWalljump"}
--objectToDisableImage = "images/walljumpboots.png"
--function ToggleProgressive:init(name, code, imagePath)



function ToggleProgressiveSwitcheroo:init(name, code, imagePath, imagePathDisabled, codeObjectToSwitch, codeObjectToDisable, imagePathObjectToSwitch, imagePathObjectToSwitchBack, imagePathObjectToDisable, defaultState, itemType)
    self:createItem(name)
    self.code = code
    self.objectToSwitch = Tracker:FindObjectForCode(codeObjectToSwitch)
    self.objectToDisable = Tracker:FindObjectForCode(codeObjectToDisable)
    self:setProperty("active", defaultState)
    self.activeImage = ImageReference:FromPackRelativePath(imagePath)
    self.disabledImage = ImageReference:FromPackRelativePath(imagePathDisabled)
    self.ItemInstance.PotentialIcon = self.activeImage

    --myCodeObjectToDisable = codeObjectToDisable
    --myImagePathObjectToDisable = imagePathObjectToDisable

    --self.codeObjectToDisable = codeObjectToDisable
    self.otherSwitchedImage = ImageReference:FromPackRelativePath(imagePathObjectToSwitch, "@disabled")
    self.anotherSwitchedImage = ImageReference:FromPackRelativePath(imagePathObjectToSwitchBack, "@disabled")
    self.otherDisabledImage = ImageReference:FromPackRelativePath(imagePathObjectToDisable, "@disabled")

    self.itemType = itemType
    print(self.codeObjectToDisable)
    --self.ItemInstance.Icon = self.disabledImage
    self.ItemInstance.Icon = self.activeImage
    self:updateIcon()    
end

function ToggleProgressiveSwitcheroo:setActive(active)
    self:setProperty("active", active)
end

function ToggleProgressiveSwitcheroo:getActive()
    return self:getProperty("active")
end

function ToggleProgressiveSwitcheroo:updateIcon()
    --print(self.codeObjectToDisable)
    --print(type(self.codeObjectToDisable))

    if self:getActive() then
        print(self.objectToDisable == nil)
        self.ItemInstance.Icon = self.activeImage
        --print(self.objectToDisable)
        --self.objectToDisable:setActive(false)

        print(self.itemType)
        --print(self.objectToDisable.Name)

        --if self.itemType == 1 then --Toggle
        --    print("print this?")
        --    --self.objectToDisable:setActive(false)
        --    self.objectToDisable.Active = false
        --elseif self.itemType == 2 then --Progressive
        --    print("print this too?")
        --    self.objectToDisable.CurrentStage = 2
        --else --Consumable
        ----not yet implemented
        --end
        switchSpeed.defaultIcon = false
        speedSwitch:updateIcon()

        --self.objectToSwitch.setv = false
        --Global.setVar("defaultIcon") = false
        --self.objectToSwitch.Active = false
        self.objectToDisable.Active = false

        --self.objectToSwitch.Icon = self.otherSwitchedImage
        self.objectToDisable.Icon = self.otherDisabledImage

        --self.objectToSwitch.enabledIcon = ImageReference:FromPackRelativePath(imagePathObjectToSwitch)
        --self.objectToSwitch.disabledImage = ImageReference:FromPackRelativePath(imagePathObjectToSwitch, "@disabled")
        --self.objectToSwitch = Tracker:FindObjectForCode("blue")

        self.objectToDisable.IgnoreUserInput = false
    else
        --self.objectToSwitch.defaultIcon = true
        switchSpeed.defaultIcon = true
        print(speedSwitch == nil, "a")
        switchSpeed:updateIcon()
        
        self.ItemInstance.Icon = self.disabledImage
    
        --item.CurrentStage = 1--Dont bring this one back
        --self.objectToSwitch.Icon = self.anotherSwitchedImage
        self.objectToDisable.Icon = nil

        self.objectToDisable.IgnoreUserInput = true
    end
end

function ToggleProgressiveSwitcheroo:onLeftClick()
    self:setActive(not self:getActive())
end

function ToggleProgressiveSwitcheroo:onRightClick()
    self:setActive(not self:getActive())
end

function ToggleProgressiveSwitcheroo:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function ToggleProgressiveSwitcheroo:providesCode(code)
    if code == self.code and self.getActive() then
        return 1
    end
    return 0
end

function ToggleProgressiveSwitcheroo:advanceToCode(code)
    if code == nil or code == self.code then
        self:setActive(true)
    end
end

function ToggleProgressiveSwitcheroo:save()
    print(self:getActive())

    local data = {}
    data["active"] = self:getActive()
    data["defaultIcon"] = switchSpeed.defaultIcon
    data["activeSwitch"] = switchSpeed:getActive()
    data["objectToDisable"] = self.objectToDisable.Active
    return data
end

function ToggleProgressiveSwitcheroo:load(data)
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

function ToggleProgressiveSwitcheroo:propertyChanged(key, value)
    self:updateIcon()
end