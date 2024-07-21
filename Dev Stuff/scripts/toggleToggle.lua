ToggleToggle = CustomItem:extend()

--local myImagePathObjectToDisable = ""
--local myCodeObjectToDisable = ""
--thingsToHide = {"eye", "phantoon", "walljumpBoots", "canWalljump"}
--objectToDisableImage = "images/walljumpboots.png"
--function ToggleToggle:init(name, code, imagePath)



function ToggleToggle:init(name, code, imagePath, imagePathDisabled, codeObjectToDisable, imagePathObjectToDisable, defaultState, itemType)
    self:createItem(name)
    self.code = code
    self.objectToDisable = Tracker:FindObjectForCode(codeObjectToDisable)
    --print("here1")
    self:setProperty("active", defaultState)
    --print("here2")
    self.activeImage = ImageReference:FromPackRelativePath(imagePath)
    --print("here3")
    self.disabledImage = ImageReference:FromPackRelativePath(imagePathDisabled)
    self.ItemInstance.PotentialIcon = self.activeImage

    --self.imageNil = ImageReference:FromPackRelativePath(imageNilPath)

    --myCodeObjectToDisable = codeObjectToDisable
    --myImagePathObjectToDisable = imagePathObjectToDisable

    --self.codeObjectToDisable = codeObjectToDisable
    --print(self.objectToDisable == nil)
    --self.objectToDisable = Tracker:FindObjectForCode(codeObjectToDisable)
    --print(self.objectToDisable == nil)

    self.otherDisabledImage = ImageReference:FromPackRelativePath(imagePathObjectToDisable)

    --self.itemType = itemType
    --print(self.objectToDisable == nil)
    print("do")
    --self.ItemInstance.Icon = self.disabledImage
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
    --print(self.codeObjectToDisable)
    --print(type(self.codeObjectToDisable))

    if self:getActive() then
        --print(self.objectToDisable == nil)
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

        self.objectToDisable.CurrentStage = 2

        self.objectToDisable.Icon = self.otherDisabledImage
        self.objectToDisable.IgnoreUserInput = false
    else
        self.ItemInstance.Icon = self.disabledImage
    
        --item.CurrentStage = 1--Dont bring this one back
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
    print(self:getActive())

    local saveData = {}
    saveData["active"] = self.getActive()
    return saveData
end

function ToggleToggle:Load(data)
    if data["active"] ~= nil then
        self:setActive(data["active"])
    end
    print(self:getActive())
    self:updateIcon()
    return true
end

function ToggleToggle:propertyChanged(key, value)
    self:updateIcon()
end