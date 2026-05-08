ToggleProgressive = CustomItem:extend()

--local myImagePathObjectToDisable = ""
--local myCodeObjectToDisable = ""
--thingsToHide = {"eye", "phantoon", "walljumpBoots", "canWalljump"}
--objectToDisableImage = "images/walljumpboots.png"
--function ToggleProgressive:init(name, code, imagePath)



function ToggleProgressive:init(name, code, imagePath, imagePathDisabled, codeObjectToDisable, imagePathObjectToDisable, defaultState, itemType)
    self:createItem(name)
    self.code = code
    self.objectToDisable = Tracker:FindObjectForCode(codeObjectToDisable)
    self:setProperty("active", defaultState)
    self.activeImage = ImageReference:FromPackRelativePath(imagePath)
    self.disabledImage = ImageReference:FromPackRelativePath(imagePathDisabled)
    self.ItemInstance.PotentialIcon = self.activeImage

    --myCodeObjectToDisable = codeObjectToDisable
    --myImagePathObjectToDisable = imagePathObjectToDisable

    --self.codeObjectToDisable = codeObjectToDisable
    self.otherDisabledImage = ImageReference:FromPackRelativePath(imagePathObjectToDisable, "@disabled")

    self.itemType = itemType
    print(self.codeObjectToDisable)
    --self.ItemInstance.Icon = self.disabledImage
    self.ItemInstance.Icon = self.activeImage
    self:updateIcon()    
end

function ToggleProgressive:setActive(active)
    self:setProperty("active", active)
end

function ToggleProgressive:getActive()
    return self:getProperty("active")
end

function ToggleProgressive:updateIcon()
    --print(self.codeObjectToDisable)
    --print(type(self.codeObjectToDisable))

    if self:getActive() then
        print(self.objectToDisable == nil)
        self.ItemInstance.Icon = self.activeImage
        --print(self.objectToDisable)
        --self.objectToDisable:setActive(false)

        print("im here now!")
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
        self:updateObjectToDisable(true)
        --return
        --self.objectToDisable.Active = false

        --self.objectToDisable.Icon = self.otherDisabledImage
        --self.objectToDisable.IgnoreUserInput = false
    else
        self.ItemInstance.Icon = self.disabledImage
        
        self:updateObjectToDisable(false)
        --return
        --item.CurrentStage = 1--Dont bring this one back
        --self.objectToDisable.Icon = nil
        --self.objectToDisable.IgnoreUserInput = true
    end
end

function ToggleProgressive:updateObjectToDisable(active)
    if (active) then
        self.objectToDisable.Active = false
        self.objectToDisable.Icon = self.otherDisabledImage
        self.objectToDisable.IgnoreUserInput = false
    else
        self.objectToDisable.Icon = nil
        self.objectToDisable.IgnoreUserInput = true
    end
end

function ToggleProgressive:loadObjectToDisable()
    if (self.objectToDisable.Active) then
        self.objectToDisable.Active = false
        self.objectToDisable.Icon = self.otherDisabledImage
        self.objectToDisable.IgnoreUserInput = false
    else
        self.objectToDisable.Icon = nil
        self.objectToDisable.IgnoreUserInput = true
    end
end

function ToggleProgressive:onLeftClick()
    self:setActive(not self:getActive())
end

function ToggleProgressive:onRightClick()
    self:setActive(not self:getActive())
end

function ToggleProgressive:canProvideCode(code)
    if code == self.code then
        return true
    else
        return false
    end
end

function ToggleProgressive:providesCode(code)
    if code == self.code and self.getActive() then
        return 1
    end
    return 0
end

function ToggleProgressive:advanceToCode(code)
    if code == nil or code == self.code then
        self:setActive(true)
    end
end

function ToggleProgressive:save()
    --print(self:getActive())

    local data = {}
    data["active"] = self:getActive()
    data["objectToDisable"] = self.objectToDisable.Active
    return data
end

function ToggleProgressive:load(data)
    if data["active"] ~= nil then
        self:setActive(data["active"])
        self:updateIcon()
        self.objectToDisable.Active = data["objectToDisable"]
    end
    --print(self:getActive())
    return true
end

function ToggleProgressive:propertyChanged(key, value)
    self:updateIcon()
end